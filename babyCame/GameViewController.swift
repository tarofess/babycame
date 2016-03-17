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

class GameViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    let captureSession = AVCaptureSession()
    let videoDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    let audioDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
    let fileOutput = AVCaptureMovieFileOutput()
    
    var timer: NSTimer!
    var indexPath: Int!
    var timeLeft = 15
    var didTouchScreenOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCamera()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.timeLeft = 5
        self.didTouchScreenOnce = false
        self.navigationBar.topItem?.title = String(timeLeft) + "秒"
        
        showGame()
        self.view.bringSubviewToFront(navigationBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !self.didTouchScreenOnce {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
            startRecording()
            self.didTouchScreenOnce = true
        }
    }
    
    func showGame() {
        let gameCenter = GameCenter(gameIdentifier: self.indexPath)
        self.view.addSubview(gameCenter.getGameView()!)
    }
    
    func startRecording() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as String
        let filePath : String? = "\(documentsDirectory)/baby.mp4"
        let fileURL : NSURL = NSURL(fileURLWithPath: filePath!)
        self.fileOutput.startRecordingToOutputFileURL(fileURL, recordingDelegate: self)
    }
    
    func updateTime() {
        if self.timeLeft > 1 {
            self.timeLeft--
            self.navigationBar.topItem?.title = String(timeLeft) + "秒"
        } else {
            self.timer.invalidate()
            self.fileOutput.stopRecording()
        }
    }
    
    func showCompletionAlert(videoPath: NSURL) {
        let alertController = UIAlertController(title: "撮影完了", message: "撮影したムービーを見てみましょう！", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) -> Void in
            self.performSegueWithIdentifier("RunMoviePreViewController", sender: videoPath)
        })
        
        alertController.addAction(okAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func setUpCamera() {
        var myDevice : AVCaptureDevice?
        let devices = AVCaptureDevice.devices()
        
        for device in devices {
            if device.position == AVCaptureDevicePosition.Front {
                myDevice = device as? AVCaptureDevice
            }
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: myDevice) as AVCaptureDeviceInput
            self.captureSession.addInput(videoInput)
            let audioInput = try AVCaptureDeviceInput(device: self.audioDevice) as AVCaptureDeviceInput
            self.captureSession.addInput(audioInput);
        } catch {
            
        }
        self.captureSession.commitConfiguration()
        self.captureSession.addOutput(self.fileOutput)
        self.captureSession.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        showCompletionAlert(outputFileURL)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let moviePreViewController = segue.destinationViewController as! MoviePreViewController
        moviePreViewController.videoPath = sender as! NSURL
    }
}
