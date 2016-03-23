//
//  GameView.swift
//  babyCame
//
//  Created by taro on 2015/11/07.
//  Copyright © 2015年 taro. All rights reserved.
//

import Foundation
import UIKit

class Expansion: UIView {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func didTapButton(sender: AnyObject) {
        UIView.animateWithDuration(2.0, delay: 0.0, options: .CurveEaseOut, animations: {
            self.imageView.frame = CGRectMake(0, 0,
                self.imageView.frame.width * 1.5,
                self.imageView.frame.height * 1.5 )
            self.imageView.center = CGPointMake(self.center.x, self.center.y)
        }, completion: nil)
    }
}