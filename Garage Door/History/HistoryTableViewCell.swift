//
//  HistoryTableViewCell.swift
//  Garage Door
//
//  Created by Joey Lemon on 6/17/20.
//  Copyright © 2020 Joey Lemon. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var rowImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
