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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
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
                playSound("chicken", audioPlayer: &self.audioPlayer)
            default:
                break
            }
        }
        imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
                                    imageView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                                     })
        { (Bool) -> Void in
            UIView.animate(withDuration: 1.0,
                animations: { () -> Void in
                    imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            { (Bool) -> Void in
                imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            }
        }
    }
}
