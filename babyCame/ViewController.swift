//
//  ViewController.swift
//  babyCame
//
//  Created by taro on 2015/10/31.
//  Copyright © 2015年 taro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let gamePreviewImageNameArray = ["Expansion", "Rotation", "Particle", "Move", "Bubble", "Sound"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let backButton = UIBarButtonItem(title: NSLocalizedString("navigation_leftButton", comment: ""), style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - CollectionView
    
    func numberOfSectionsInCollectionView(_ collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gamePreviewImageNameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! GameScreenShotCollectionViewCell
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath){
        performSegue(withIdentifier: "RunGamePreViewController", sender: indexPath)
    }
    
    func configureCell(_ cell: GameScreenShotCollectionViewCell, indexPath: IndexPath) {
        cell.gameScreenShotImageView.image = UIImage(named: gamePreviewImageNameArray[(indexPath as NSIndexPath).row])
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = sender as! IndexPath
        
        let gamePreViewController = segue.destination as! GamePreViewController
        gamePreViewController.indexPath = indexPath.row
    }
    
    @IBAction func unwindToTop(_ segue: UIStoryboardSegue) {
    }
    
}

