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
        let actionSheet = UIAlertController(title: NSLocalizedString("backActionSheet_title", comment: ""), message: NSLocalizedString("backActionSheet_message", comment: ""), preferredStyle: .actionSheet)
        let backToViewControllerAction = UIAlertAction(title: NSLocalizedString("backActionSheet_back", comment: ""), style: .default, handler: { (action: UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "UnwindToTop", sender: self)
        })
        let backToGameViewControllerAction = UIAlertAction(title: NSLocalizedString("backActionSheet_take_again", comment: ""), style: .default, handler: { (action: UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("backActionSheet_cancel", comment: ""), style: .cancel, handler: nil)
        
        actionSheet.addAction(backToViewControllerAction)
        actionSheet.addAction(backToGameViewControllerAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showShareActionSheet() {
        let alertController = UIAlertController(title: NSLocalizedString("save_alertTitle", comment: ""), message: NSLocalizedString("save_alertMessage", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("alertOK_action", comment: ""), style: .default, handler: { (action: UIAlertAction) -> Void in
            self.saveMovieToCameraRoll()
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("alertNG_action", comment: ""), style: .cancel, handler: nil)
        
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
        let alertController = UIAlertController(title: NSLocalizedString("saveFinished_alertTitle", comment: ""), message: NSLocalizedString("saveFinished_alertMessage", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("alertOK_action", comment: ""), style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showDeniedCameraAccessAlert() {
        let alertController = UIAlertController(title: NSLocalizedString("failedSave_alertTitle", comment: ""), message: NSLocalizedString("failedSave_alertMessage", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("alertOK_action", comment: ""), style: .default, handler: nil)
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
