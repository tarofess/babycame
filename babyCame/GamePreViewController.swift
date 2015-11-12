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
        let alertController = UIAlertController(title: "確認", message: "このゲームで遊ぶ！", preferredStyle: .Alert)
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
        self.view.addSubview(gameCenter.getGameView()!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let gameViewController = segue.destinationViewController as! GameViewController
        gameViewController.indexPath = self.indexPath
    }
}
