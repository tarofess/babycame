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
    func playSound(_ soundName: String!, audioPlayer: inout AVAudioPlayer)
}

extension Playable {
    func playSound(_ soundName: String!, audioPlayer: inout AVAudioPlayer) {
        let coinSound = URL(fileURLWithPath: Bundle.main.path(forResource: soundName, ofType: "mp3")!)
        do{
            audioPlayer = try AVAudioPlayer(contentsOf:coinSound as URL)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print("Error getting the audio file")
        }
    }
}
