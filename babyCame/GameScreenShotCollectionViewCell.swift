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

    override func awakeFromNib() {
        self.layer.masksToBounds = true

        switch UIScreen.mainScreen().bounds.size {
        case CGSize(width: 320.0, height: 480.0): self.layer.cornerRadius = 48
        case CGSize(width: 320.0, height: 568.0): self.layer.cornerRadius = 58
        case CGSize(width: 375.0, height: 667.0): self.layer.cornerRadius = 66
        case CGSize(width: 414.0, height: 736.0): self.layer.cornerRadius = 70
        default : break
        }
    }
}
