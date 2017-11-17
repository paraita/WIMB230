//
//  AddReminderController.swift
//  WIMB230
//
//  Created by Paraita Wohler on 07/11/2017.
//  Copyright © 2017 Paraita. All rights reserved.
//

import Foundation
import UIKit

class ContextualActionsController {

    func shareAction(_ rootViewCon: UIViewController,
                     _ activityViewCon: UIActivityViewController) {
        print("[Send to] action")
        rootViewCon.present(activityViewCon, animated: true, completion: nil)
    }

    func addReminderAction(_ presenterView: UIViewController,
                           _ toPresent: AddReminderView,
                           _ reminderSetter: ReminderSetter) {
        print("[Remind me] action")
        toPresent.reminderSetter = reminderSetter
        presenterView.present(toPresent, animated: true, completion: nil)
    }

    func cancelAction() {
        print("[Cancel] action")
    }

    func createShareAction(_ rootViewCon: UIViewController,
                           _ activityViewCon: UIActivityViewController) -> UIAlertAction {
        return UIAlertAction(title: "Share",
                          style: .default,
                          handler: { _ -> Void in
                            self.shareAction(rootViewCon, activityViewCon)
        })
    }

    func createAddReminderAction(_ presenterView: UIViewController,
                                 _ toPresent: AddReminderView,
                                 _ reminderSetter: ReminderSetter) -> UIAlertAction {
        return UIAlertAction(title: "Set reminder",
                          style: .default,
                          handler: {_ -> Void in
                            self.addReminderAction(presenterView, toPresent, reminderSetter)
        })
    }

    func createCancelAction() -> UIAlertAction {
        return UIAlertAction(title: "Cancel",
                          style: .cancel,
                          handler: {_ -> Void in
                            self.cancelAction()
        })
    }

    func createSharePreviewAction(_ rootViewCon: UIViewController,
                                  _ activityViewCon: UIActivityViewController) -> UIPreviewAction {
        return UIPreviewAction(title: "Share", style: .default) {
            (action, viewController) -> Void in
            self.shareAction(rootViewCon, activityViewCon)
        }
    }
    
    func createAddReminderPreviewAction(_ presenterView: UIViewController,
                                        _ toPresent: AddReminderView,
                                        _ reminderSetter: ReminderSetter) -> UIPreviewAction {
        return UIPreviewAction(title: "Set reminder", style: .default) {
            (action, viewController) -> Void in
            toPresent.reminderSetter = reminderSetter
            presenterView.present(toPresent, animated: true, completion: nil)
        }
    }
    
    func createCancelPreviewAction() -> UIPreviewAction {
        return UIPreviewAction(title: "Cancel", style: .destructive) {
            (action, viewController) -> Void in
            self.cancelAction()
        }
    }
}
