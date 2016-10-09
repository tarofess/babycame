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
    var activityIndicator: UIActivityIndicatorView!
    
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
        let alertController = UIAlertController(title: NSLocalizedString("share_actionSheetTitle", comment: ""), message: NSLocalizedString("share_actionSheetMessage", comment: ""), preferredStyle: .actionSheet)
        let saveAction = UIAlertAction(title: NSLocalizedString("share_actionSheetSave", comment: ""), style: .default, handler: { (action: UIAlertAction) in
            self.saveMovieToCameraRoll()
        })
        let facebookAction = UIAlertAction(title: "Facebook", style: .default, handler: { (action: UIAlertAction) in
            let facebbok = FacebookSharer()
            facebbok.post(videoPath: self.videoPath) {
                self.showCompleteShareAlert()
            }
        })
        let twitterAction = UIAlertAction(title: "Twitter", style: .default, handler: { (action: UIAlertAction) in
            self.showActivityIndicator()
            
            let twitter = TwitterSharer(url: self.videoPath)
            twitter.post(completion: { (result: Result) in
                switch result {
                case .success:
                    self.showCompleteShareAlert()
                case .failure:
                    self.showFailureShareAlert(errorMessage: NSLocalizedString("share_failureMessage", comment: ""))
                case .noPermissionAccountFailure:
                    self.showFailureShareAlert(errorMessage: NSLocalizedString("share_failure_no_permission_account", comment: ""))
                case .noSettingAccountFailure:
                    self.showFailureShareAlert(errorMessage: NSLocalizedString("share_failure_no_account_setting", comment: ""))
                }
                DispatchQueue.main.async {
                    self.removeActivityIndicator()
                }
            })
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("share_cancel", comment: ""), style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(facebookAction)
        alertController.addAction(twitterAction)
        alertController.addAction(cancelAction)
        
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
                self.showDeniedCameraAccessAlert()
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
    
    func showCompleteShareAlert() {
        let alertController = UIAlertController(title: NSLocalizedString("share_completionTitle", comment: ""), message: NSLocalizedString("share_completionMessage", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showFailureShareAlert(errorMessage: String) {
        let alertController = UIAlertController(title: NSLocalizedString("share_failureTitle", comment: ""), message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.backgroundColor = UIColor(red: 0/2555, green: 0/255, blue: 0/255, alpha: 0.7)
        activityIndicator.layer.cornerRadius = 8
        activityIndicator.center = self.view.center
        
        activityIndicator.hidesWhenStopped = false
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
    }
    
    func removeActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RunPlayerViewController" {
            let playerViewController = segue.destination as! PlayerViewController
            playerViewController.videoPath = self.videoPath
        }
    }
    
}
