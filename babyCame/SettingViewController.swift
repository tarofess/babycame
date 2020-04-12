//
//  SettingViewController.swift
//  babyCame
//
//  Created by t-matsusaki on 2018/12/11.
//  Copyright © 2018年 taro. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    private var pickerData = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setPickerData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        pickerView.selectRow(Preferences.timeLeft! - 1, inComponent: 0, animated: false)
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
