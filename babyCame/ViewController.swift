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

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillDisappear(animated: Bool) {
        let backButton = UIBarButtonItem(title: "戻る", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - CollectionView
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: GameScreenShotCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! GameScreenShotCollectionViewCell
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        performSegueWithIdentifier("RunGamePreViewController", sender: indexPath)
    }
    
    func configureCell(cell: GameScreenShotCollectionViewCell, indexPath: NSIndexPath) {
        cell.gameScreenShotImageView.image = UIImage(named: String(indexPath.row))
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = sender as! NSIndexPath
        
        let gamePreViewController = segue.destinationViewController as! GamePreViewController
        gamePreViewController.indexPath = indexPath.row
    }
    
    @IBAction func unwindToTop(segue: UIStoryboardSegue) {
    }
}

