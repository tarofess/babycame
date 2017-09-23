//
//  TwitterSharer.swift
//  babyCame
//
//  Created by taro on 2016/10/08.
//  Copyright © 2016年 taro. All rights reserved.
//

import UIKit
import Accounts
import Social
import AVFoundation

enum Result {
    case success
    case failure
    case noPermissionAccountFailure
    case noSettingAccountFailure
}

class TwitterSharer: NSObject {
    
    var videoPathURL: URL
    var tweet: String
    var account: ACAccount!
    let twitterUploadURL = URL(string: "https://upload.twitter.com/1.1/media/upload.json")
    let twitterStatusURL = URL(string: "https://api.twitter.com/1.1/statuses/update.json")
    
    init(url: URL, tweet: String) {
        videoPathURL = url
        self.tweet = tweet
    }
    
    func authAccount(completion: @escaping (_ result: Result)->Void) {
        let accountStore = ACAccountStore()
        let accountType:ACAccountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccounts(with: accountType, options: nil) { (granted, error) -> Void in
            if error != nil {
                print("error! \(error)")
                completion(.failure)
                return
            }

            if !granted {
                completion(.noPermissionAccountFailure)
                return
            }
            
            let accounts = accountStore.accounts(with: accountType) as! [ACAccount]
            if accounts.count == 0 {
                completion(.noSettingAccountFailure)
                return
            }
            
            self.account = accounts.first!
            
            self.compressVideo(compressCompletion: {(success, compressedData) in
                if success {
                    self.postMedia(tweet: self.tweet, mediaData: compressedData as! Data, fileSize: String(compressedData!.length), completion: completion)
                } else {
                    completion(.failure)
                }
            })
        }
    }
    
    func post(completion: @escaping (_ result: Result)->Void) {
        authAccount(completion: completion)
    }
    
    private func postMedia(tweet: String, mediaData: Data, fileSize: String, completion: @escaping (_ result: Result)->Void) {
        var json: [String: Any]!
        
        // INIT リクエスト
        uploadVideoInitRequest(fileSize: fileSize, success: { (_ responseData: Data)->Void in
            do {
                json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! [String: Any]
            } catch {
                completion(.failure)
                return
            }
            
            let mediaIdString = json["media_id_string"] as! String
            
            // APPEND リクエスト
            self.uploadVideoAppendRequest(mediaData: mediaData, mediaIdString: mediaIdString, success: { () -> Void in
                
                // FINALIZE リクエスト
                self.uploadVideoFinalizeRequest(mediaIdString: mediaIdString, success: { (_ responseData: Data) -> Void in
                    
                    let statusRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .POST, url: self.twitterStatusURL, parameters: ["status" : tweet, "media_ids" : mediaIdString])
                    
                    statusRequest?.account = self.account
                    
                    // 動画をつけてツイート
                    statusRequest?.perform { (responseData, urlResponse, error) -> Void in
                        if error == nil {
                            completion(.success)
                        } else {
                            completion(.failure)
                        }
                    }
                }, completion: { (_ result: Result) -> Void in
                    completion(.failure)
                })
            }, completion: { (_ result: Result) -> Void in
                completion(.failure)
            })
        }, completion: { (_ result: Result) -> Void in
            completion(.failure)
        })
    }
    
    // INIT リクエスト
    private func uploadVideoInitRequest(fileSize: String, success: @escaping (_ responseData: Data)->Void, completion: @escaping (_ result: Result)->Void) {
        let initParams: [String: Any] = ["command": "INIT", "media_type": "video/mp4", "total_bytes": fileSize]
        let initRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .POST, url: self.twitterUploadURL, parameters: initParams)
        initRequest!.account = account
        initRequest!.perform { (responseData, urlResponse, error) -> Void in
            
            if error == nil {
                success(responseData!)
            } else {
                completion(.failure)
                return
            }
        }
    }
    
    // APPEND リクエスト
    private func uploadVideoAppendRequest(mediaData: Data, mediaIdString: String, success: @escaping () -> Void, completion: @escaping (_ result: Result)->Void) {
        let appendParam: [NSString: Any] = ["command": "APPEND", "media_id": mediaIdString, "segment_index": "0"]
        let appendRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .POST, url: self.twitterUploadURL, parameters: appendParam)
        appendRequest?.addMultipartData(mediaData, withName: "media", type: "video/mov", filename: nil)
        appendRequest?.account = account
        appendRequest?.perform { (responseData, urlResponse, error) -> Void in
            
            if urlResponse!.statusCode < 300 && urlResponse!.statusCode >= 200 {
                success()
            } else {
                completion(.failure)
                return
            }
        }
    }
    
    // FINALIZE リクエスト
    private func uploadVideoFinalizeRequest(mediaIdString: String, success: @escaping (_ responseData: Data) -> Void, completion: @escaping (_ result: Result)->Void) {
        let finalizeParam: [NSString: Any] = ["command": "FINALIZE", "media_id": mediaIdString]
        let finalizeRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .POST, url: self.twitterUploadURL, parameters: finalizeParam)
        finalizeRequest?.account = account
        finalizeRequest?.perform { (responseData, urlResponse, error) -> Void in
            
            if error == nil {
                success(responseData!)
            } else {
                completion(.failure)
                return
            }
        }
    }
    
    func compressVideo(compressCompletion: @escaping (_ success: Bool, _ compressedData: NSData?)->Void) {
        let urlAsset = AVURLAsset(url: self.videoPathURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            compressCompletion(false, nil)
            return
        }
        
        var filePath = NSTemporaryDirectory()
        filePath = filePath + "temp.mov"
        do {
            try FileManager.default.removeItem(atPath: filePath)
        } catch {
            
        }
        
        exportSession.outputURL = URL(fileURLWithPath: filePath)
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .unknown:
                compressCompletion(false, nil)
            case .waiting:
                compressCompletion(false, nil)
            case .exporting:
                compressCompletion(false, nil)
            case .completed:
                guard let data = NSData(contentsOf: exportSession.outputURL!) else {
                    compressCompletion(false, nil)
                    return
                }
                compressCompletion(true, data)
            case .failed:
                print(exportSession.error.debugDescription)
                compressCompletion(false, nil)
            case .cancelled:
                compressCompletion(false, nil)
            }
        }
    }

}
