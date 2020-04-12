//
//  GameViewController.swift
//  babyCame
//
//  Created by taro on 2015/11/07.
//  Copyright © 2015年 taro. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos

class GameViewController : UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    let fileOutput = AVCaptureMovieFileOutput()
    let captureSession = AVCaptureSession()
    private var timer: Timer!
    private var timeLeft: Int!
    private var didTouchScreenOnce = false
    var indexPath: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        showGame()
        setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        didTouchScreenOnce = false
        setTimeLeft()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !didTouchScreenOnce {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameViewController.updateTime), userInfo: nil, repeats: true)
            didTouchScreenOnce = true
            
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0] as String
            let filePath : String? = "\(documentsDirectory)/temp.mp4"
            let fileURL : NSURL = NSURL(fileURLWithPath: filePath!)
            fileOutput.startRecording(to: fileURL as URL, recordingDelegate: self)
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
        }) { completed, error in
            if completed {
                DispatchQueue.main.async {
                    self.showCompletionAlert(outputFileURL)
                }
            }
        }
    }
    
    private func setupCamera() {
        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
        if let device = captureDevice {
            if device.position == .front {
                do {
                    let deviceInput = try AVCaptureDeviceInput(device: device)
                    captureSession.addInput(deviceInput)
                    captureSession.addOutput(fileOutput)
                    let videoDataOuputConnection = fileOutput.connection(with: .video)
                    fileOutput.setRecordsVideoOrientationAndMirroringChangesAsMetadataTrack(true, for: videoDataOuputConnection!)
                    videoDataOuputConnection!.videoOrientation = .landscapeLeft
                          
                    captureSession.startRunning()
                } catch {
                    /*error*/
                }
            }
        }
    }
    
    private func setTimeLeft() {
        timeLeft = Preferences.timeLeft ?? 15
        navigationItem.title = String(timeLeft) + NSLocalizedString("sec", comment: "")
    }
    
    private func showGame() {
        let gameCenter = GameCenter(gameIdentifier: indexPath)
        let gameView = gameCenter.getGameView()!
        gameView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        self.view.addSubview(gameView)
    }
    
    @objc func updateTime() {
        if timeLeft > 1 {
            timeLeft -= 1
            navigationItem.title = String(timeLeft) + NSLocalizedString("sec", comment: "")
        } else {
            timer.invalidate()
            navigationItem.title = String(0) + NSLocalizedString("sec", comment: "")
            
            fileOutput.stopRecording()
        }
    }
    
    private func showCompletionAlert(_ videoPath: URL) {
        let alertController = UIAlertController(title: NSLocalizedString("finish_take_alertTitle", comment: ""), message: NSLocalizedString("finish_take_alertMessage", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("alertOK_action", comment: ""), style: .default, handler: { (action: UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "RunMoviePreViewController", sender: videoPath)
        })
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let moviePreViewController = segue.destination as! MoviePreViewController
        moviePreViewController.videoPath = sender as? URL
    }
    
}
