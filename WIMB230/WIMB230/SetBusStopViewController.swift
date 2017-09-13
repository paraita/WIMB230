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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        stopId.keyboardType = UIKeyboardType.decimalPad
        //stopId.reloadInputViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func manualSaveStopId(_ sender: Any) {
        let defaults = UserDefaults.standard
        let stopId = Int(self.stopId.text!)
        defaults.setValue(stopId, forKey: "stopId")
        print("saveStopId !")
        self.view.endEditing(true)
        let userInfo = ["stopId": stopId]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "savedPreferences"),
                                        object: nil,
                                        userInfo: userInfo)
        self.dismiss(animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //self.stopId.resignFirstResponder()
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
