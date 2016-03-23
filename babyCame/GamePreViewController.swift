//
//  GameViewController.swift
//  babyCame
//
//  Created by taro on 2015/10/31.
//  Copyright © 2015年 taro. All rights reserved.
//

import Foundation
import UIKit

class GamePreViewController: UIViewController {
    
    @IBOutlet weak var gameTitleNavigationItem: UINavigationItem!
    var indexPath: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showGame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func didTapOKNavigationItem(sender: AnyObject) {
        showConfirmAlert()
    }
    
    func showConfirmAlert() {
        let alertController = UIAlertController(title: "確認", message: "このゲームで遊びますか？", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "はい", style: .Default, handler: { (action: UIAlertAction) -> Void in
            self.performSegueWithIdentifier("RunGameViewController", sender: self)
        })
        let ngAction = UIAlertAction(title: "いいえ", style: .Cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(ngAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showGame() {
        let gameCenter = GameCenter(gameIdentifier: self.indexPath)
        let gameView = gameCenter.getGameView()
        setAutoLayout(gameView!)
        self.view.addSubview(gameView!)
    }
    
    func setAutoLayout(gameView: UIView) {
//        view.leadingAnchor.constraintEqualToAnchor(self.view.layoutMarginsGuide.leadingAnchor, constant: 0).active = true
//        view.trailingAnchor.constraintEqualToAnchor(self.view.layoutMarginsGuide.trailingAnchor, constant: 0).active = true
//        view.topAnchor.constraintEqualToAnchor(self.view.layoutMarginsGuide.topAnchor, constant: 0).active = true
//        view.bottomAnchor.constraintEqualToAnchor(self.view.layoutMarginsGuide.bottomAnchor, constant: 0).active = true
        
        self.view.addConstraints([
            
            // self.veiwの上から0pxの位置に配置
            NSLayoutConstraint(
                item: gameView,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1.0,
                constant: 0
            ),
            
            // self.viewの横幅いっぱいにする
            NSLayoutConstraint(
                item: gameView,
                attribute: NSLayoutAttribute.Width,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.Width,
                multiplier: 1.0,
                constant: 0
            ),
            
            // self.viewのレイアウトに関わらず高さは64px
            NSLayoutConstraint(
                item: gameView,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.Height,
                multiplier: 1.0,
                constant: 64
            )]
        )
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let gameViewController = segue.destinationViewController as! GameViewController
        gameViewController.indexPath = self.indexPath
    }
}
