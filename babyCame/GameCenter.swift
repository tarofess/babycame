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
        case 0: return UINib(nibName: "Game", bundle: nil).instantiateWithOwner(self, options: nil)[0] as? UIView
        case 1: return UINib(nibName: "Game", bundle: nil).instantiateWithOwner(self, options: nil)[0] as? UIView
        default: return nil
        }
    }
}