//
//  GameCenter.swift
//  babyCame
//
//  Created by taro on 2015/11/07.
//  Copyright © 2015年 taro. All rights reserved.
//

import Foundation
import UIKit

class GameCenter: NSObject {
    
    var gameIdentifier: Int!
    
    init(gameIdentifier: Int) {
        self.gameIdentifier = gameIdentifier
    }
    
    func getGameView() -> UIView? {
        switch self.gameIdentifier {
        case 0: return UINib(nibName: "Expansion", bundle: nil).instantiateWithOwner(self, options: nil)[0] as? UIView
        case 1: return UINib(nibName: "Rotation", bundle: nil).instantiateWithOwner(self, options: nil)[0] as? UIView
        case 2: return UINib(nibName: "Particle", bundle: nil).instantiateWithOwner(self, options: nil)[0] as? UIView
        case 3: return UINib(nibName: "Move", bundle: nil).instantiateWithOwner(self, options: nil)[0] as? UIView
        case 4: return UINib(nibName: "Bubble", bundle: nil).instantiateWithOwner(self, options: nil)[0] as? UIView
        case 5: return UINib(nibName: "Sound", bundle: nil).instantiateWithOwner(self, options: nil)[0] as? UIView
        default: return nil
        }
    }
}