//
//  AddReminderView.swift
//  WIMB230
//
//  Created by Paraita Wohler on 07/11/2017.
//  Copyright © 2017 Paraita. All rights reserved.
//

import Foundation
import UIKit

class AddReminderView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var nbMinutesPickerView: UIPickerView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!

    var reminderSetter: ReminderSetter!
    var busPassageFormatter: BusPassageFormatter!
    var busPassage: BusPassage!
    var nbMinutes: Int!
    var minutesValues: [String]!

    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        let busType = busPassageFormatter.getDisplayableDestination(busPassage.dest!)
        let busTime = busPassageFormatter.getDisplayableTime(busPassage.busTime!)
        titleTextField.text = "\(busType) at \(busTime)"
        minutesValues = (1...nbMinutes).map {getMinuteStringRepresentation($0)}
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return nbMinutes
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return minutesValues[row]
    }

    func getMinuteStringRepresentation(_ minute: Int) -> String {
        if minute == 1 {
            return "in 1 minute"
        } else {
            return "in \(minute) minutes"
        }
    }

    @IBAction func saveReminder(_ sender: Any) {
        print("[Save reminder] action")
        let minutesValue = self.nbMinutesPickerView.selectedRow(inComponent: 0) + 1
        let secondsValue = minutesValue * 60
        reminderSetter.addReminder(busPassage, titleTextField.text!, secondsValue)
        self.dismiss(animated: true, completion: nil)
    }
}
