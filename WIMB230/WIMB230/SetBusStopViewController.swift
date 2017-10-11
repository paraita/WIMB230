//
//  SetBusStopViewController.swift
//  WIMB230
//
//  Created by Paraita Wohler on 12/06/2017.
//  Copyright © 2017 Paraita. All rights reserved.
//

import UIKit

class SetBusStopViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var stopId: UITextField!
    @IBOutlet var devMode: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let defaults = UserDefaults.standard
        if let stopIdStr = defaults.string(forKey: "stopId") {
            self.stopId.text = stopIdStr
        } else {
            self.stopId.text = String(1939)
        }
        if let debugModeOn = defaults.object(forKey: "debugModeOn") as? Bool {
            if debugModeOn {
                self.devMode.setOn(true, animated: true)
            } else {
                self.devMode.setOn(false, animated: true)
            }
        } else {
            self.devMode.setOn(false, animated: true)
        }
        stopId.keyboardType = UIKeyboardType.decimalPad
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func manualSaveStopId(_ sender: Any) {
        let defaults = UserDefaults.standard
        let stopId = Int(self.stopId.text!)
        let debugModeOn = self.devMode.isOn
        defaults.setValue(stopId, forKey: "stopId")
        defaults.setValue(debugModeOn, forKey: "debugModeOn")
        print("Saving the user defaults")
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
