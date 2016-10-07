//
//  ParticleScene.swift
//  babyCame
//
//  Created by taro on 2016/03/25.
//  Copyright © 2016年 taro. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class ParticleScene: SKScene, Playable {
    
    var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let path = Bundle.main.path(forResource: "IPParticle", ofType: "sks")
            let particle = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as! SKEmitterNode
            
            particle.position = location
            
            particle.numParticlesToEmit = 100 // 何個、粒を出すか。
            particle.particleBirthRate = 200 // 一秒間に何個、粒を出すか。
            particle.particleSpeed = 80 // 粒の速度

            self.addChild(particle)
        }
        playSound("fireworks", audioPlayer: &self.audioPlayer)
    }

}
