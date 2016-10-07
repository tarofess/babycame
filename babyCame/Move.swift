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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        var imageView = UIImageView()
        var initialPosition = CGPoint(x: 0, y: 0)
        
        for touch: UITouch in touches {
            switch touch.view!.tag {
            case 1:
                imageView = carImageView
                initialPosition = CGPoint(x: imageView.center.x, y: imageView.center.y)
                imageView.layer.position = CGPoint(x: imageView.center.x, y: imageView.center.y)
                
                UIView.animate(withDuration: TimeInterval(CGFloat(2.0)), animations: {() -> Void in
                    imageView.center = CGPoint(x: initialPosition.x - 400, y: initialPosition.y)
                    }, completion: {(Bool) -> Void in
                        imageView.center = CGPoint(x: initialPosition.x, y: initialPosition.y)
                })
                playSound("car", audioPlayer: &self.audioPlayer)
            case 2:
                imageView = bicycleImageView
                initialPosition = CGPoint(x: imageView.center.x, y: imageView.center.y)
                imageView.layer.position = CGPoint(x: imageView.center.x, y: imageView.center.y)
                
                UIView.animate(withDuration: TimeInterval(CGFloat(2.0)), animations: {() -> Void in
                    imageView.center = CGPoint(x: initialPosition.x + 400, y: initialPosition.y)
                    }, completion: {(Bool) -> Void in
                        imageView.center = CGPoint(x: initialPosition.x, y: initialPosition.y)
                })
                playSound("bicycle", audioPlayer: &self.audioPlayer)
            case 3:
                imageView = sirenImageView
                initialPosition = CGPoint(x: imageView.center.x, y: imageView.center.y)
                imageView.layer.position = CGPoint(x: imageView.center.x, y: imageView.center.y)
                
                UIView.animate(withDuration: TimeInterval(CGFloat(2.0)), animations: {() -> Void in
                    imageView.center = CGPoint(x: initialPosition.x - 400, y: initialPosition.y)
                    }, completion: {(Bool) -> Void in
                        imageView.center = CGPoint(x: initialPosition.x, y: initialPosition.y)
                })
                playSound("siren", audioPlayer: &self.audioPlayer)
            case 4:
                imageView = patrolImageView
                initialPosition = CGPoint(x: imageView.center.x, y: imageView.center.y)
                imageView.layer.position = CGPoint(x: imageView.center.x, y: imageView.center.y)
                
                UIView.animate(withDuration: TimeInterval(CGFloat(2.0)), animations: {() -> Void in
                    imageView.center = CGPoint(x: initialPosition.x - 400, y: initialPosition.y)
                    }, completion: {(Bool) -> Void in
                        imageView.center = CGPoint(x: initialPosition.x, y: initialPosition.y)
                })
                playSound("patrol", audioPlayer: &self.audioPlayer)
            case 5:
                imageView = bikeImageView
                initialPosition = CGPoint(x: imageView.center.x, y: imageView.center.y)
                imageView.layer.position = CGPoint(x: imageView.center.x, y: imageView.center.y)
                
                UIView.animate(withDuration: TimeInterval(CGFloat(2.0)), animations: {() -> Void in
                    imageView.center = CGPoint(x: initialPosition.x + 400, y: initialPosition.y)
                    }, completion: {(Bool) -> Void in
                        imageView.center = CGPoint(x: initialPosition.x, y: initialPosition.y)
                })
                playSound("bike", audioPlayer: &self.audioPlayer)
            default:
                break
            }
        }
    }

}
