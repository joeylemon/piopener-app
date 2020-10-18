//
//  SettingCell.swift
//  Garage Door
//
//  Created by Joey Lemon on 10/17/20.
//  Copyright © 2020 Joey Lemon. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    @IBOutlet weak var settingSwitch: UISwitch!
    @IBOutlet weak var settingName: UILabel!
    @IBOutlet weak var settingDescription: UITextView!
    var settingKey: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        settingSwitch.addTarget(self, action: #selector(switchIsChanged), for: UIControl.Event.valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func switchIsChanged(mySwitch: UISwitch) {
        Request.send(url: "https://jlemon.org/garage/settings/set/\(Auth.TOKEN)/\(settingKey)/\(mySwitch.isOn)") { (response, result) -> () in
            let httpResponse = response as! HTTPURLResponse
            
            DispatchQueue.main.async {
                if httpResponse.statusCode != 200 {
                    print("Could not update setting")
                } else {
                    print("Updated setting \(self.settingKey) to \(mySwitch.isOn)")
                }
            }
        }
    }
}
