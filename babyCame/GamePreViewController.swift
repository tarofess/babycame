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
    @IBOutlet weak var bannerView: GADBannerView!
    
    var indexPath: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGameTitle()
        showGame()
        bannerView.load(GADRequest())
        self.view.bringSubview(toFront: bannerView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func didTapOKNavigationItem(_ sender: AnyObject) {
        showConfirmAlert()
    }
    
    func showConfirmAlert() {
        let alertController = UIAlertController(title: NSLocalizedString("comfirm_alertTitle_in_preview", comment: ""), message: NSLocalizedString("comfirm_alertMessage_in_preview", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("alertOK_action", comment: ""), style: .default, handler: { (action: UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "RunGameViewController", sender: self)
        })
        let ngAction = UIAlertAction(title: NSLocalizedString("alertNG_action", comment: ""), style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(ngAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func setGameTitle() {
        switch indexPath {
        case 0:
            title = NSLocalizedString("title_animal", comment: "")
        case 1:
            title = NSLocalizedString("title_night", comment: "")
        case 2:
            title = NSLocalizedString("title_japanese", comment: "")
        case 3:
            title = NSLocalizedString("title_vehicle", comment: "")
        case 4:
            title = NSLocalizedString("title_bubble", comment: "")
        case 5:
            title = NSLocalizedString("title_music", comment: "")
        default:
            break
        }
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
    
}
