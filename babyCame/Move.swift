//
//  Move.swift
//  babyCame
//
//  Created by インターピア株式会社 on 2016/03/23.
//  Copyright © 2016年 taro. All rights reserved.
//

import UIKit
import AVFoundation

class Move: UIView, Playable {
    
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var bicycleImageView: UIImageView!
    @IBOutlet weak var sirenImageView: UIImageView!
    @IBOutlet weak var patrolImageView: UIImageView!
    @IBOutlet weak var bikeImageView: UIImageView!
    
    var audioPlayer: AVAudioPlayer = AVAudioPlayer()

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        var imageView = UIImageView()
        
        for touch: UITouch in touches {
            switch touch.view!.tag {
            case 1:
                imageView = carImageView
                playSound("car", audioPlayer: &self.audioPlayer)
            case 2:
                imageView = bicycleImageView
                playSound("bicycle", audioPlayer: &self.audioPlayer)
            case 3:
                imageView = sirenImageView
                playSound("siren", audioPlayer: &self.audioPlayer)
            case 4:
                imageView = patrolImageView
                playSound("patrol", audioPlayer: &self.audioPlayer)
            case 5:
                imageView = bikeImageView
                playSound("bike", audioPlayer: &self.audioPlayer)
            default:
                break
            }
        }
        imageView.layer.position = CGPointMake(imageView.center.x, imageView.center.y)
        
        UIView.animateWithDuration(NSTimeInterval(CGFloat(3.0)), animations: {() -> Void in
                                    imageView.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
            }, completion: {(Bool) -> Void in
        })
    }


}
