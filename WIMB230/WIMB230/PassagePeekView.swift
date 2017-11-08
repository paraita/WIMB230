//
//  PassagePeekView.swift
//  WIMB230
//
//  Created by Paraita Wohler on 20/10/2017.
//  Copyright © 2017 Paraita. All rights reserved.
//

import Foundation
import UIKit

class PassagePeekView: UIViewController {

    @IBOutlet var busType: UILabel!
    @IBOutlet var busTime: UILabel!
    @IBOutlet var busTimeLeft: UILabel!

    var busPassage: BusPassage?
    let addReminderController = AddReminderController()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let busPassage = busPassage {
            busType.text = busPassage.dest
            busTime.text = busPassage.busTime
            busTimeLeft.text = "TODO"
        }
    }

    override var previewActionItems: [UIPreviewActionItem] {
        print("loading the previewActions")
        let shareAction = self.addReminderController.createAddReminderPreviewAction()
        let addReminderAction = self.addReminderController.createSharePreviewAction()
        let cancelAction = self.addReminderController.createCancelPreviewAction()
        return [shareAction, addReminderAction, cancelAction]
    }
}
