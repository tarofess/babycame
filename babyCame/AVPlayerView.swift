//
//  AVPlayerView.swift
//  babyCame
//
//  Created by インターピア株式会社 on 2015/11/10.
//  Copyright © 2015年 taro. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class AVPlayerView : UIView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override open class var layerClass: Swift.AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }
    
}
