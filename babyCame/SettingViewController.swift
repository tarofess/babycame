//
//  SettingViewController.swift
//  babyCame
//
//  Created by t-matsusaki on 2018/12/11.
//  Copyright © 2018年 taro. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, GADBannerViewDelegate {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private var pickerData = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setAd()
        setPickerData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        pickerView.selectRow(14, inComponent: 0, animated: false)
    }
    
    private func setAd() {
        bannerView.load(GADRequest())
    }
    
    private func setPickerData() {
        for i in 1...60 {
            pickerData.append(i.description)
        }
    }
    
    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数、要素の全数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // UIPickerViewに表示する配列
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Preferences.timeLeft = Int(pickerData[row])
    }
    
}
