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
    var reminderSetter: ReminderSetter!
    var parentView: UIViewController!
    var addReminderView: AddReminderView!
    let addReminderController = ContextualActionsController()

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
        let title = "\(busType.text ?? "") at \(busTime.text ?? "")"
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        let shareActivityVC = UIActivityViewController(activityItems: [title], applicationActivities: nil)
        let shareAction = self.addReminderController.createSharePreviewAction(rootViewController!, shareActivityVC)
        let createAction = self.addReminderController.createAddReminderPreviewAction
        let addReminderAction = createAction(self.parentView,
                                             self.addReminderView,
                                             self.reminderSetter)
        let cancelAction = self.addReminderController.createCancelPreviewAction()
        return [shareAction, addReminderAction, cancelAction]
    }
}
