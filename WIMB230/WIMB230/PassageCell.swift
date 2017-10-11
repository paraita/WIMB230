//
//  PassageCell.swift
//  WIMB230
//
//  Created by Paraita Wohler on 29/09/2017.
//  Copyright © 2017 Paraita. All rights reserved.
//

import Foundation
import UIKit

class PassageCell: UITableViewCell {

    @IBOutlet var busType: UILabel!
    @IBOutlet var busTime: UILabel!
    @IBOutlet var busTimeLeft: UILabel!
    @IBOutlet var realTimeBadge: UIImageView!

    override func layoutSubviews() {
        self.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.contentView.layer.backgroundColor = #colorLiteral(red: 0.1349048316, green: 0.5216068625, blue: 0.6738940477, alpha: 1)
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 5
        self.contentView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}
