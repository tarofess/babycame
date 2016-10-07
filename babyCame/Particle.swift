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
        let skView = SKView(frame: self.frame)
        let scene = ParticleScene()
        scene.size = self.frame.size
        scene.backgroundColor = UIColor.clear
        skView.presentScene(scene)
        skView.allowsTransparency = true
        
        addSubview(skView)
    }
    
}
