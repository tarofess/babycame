//
//  Bubble.swift
//  babyCame
//
//  Created by インターピア株式会社 on 2016/03/23.
//  Copyright © 2016年 taro. All rights reserved.
//

import UIKit
import AVFoundation

class Bubble: UIView, Playable {
    
    @IBOutlet weak var bubbleImageView1: UIImageView!
    @IBOutlet weak var bubbleImageView2: UIImageView!
    @IBOutlet weak var bubbleImageView3: UIImageView!
    @IBOutlet weak var bubbleImageView4: UIImageView!
    @IBOutlet weak var bubbleImageView5: UIImageView!
    @IBOutlet weak var bubbleImageView6: UIImageView!
    @IBOutlet weak var bubbleImageView7: UIImageView!
    
    var audioPlayer: AVAudioPlayer = AVAudioPlayer()

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        var imageView = UIImageView()
        
        for touch: UITouch in touches {
            switch touch.view!.tag {
            case 1:
                imageView = bubbleImageView1
            case 2:
                imageView = bubbleImageView2
            case 3:
                imageView = bubbleImageView3
            case 4:
                imageView = bubbleImageView4
            case 5:
                imageView = bubbleImageView5
            case 6:
                imageView = bubbleImageView6
            case 7:
                imageView = bubbleImageView7
            default:
                break
            }
        }
        
        UIView.animateWithDuration(NSTimeInterval(0), animations: {() -> Void in
            imageView.alpha = 0
            }, completion: {(Bool) -> Void in
                UIView.animateWithDuration(NSTimeInterval(1.0), animations: {() -> Void in
                    imageView.alpha = 1.0
                    }, completion: {(Bool) -> Void in
                })
        })
        playSound("bubble", audioPlayer: &self.audioPlayer)
    }

}
