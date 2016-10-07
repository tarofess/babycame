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

class MoviePreViewController: UIViewController {
    
    var videoPath: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()   
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didTapBackButton(_ sender: AnyObject) {
        showBackActionSheet()
    }
    
    @IBAction func didTapActionButton(_ sender: AnyObject) {
        showShareActionSheet()
    }
    
    func showBackActionSheet() {
        let actionSheet = UIAlertController(title: "ゲームを変えますか？", message: "もう一度撮影しますか？", preferredStyle: .actionSheet)
        let backToViewControllerAction = UIAlertAction(title: "ゲーム選択画面に戻る", style: .default, handler: { (action: UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "UnwindToTop", sender: self)
        })
        let backToGameViewControllerAction = UIAlertAction(title: "もう一度撮影する", style: .default, handler: { (action: UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        actionSheet.addAction(backToViewControllerAction)
        actionSheet.addAction(backToGameViewControllerAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showShareActionSheet() {
        let alertController = UIAlertController(title: "動画の保存", message: "カメラロールに保存しますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "はい", style: .default, handler: { (action: UIAlertAction) -> Void in
            self.saveMovieToCameraRoll()
        })
        let cancelAction = UIAlertAction(title: "いいえ", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func saveMovieToCameraRoll() {
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
                print("Restricted")
            }
        }
    }
    
    func showSavedVideoConfirmAlert() {
        let alertController = UIAlertController(title: "保存完了", message: "動画をカメラロールに保存しました", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showDeniedCameraAccessAlert() {
        let alertController = UIAlertController(title: "動画を保存できませんでした", message: "カメラロールへのアクセスを許可してください", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "はい", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RunPlayerViewController" {
            let playerViewController = segue.destination as! PlayerViewController
            playerViewController.videoPath = self.videoPath
        }
    }
    
}
