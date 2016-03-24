//
//  ParticleScene.swift
//  babyCame
//
//  Created by taro on 2016/03/25.
//  Copyright © 2016年 taro. All rights reserved.
//

import UIKit
import SpriteKit

class ParticleScene: SKScene {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        
        for touch: AnyObject in touches {
            print("tapped!")
            
            let location = touch.locationInNode(self)
            
            // 用意したファイル（hogeParticle.sks）から、SKEmitterのオブジェクトを生成する。
            let path = NSBundle.mainBundle().pathForResource("IPParticle", ofType: "sks")
            let particle = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
            
            particle.position = location
            
            // particleのもろもろの設定を行ってみます。
            particle.numParticlesToEmit = 100 // 何個、粒を出すか。
            particle.particleBirthRate = 200 // 一秒間に何個、粒を出すか。
            particle.particleSpeed = 80 // 粒の速度
            particle.xAcceleration = 0
            particle.yAcceleration = 0 // 加速度を0にすることで、重力がないようになる。
            
            // 他にもいろいろあるけど、力つきた。。
            
            self.addChild(particle)
        }
    }

}
