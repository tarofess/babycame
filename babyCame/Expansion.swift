//
//  GameView.swift
//  babyCame
//
//  Created by taro on 2015/11/07.
//  Copyright © 2015年 taro. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Expansion: UIView, Playable {
    
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var goatImageView: UIImageView!
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var elephantImageView: UIImageView!
    @IBOutlet weak var chikenImageView: UIImageView!
    
    var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        print("tapped")
        
        var imageView = UIImageView()
        
        for touch: UITouch in touches {
            switch touch.view!.tag {
            case 1:
                imageView = catImageView
                playSound("cat", audioPlayer: &self.audioPlayer)
            case 2:
                imageView = goatImageView
                playSound("goat", audioPlayer: &self.audioPlayer)
            case 3:
                imageView = dogImageView
                playSound("dog", audioPlayer: &self.audioPlayer)
            case 4:
                imageView = elephantImageView
                playSound("elephant", audioPlayer: &self.audioPlayer)
            case 5:
                imageView = chikenImageView
                playSound("chiken", audioPlayer: &self.audioPlayer)
            default:
                break
            }
        }
        imageView.transform = CGAffineTransformMakeScale(1, 1)
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
                                    imageView.transform = CGAffineTransformMakeScale(2.0, 2.0)
                                    imageView.userInteractionEnabled = false })
        { (Bool) -> Void in
            UIView.animateWithDuration(1.0,
                animations: { () -> Void in
                    imageView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                })
            { (Bool) -> Void in
                imageView.transform = CGAffineTransformMakeScale(1, 1)
                imageView.userInteractionEnabled = true
            }
        }
    }
}