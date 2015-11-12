//
//  MoviePreViewController.swift
//  babyCame
//
//  Created by taro on 2015/11/07.
//  Copyright © 2015年 taro. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AssetsLibrary

class MoviePreViewController: UIViewController {
    
    @IBOutlet var playerView: AVPlayerView!
    var videoPlayer: AVPlayer!
    var videoPath: NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        playMovie()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didTapBackButton(sender: AnyObject) {
        showBackActionSheet()
    }
    
    @IBAction func didTapActionButton(sender: AnyObject) {
        showShareActionSheet()
    }
    
    func playMovie() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let fileURL = NSURL(fileURLWithPath: documentsPath)
        let avAsset = AVURLAsset(URL: fileURL, options: nil)
        let playerItem = AVPlayerItem(asset: avAsset)
        
        videoPlayer = AVPlayer(playerItem: playerItem)
        
        let layer = playerView.layer as! AVPlayerLayer
        layer.videoGravity = AVLayerVideoGravityResizeAspect
        layer.player = videoPlayer
        
        videoPlayer.play()
    }
    
    func showBackActionSheet() {
        let actionSheet = UIAlertController(title: "ゲームを変える？", message: "もう一度撮影する？", preferredStyle: .ActionSheet)
        let backToViewControllerAction = UIAlertAction(title: "ゲーム選択画面に戻る", style: .Default, handler: { (action: UIAlertAction) -> Void in
            self.performSegueWithIdentifier("UnwindToTop", sender: self)
        })
        let backToGameViewControllerAction = UIAlertAction(title: "もう一度撮影する", style: .Default, handler: { (action: UIAlertAction) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
        
        actionSheet.addAction(backToViewControllerAction)
        actionSheet.addAction(backToGameViewControllerAction)
        actionSheet.addAction(cancelAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showShareActionSheet() {
        let actionSheet = UIAlertController(title: "シェアする？", message: "保存する？", preferredStyle: .ActionSheet)
        let facebookAction = UIAlertAction(title: "Facebook", style: .Default, handler: { (action: UIAlertAction) -> Void in
            let facebook = FacebookClient(viewController: self)
            facebook.login()
        })
        let twitterAction = UIAlertAction(title: "Twitter", style: .Default, handler: { (action: UIAlertAction) -> Void in
            
        })
        let saveAction = UIAlertAction(title: "カメラロールに保存", style: .Default, handler: { (action: UIAlertAction) -> Void in
            self.saveMovieToCameraRoll()
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
        
        actionSheet.addAction(facebookAction)
        actionSheet.addAction(twitterAction)
        actionSheet.addAction(saveAction)
        actionSheet.addAction(cancelAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func saveMovieToCameraRoll() {
        let assetsLib = ALAssetsLibrary()
        assetsLib.writeVideoAtPathToSavedPhotosAlbum(self.videoPath, completionBlock: { (url: NSURL!, error: NSError!) -> Void in
            self.showSavedVideoConfirmAlert()
        })
    }
    
    func showSavedVideoConfirmAlert() {
        let alertController = UIAlertController(title: "保存完了！", message: "ムービーをカメラロールに保存しました", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertController.addAction(okAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}
