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
import Photos
import MediaPlayer
import GoogleMobileAds

class MoviePreViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GADBannerViewDelegate {
    
    @IBOutlet weak var playerView: AVPlayerView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private var videoPlayer:AVPlayer!
    private var activityIndicator: UIActivityIndicatorView!
    var videoPath: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAd()
        setNotifications()
        setPlayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        videoPlayer.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        removeLocalVideo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didTapBackButton(_ sender: AnyObject) {
        showBackActionSheet()
    }
    
    @IBAction func didTapActionButton(_ sender: AnyObject) {
        showSaveAlert()
    }
    
    private func setAd() {
        bannerView.load(GADRequest())
        self.view.bringSubview(toFront: bannerView)
    }
    
    private func setNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(removeLocalVideo), name: Notification.Name(rawValue: "removeLocalVideo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoPlayer?.currentItem)
    }
    
    // MARK: - Camera
    
    private func setPlayer() {
        let avAsset = AVURLAsset(url: videoPath, options: nil)
        let playerItem = AVPlayerItem(asset: avAsset)
        videoPlayer = AVPlayer(playerItem: playerItem)
        let layer = playerView.layer as! AVPlayerLayer
        layer.player = videoPlayer
    }
    
    private func saveMovieToCameraRoll() {
        PHPhotoLibrary.requestAuthorization { (status) -> Void in
            switch (status) {
            case .authorized:
                try! PHPhotoLibrary.shared().performChangesAndWait { () -> Void in
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.videoPath)
                    self.showSavedVideoConfirmAlert()
                }
            case .denied:
                self.showDeniedCameraAccessAlert()
            default:
                self.showDeniedCameraAccessAlert()
            }
        }
    }
    
    private func selectFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePickerController.mediaTypes = ["public.movie"]
            
            present(imagePickerController, animated: true, completion: nil)
        } else {
            print("カメラロール許可をしていない時の処理")
        }
    }
    
    @objc func removeLocalVideo() {
        do {
            let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/" + videoPath.lastPathComponent
            try FileManager.default.removeItem(atPath: filePath)
        } catch {
            print("remove error")
        }
    }
    
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: kCMTimeZero, completionHandler: nil)
            videoPlayer.play()
        }
    }
    
    // MARK: - AlertController
    
    private func showBackActionSheet() {
        let actionSheet = UIAlertController(title: NSLocalizedString("backActionSheet_title", comment: ""), message: NSLocalizedString("backActionSheet_message", comment: ""), preferredStyle: .actionSheet)
        let backToViewControllerAction = UIAlertAction(title: NSLocalizedString("backActionSheet_back", comment: ""), style: .default, handler: { (action: UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "UnwindToTop", sender: self)
        })
        let backToGameViewControllerAction = UIAlertAction(title: NSLocalizedString("backActionSheet_take_again", comment: ""), style: .default, handler: { (action: UIAlertAction) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("backActionSheet_cancel", comment: ""), style: .cancel, handler: nil)
        
        actionSheet.addAction(backToViewControllerAction)
        actionSheet.addAction(backToGameViewControllerAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func showSaveAlert() {
        let alertController = UIAlertController(title: NSLocalizedString("save_alertTitle", comment: ""), message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("save_alertOK", comment: ""), style: .default, handler: { (action: UIAlertAction) in
            self.saveMovieToCameraRoll()
        })
        let ngAction = UIAlertAction(title: NSLocalizedString("save_alertNG", comment: ""), style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(ngAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func showSavedVideoConfirmAlert() {
        let alertController = UIAlertController(title: NSLocalizedString("saveFinished_alertTitle", comment: ""), message: NSLocalizedString("saveFinished_alertMessage", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("alertOK_action", comment: ""), style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func showDeniedCameraAccessAlert() {
        let alertController = UIAlertController(title: NSLocalizedString("failedSave_alertTitle", comment: ""), message: NSLocalizedString("failedSave_alertMessage", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("alertOK_action", comment: ""), style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
