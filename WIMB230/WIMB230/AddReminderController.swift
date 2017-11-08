//
//  AddReminderController.swift
//  WIMB230
//
//  Created by Paraita Wohler on 07/11/2017.
//  Copyright © 2017 Paraita. All rights reserved.
//

import Foundation
import UIKit

class AddReminderController {

    func createShareAction(_ rootViewCon: UIViewController, _ activityViewCon: UIActivityViewController) -> UIAlertAction {
        return UIAlertAction(title: "Share",
                             style: .default,
                             handler: {_ -> Void in
                                print("[Send to] action")
                                rootViewCon.present(activityViewCon, animated: true, completion: nil)
        })
    }

    func createAddReminderAction() -> UIAlertAction {
        return UIAlertAction(title: "Set reminder",
                             style: .default,
                             handler: {_ -> Void in
                                print("[Remind me] action")
                                //self.reminderSetter.addReminder(self.busPassage)
                                // TODO should display the Add Reminder View
        })
    }

    func createCancelAction() -> UIAlertAction {
        return UIAlertAction(title: "Cancel",
                             style: .cancel,
                             handler: {_ -> Void in
                                print("[Cancel] action")
        })
    }
    
    func createSharePreviewAction() -> UIPreviewAction {
        return UIPreviewAction(title: "Share", style: .default) {
            (action, viewController) -> Void in
            print("[send to] actions")
        }
    }
    
    func createAddReminderPreviewAction() -> UIPreviewAction {
        return UIPreviewAction(title: "Remind me", style: .default) {
            (action, viewController) -> Void in
            print("[Remind me] action")
        }
    }
    
    func createCancelPreviewAction() -> UIPreviewAction {
        return UIPreviewAction(title: "Cancel", style: .destructive) {
            (action, viewController) -> Void in
            print("[Cancel] action")
        }
    }
}
