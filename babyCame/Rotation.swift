//
//  Rotation.swift
//  babyCame
//
//  Created by インターピア株式会社 on 2016/03/23.
//  Copyright © 2016年 taro. All rights reserved.
//

import UIKit

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate
        }
        self.layer.addAnimation(rotateAnimation, forKey: nil)
    }
}

class Rotation: UIView {

    @IBOutlet weak var moonImageView: UIImageView!
    @IBOutlet weak var redStarImageView: UIImageView!
    @IBOutlet weak var yellowStarImageView: UIImageView!
    @IBOutlet weak var yellowStarImageView2: UIImageView!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        var imageView = UIImageView()
        
        for touch: UITouch in touches {
            switch touch.view!.tag {
            case 1:
                imageView = moonImageView
                imageView.rotate360Degrees()
                return
            case 2:
                imageView = redStarImageView
            case 3:
                imageView = yellowStarImageView
            case 4:
                imageView = yellowStarImageView2
            default:
                break
            }
        }
        imageView.transform = CGAffineTransformMakeRotation(0)
        let angle:CGFloat = CGFloat(M_PI)
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
                                    imageView.transform = CGAffineTransformMakeRotation(angle)
            }, completion: { (Bool) -> Void in
        })
    }

}
