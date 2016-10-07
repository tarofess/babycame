//
//  Rotation.swift
//  babyCame
//
//  Created by インターピア株式会社 on 2016/03/23.
//  Copyright © 2016年 taro. All rights reserved.
//

import UIKit

class Rotation: UIView {

    @IBOutlet weak var moonImageView: UIImageView!
    @IBOutlet weak var redStarImageView: UIImageView!
    @IBOutlet weak var yellowStarImageView: UIImageView!
    @IBOutlet weak var yellowStarImageView2: UIImageView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        var imageView = UIImageView()
        
        for touch: UITouch in touches {
            switch touch.view!.tag {
            case 1:
                imageView = moonImageView
                rotate(imageView)
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
        imageView.transform = CGAffineTransform(rotationAngle: 0)
        let angle:CGFloat = CGFloat(M_PI)
        
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
                                    imageView.transform = CGAffineTransform(rotationAngle: angle)
            }, completion: { (Bool) -> Void in
        })
    }
    
    func rotate(_ targetView: UIView, duration: Double = 1.0) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat(M_PI))
        }) { finished in
            self.rotate(targetView, duration: duration)
        }
    }

}
