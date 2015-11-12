//
//  FacebookClient.swift
//  babyCame
//
//  Created by インターピア株式会社 on 2015/11/11.
//  Copyright © 2015年 taro. All rights reserved.
//

import Foundation

class FacebookClient {
    
    var viewController: MoviePreViewController!
    
    init(viewController: MoviePreViewController) {
        self.viewController = viewController
    }
    
    func login() {
        if (FBSDKAccessToken.currentAccessToken() != nil) {

        } else {
            let login:FBSDKLoginManager = FBSDKLoginManager()
            login.logInWithReadPermissions(["email"], fromViewController: self.viewController, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
                
                if error != nil {
                    print("error!")
                    FBSDKLoginManager().logOut()
                } else if result.isCancelled {
                    print("cancelled!")
                    FBSDKLoginManager().logOut()
                } else {
                    print("success!")
                }
            })
        }
    }
}