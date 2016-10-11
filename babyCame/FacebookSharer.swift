//
//  FacebookSharer.swift
//  babyCame
//
//  Created by taro on 2016/10/08.
//  Copyright © 2016年 taro. All rights reserved.
//

import UIKit
import Accounts
import FBSDKShareKit

enum FacebookResult {
    case success
    case failure
    case noSettingAccountFailure
}

class FacebookSharer: NSObject {
    
    var videoPathURL: URL
    var completion: ((_ result: FacebookResult)->Void)!
    var rootViewController: MoviePreViewController
    
    init(url: URL, moviePreViewController: MoviePreViewController) {
        videoPathURL = url
        rootViewController = moviePreViewController
    }

    func post(completion: @escaping (_ result: FacebookResult)->Void) {
        self.completion = completion
        
        let video = FBSDKShareVideo()
        video.videoURL = videoPathURL
        let content = FBSDKShareVideoContent()
        content.video = video
        
        let dialog = FBSDKShareDialog()
        dialog.shareContent = content
        dialog.fromViewController = rootViewController
        dialog.delegate = rootViewController
        dialog.mode = .native
        
        if dialog.canShow() {
            dialog.show()
        } else {
            completion(.noSettingAccountFailure)
        }
    }

}
