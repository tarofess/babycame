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

class TwitterSharer: NSObject {
    
    var videoPathURL: URL
    var account: ACAccount!
    let twitterUploadURL = URL(string: "https://upload.twitter.com/1.1/media/upload.json")
    let twitterStatusURL = URL(string: "https://api.twitter.com/1.1/statuses/update.json")
    
    init(url: URL) {
        videoPathURL = url
    }
    
    func authAccount(completion: @escaping (_ error: Bool)->Void) {
        let accountStore = ACAccountStore()
        let accountType:ACAccountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccounts(with: accountType, options: nil) { (granted, error) -> Void in
            if error != nil {
                print("error! \(error)")
                return
            }

            if !granted {
                print("error! Twitterアカウントの利用が許可されていません")
                return
            }
            
            let accounts = accountStore.accounts(with: accountType) as! [ACAccount]
            if accounts.count == 0 {
                print("error! 設定画面からアカウントを設定してください")
                return
            }
            
            print("アカウント取得完了")
            
            self.account = accounts.first!
            
            guard let mediaData = NSData(contentsOf: self.videoPathURL) else {
                completion(false)
                return
            }
            
            self.postMedia(tweet: "test", mediaData: mediaData as Data, fileSize: String(mediaData.length), completion: completion)
        }
    }
    
    func post(completion: @escaping (_ error: Bool)->Void) {
        authAccount(completion: completion)
    }
    
    private func postMedia(tweet: String, mediaData: Data, fileSize: String, completion: @escaping (_ error: Bool)->Void) {
        var json: [String: Any]!
        // INIT リクエスト
        uploadVideoInitRequest(fileSize: fileSize, success: { (_ responseData: Data)->Void in
            do {
                json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! [String: Any]
            } catch {
                completion(false)
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
                        if error != nil {
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                }, completion: { (_ error: Bool) -> Void in
                    if error {
                        completion(false)
                    }
                })
            }, completion: { (_ error: Bool) -> Void in
                if error {
                    completion(false)
                }
            })
        }, completion: { (_ error: Bool) -> Void in
            if error {
                completion(false)
            }
        })
    }
    
    // INIT リクエスト
    private func uploadVideoInitRequest(fileSize: String, success: @escaping (_ responseData: Data)->Void, completion: @escaping (_ error: Bool)->Void) {
        let initParams: [String: Any] = ["command": "INIT", "media_type": "video/mp4", "total_bytes": fileSize]
        let initRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .POST, url: self.twitterUploadURL, parameters: initParams)
        initRequest!.account = account
        initRequest!.perform { (responseData, urlResponse, error) -> Void in
            
            if error == nil {
                success(responseData!)
            } else {
                completion(false)
                return
            }
        }
    }
    
    // APPEND リクエスト
    private func uploadVideoAppendRequest(mediaData: Data, mediaIdString: String, success: @escaping () -> Void, completion: @escaping (_ error: Bool)->Void) {
        let appendParam: [NSString: Any] = ["command": "APPEND", "media_id": mediaIdString, "segment_index": "0"]
        let appendRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .POST, url: self.twitterUploadURL, parameters: appendParam)
        appendRequest?.addMultipartData(mediaData, withName: "media", type: "video/mov", filename: nil)
        appendRequest?.account = account
        appendRequest?.perform { (responseData, urlResponse, error) -> Void in
            
            if urlResponse!.statusCode < 300 && urlResponse!.statusCode >= 200 {
                success()
            } else {
                completion(false)
                return
            }
        }
    }
    
    // FINALIZE リクエスト
    private func uploadVideoFinalizeRequest(mediaIdString: String, success: @escaping (_ responseData: Data) -> Void, completion: @escaping (_ error: Bool)->Void) {
        let finalizeParam: [NSString: Any] = ["command": "FINALIZE", "media_id": mediaIdString]
        let finalizeRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .POST, url: self.twitterUploadURL, parameters: finalizeParam)
        finalizeRequest?.account = account
        finalizeRequest?.perform { (responseData, urlResponse, error) -> Void in
            
            if error == nil {
                success(responseData!)
            } else {
                completion(false)
                return
            }
        }
    }

}
