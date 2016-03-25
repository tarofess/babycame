//
//  Playable.swift
//  babyCame
//
//  Created by インターピア株式会社 on 2016/03/25.
//  Copyright © 2016年 taro. All rights reserved.
//

import Foundation
import AVFoundation

protocol Playable {
    func playSound(soundName: String!, inout audioPlayer: AVAudioPlayer)
}

extension Playable {
    func playSound(soundName: String!, inout audioPlayer: AVAudioPlayer) {
        let coinSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(soundName, ofType: "mp3")!)
        do{
            audioPlayer = try AVAudioPlayer(contentsOfURL:coinSound)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }catch {
            print("Error getting the audio file")
        }
    }
}
