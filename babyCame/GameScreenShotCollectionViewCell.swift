//
//  GameScreenShotCollectionViewCell.swift
//  babyCame
//
//  Created by taro on 2015/10/31.
//  Copyright © 2015年 taro. All rights reserved.
//

import Foundation
import UIKit

class GameScreenShotCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gameScreenShotImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        
        self.layer.masksToBounds = true

        switch UIScreen.mainScreen().bounds.size {
        case CGSize(width: 480.0, height: 320.0): self.layer.cornerRadius = 48
        case CGSize(width: 568.0, height: 320.0): self.layer.cornerRadius = 58
        case CGSize(width: 667.0, height: 375.0): self.layer.cornerRadius = 66
        case CGSize(width: 736.0, height: 414.0): self.layer.cornerRadius = 74
        default : break
        }
    }
}
