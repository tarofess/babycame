//
//  PlayerViewController.swift
//  babyCame
//
//  Created by インターピア株式会社 on 2016/02/01.
//  Copyright © 2016年 taro. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PlayerViewController: AVPlayerViewController {
    var videoPath: NSURL!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.player = AVPlayer(URL: self.videoPath);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
