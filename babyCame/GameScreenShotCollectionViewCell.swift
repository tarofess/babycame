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
        self.layer.cornerRadius = 20
    }
    
}
