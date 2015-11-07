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
    
    var gameNumber = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    }
}
