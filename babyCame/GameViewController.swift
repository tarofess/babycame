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
import SwiftyCam

class GameViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate {

    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var timer: Timer!
    var indexPath: Int!
    var timeLeft: Int!
    var didTouchScreenOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        cameraDelegate = self
        self.defaultCamera = .front
    }
    
    override func viewWillAppear(_ animated: Bool) {
        didTouchScreenOnce = false
        setTimeLeft()
        showGame()
        self.view.bringSubview(toFront: navigationBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !didTouchScreenOnce {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameViewController.updateTime), userInfo: nil, repeats: true)
            startVideoRecording()
            didTouchScreenOnce = true
        }
    }
    
    func setTimeLeft() {
        timeLeft = Preferences.timeLeft ?? 15
        navigationItem.title = String(timeLeft) + NSLocalizedString("sec", comment: "")
    }
    
    func showGame() {
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
            stopVideoRecording()
        }
    }
    
    func showCompletionAlert(_ videoPath: URL) {
        let alertController = UIAlertController(title: NSLocalizedString("finish_take_alertTitle", comment: ""), message: NSLocalizedString("finish_take_alertMessage", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("alertOK_action", comment: ""), style: .default, handler: { (action: UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "RunMoviePreViewController", sender: videoPath)
        })
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        showCompletionAlert(url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let moviePreViewController = segue.destination as! MoviePreViewController
        moviePreViewController.videoPath = sender as? URL
    }
    
}
