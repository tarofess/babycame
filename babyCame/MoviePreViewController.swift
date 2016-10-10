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
import FBSDKShareKit

class MoviePreViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FBSDKSharingDelegate {
    
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
    
    // MARK: - Camera
    
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
    
    func selectFromLibrary() {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
            self.showActivityIndicator()
            
            let facebbok = FacebookSharer(url: imageURL, moviePreViewController: self)
            facebbok.post(completion: { (result: FacebookResult) in
                switch result {
                case .success:
                    break
                case .failure:
                    self.showFailureShareAlert(errorMessage: NSLocalizedString("share_failureMessage", comment: ""))
                case .noSettingAccountFailure:
                    picker.dismiss(animated: true, completion: {
                        self.showFailureShareAlert(errorMessage: NSLocalizedString("share_failure_no_account_setting", comment: ""))
                    })
                }
            })
            DispatchQueue.main.async {
                self.removeActivityIndicator()
            }
        }
    }
    
    // MARK: - AlertController
    
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
        let facebookAction = UIAlertAction(title: "Facebook(you need to save this video before share)", style: .default, handler: { (action: UIAlertAction) in
            self.selectFromLibrary()
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
    
    // MARK: - ActivityIndicator
    
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
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RunPlayerViewController" {
            let playerViewController = segue.destination as! PlayerViewController
            playerViewController.videoPath = self.videoPath
        }
    }
    
    // MARK: - FBDelegate
    
    public func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        dismiss(animated: true, completion: nil)
    }
    
    public func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        dismiss(animated: true, completion: {
            self.showFailureShareAlert(errorMessage: NSLocalizedString("share_failureMessage", comment: ""))
        })
    }
    
    public func sharerDidCancel(_ sharer: FBSDKSharing!) {
        
    }
    
}
