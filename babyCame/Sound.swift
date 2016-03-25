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
    
    var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    let guitarArray = ["guitar1", "guitar2", "guitar3"]
    let drumArray = ["cymbal", "snare", "tom"]
    let pianoArray = ["piano1", "piano2", "piano3"]
    let bassArray = ["bass1", "bass2", "bass3"]

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        for touch: UITouch in touches {
            switch touch.view!.tag {
            case 1:
                playSound(guitarArray[Int(arc4random_uniform(3))], audioPlayer: &self.audioPlayer)
            case 2:
                playSound(drumArray[Int(arc4random_uniform(3))], audioPlayer: &self.audioPlayer)
            case 3:
                playSound(pianoArray[Int(arc4random_uniform(3))], audioPlayer: &self.audioPlayer)
            case 4:
                playSound(bassArray[Int(arc4random_uniform(3))], audioPlayer: &self.audioPlayer)
            default:
                break
            }
        }
    }

}
