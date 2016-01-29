//
//  MoviePreViewController.swift
//  babyCame
//
//  Created by taro on 2015/11/07.
//  Copyright © 2015年 taro. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation
import AssetsLibrary
import MediaPlayer

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
//        let avAsset = AVURLAsset(URL: self.videoPath, options: nil)
//        let playerItem = AVPlayerItem(asset: avAsset)
//        
//        videoPlayer = AVPlayer(playerItem: playerItem)
//        
//        let layer = playerView.layer as! AVPlayerLayer
//        layer.videoGravity = AVLayerVideoGravityResizeAspect
//        layer.player = videoPlayer
//        
//        videoPlayer.play()
        
        let player = AVPlayer(URL: self.videoPath!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.presentViewController(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func showBackActionSheet() {
        let actionSheet = UIAlertController(title: "ゲームを変えますか？", message: "もう一度撮影しますか？", preferredStyle: .ActionSheet)
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
        let alertController = UIAlertController(title: "動画の保存", message: "カメラロールに保存しますか？", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "はい", style: .Default, handler: { (action: UIAlertAction) -> Void in
            self.saveMovieToCameraRoll()
        })
        let cancelAction = UIAlertAction(title: "いいえ", style: .Cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func saveMovieToCameraRoll() {
        let assetsLib = ALAssetsLibrary()
        assetsLib.writeVideoAtPathToSavedPhotosAlbum(self.videoPath, completionBlock: { (url: NSURL!, error: NSError!) -> Void in
            self.showSavedVideoConfirmAlert()
        })
    }
    
    func showSavedVideoConfirmAlert() {
        let alertController = UIAlertController(title: "保存完了", message: "動画をカメラロールに保存しました", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertController.addAction(okAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}
