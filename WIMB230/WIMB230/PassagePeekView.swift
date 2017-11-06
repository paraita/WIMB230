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
        let shareAction = UIPreviewAction(title: "Share", style: .default) {
            (action, viewController) -> Void in
            print("[send to] actions")
        }
        let addReminderAction = UIPreviewAction(title: "Remind me", style: .default) {
            (action, viewController) -> Void in
            print("[Remind me] action")
        }
        let cancelAction = UIPreviewAction(title: "Cancel", style: .destructive) {
            (action, viewController) -> Void in
            print("[Cancel] action")
        }
        return [shareAction, addReminderAction, cancelAction]
    }
}
