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
    let videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    let audioDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
    let fileOutput = AVCaptureMovieFileOutput()
    
    var timer: Timer!
    var indexPath: Int!
    var timeLeft = 15
    var didTouchScreenOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timeLeft = 15
        didTouchScreenOnce = false
        navigationBar.topItem?.title = String(timeLeft) + "秒"
        
        showGame()
        self.view.bringSubview(toFront: navigationBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !didTouchScreenOnce {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameViewController.updateTime), userInfo: nil, repeats: true)
            startRecording()
            didTouchScreenOnce = true
        }
    }
    
    func showGame() {
        let gameCenter = GameCenter(gameIdentifier: indexPath)
        let gameView = gameCenter.getGameView()!
        gameView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        self.view.addSubview(gameView)
    }
    
    func startRecording() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as String
        let filePath : String? = "\(documentsDirectory)/baby\(UUID().uuidString).mov"
        let fileURL = URL(fileURLWithPath: filePath!)
        fileOutput.startRecording(toOutputFileURL: fileURL, recordingDelegate: self)
    }
    
    func updateTime() {
        if timeLeft > 1 {
            timeLeft -= 1
            navigationBar.topItem?.title = String(timeLeft) + "秒"
        } else {
            timer.invalidate()
            fileOutput.stopRecording()
        }
    }
    
    func showCompletionAlert(_ videoPath: URL) {
        let alertController = UIAlertController(title: "撮影完了", message: "撮影したムービーを見てみましょう！", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "RunMoviePreViewController", sender: videoPath)
        })
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func setUpCamera() {
        let devices = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .front).devices
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: devices?.first!) as AVCaptureDeviceInput
            captureSession.addInput(videoInput)
            let audioInput = try AVCaptureDeviceInput(device: audioDevice) as AVCaptureDeviceInput
            captureSession.addInput(audioInput);
        } catch {
            
        }
        captureSession.commitConfiguration()
        captureSession.addOutput(fileOutput)
        captureSession.startRunning()
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        showCompletionAlert(outputFileURL)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let moviePreViewController = segue.destination as! MoviePreViewController
        moviePreViewController.videoPath = sender as! URL
    }
    
}
