//
//  Sound.swift
//  babyCame
//
//  Created by インターピア株式会社 on 2016/03/23.
//  Copyright © 2016年 taro. All rights reserved.
//

import UIKit
import AVFoundation

class Sound: UIView, Playable {
    
    @IBOutlet weak var guitarImageView: UIImageView!
    @IBOutlet weak var drumImageView: UIImageView!
    @IBOutlet weak var pianoImageView: UIImageView!
    @IBOutlet weak var bassImageView: UIImageView!
    
    var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    let guitarArray = ["guitar1", "guitar2", "guitar3"]
    let drumArray = ["cymbal", "snare", "tom"]
    let pianoArray = ["piano1", "piano2", "piano3"]
    let bassArray = ["bass1", "bass2", "bass3"]

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        var imageView = UIImageView()
        
        for touch: UITouch in touches {
            switch touch.view!.tag {
            case 1:
                imageView = guitarImageView
                playSound(guitarArray[Int(arc4random_uniform(2))], audioPlayer: &self.audioPlayer)
            case 2:
                imageView = drumImageView
                playSound(drumArray[Int(arc4random_uniform(2))], audioPlayer: &self.audioPlayer)
            case 3:
                imageView = pianoImageView
                playSound(pianoArray[Int(arc4random_uniform(2))], audioPlayer: &self.audioPlayer)
            case 4:
                imageView = bassImageView
                playSound(bassArray[Int(arc4random_uniform(2))], audioPlayer: &self.audioPlayer)
            default:
                break
            }
        }
        
        UIView.animateWithDuration(2.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1.5,
            options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                imageView.layer.position = CGPointMake(self.frame.width - 50, 100)
        }) { (Bool) -> Void in
            imageView.center = self.center
        }
    }

}
