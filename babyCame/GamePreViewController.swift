//
//  GameViewController.swift
//  babyCame
//
//  Created by taro on 2015/10/31.
//  Copyright © 2015年 taro. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class GamePreViewController: UIViewController {
    
    @IBOutlet weak var gameTitleNavigationItem: UINavigationItem!
    @IBOutlet weak var bannerView2: GADBannerView!
    
    var indexPath: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showGame()
        setAd()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func didTapOKNavigationItem(_ sender: AnyObject) {
        showConfirmAlert()
    }
    
    func showConfirmAlert() {
        let alertController = UIAlertController(title: "確認", message: "このゲームで遊びますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "はい", style: .default, handler: { (action: UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "RunGameViewController", sender: self)
        })
        let ngAction = UIAlertAction(title: "いいえ", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(ngAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showGame() {
        let gameCenter = GameCenter(gameIdentifier: indexPath)
        let gameView = gameCenter.getGameView()!
        gameView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        self.view.addSubview(gameView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameViewController = segue.destination as! GameViewController
        gameViewController.indexPath = indexPath
    }
    
    // MARK:- Ad
    
    func setAd() {
        bannerView2.load(GADRequest())
    }
    
}
