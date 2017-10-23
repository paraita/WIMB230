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
    @IBOutlet var optionsButton: UIButton!

    var busPassage: BusPassage!

    override func layoutSubviews() {
        self.layer.backgroundColor = UIColor.white.cgColor
        self.contentView.layer.backgroundColor = #colorLiteral(red: 0.1349048316, green: 0.5216068625, blue: 0.6738940477, alpha: 1)
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 5
        self.contentView.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        self.clipsToBounds = true
    }

    @IBAction func displayOptions(_ sender: UIButton) {
        let title = "\(busType.text ?? "") at \(busTime.text ?? "")"
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        let shareActivityVC = UIActivityViewController(activityItems: [title], applicationActivities: nil)
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)

        let sendButton = UIAlertAction(title: "Share",
                                     style: .default,
                                     handler: {_ -> Void in
                                        print("[Send to] action")
                                        rootViewController?.present(shareActivityVC,
                                                                   animated: true,
                                                                   completion: nil)
        })
        let addReminderButton = UIAlertAction(title: "Set reminder",
                                            style: .default,
                                            handler: {_ -> Void in
                                                print("[Remind me] action")
                                                
        })
        let cancelButton = UIAlertAction(title: "Cancel",
                                       style: .cancel,
                                       handler: {_ -> Void in
                                        print("[Cancel] action")
        })
        alertController.addAction(sendButton)
        alertController.addAction(addReminderButton)
        alertController.addAction(cancelButton)
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
