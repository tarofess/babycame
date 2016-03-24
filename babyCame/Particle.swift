//
//  Particle.swift
//  babyCame
//
//  Created by インターピア株式会社 on 2016/03/23.
//  Copyright © 2016年 taro. All rights reserved.
//

import UIKit
import SpriteKit

class Particle: UIView {
    
    override func awakeFromNib() {
        let view = self as! SKView
        let scene = ParticleScene()
        scene.size = self.frame.size
        view.presentScene(scene)
    }
    
}
