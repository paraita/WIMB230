//
//  TodayViewController.swift
//  WIMB230Widget
//
//  Created by Paraita Wohler on 14/02/2017.
//  Copyright © 2017 Paraita. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet var mainLabel: UILabel!
    let client = WIMB230Client()
    let dateFormatter = DateFormatter()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshLabel),
                                               name: NSNotification.Name(rawValue: "fetchedData"),
                                               object: nil)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    @IBAction func refreshWidget(_ sender: Any) {
        self.mainLabel.text = "Searching..."
        self.client.fetchBusPassages(stopId: 1939)
    }
    
    func refreshLabel() {
        var strResult = ""
        let dateNow = Date()
        
        for bp in self.client.busPassages {
            
            let dateBusRaw = bp.bus_time!
            
            let regex = try! NSRegularExpression(pattern: "\\..*$", options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0, dateBusRaw.characters.count)
            let cleanDateBus = regex.stringByReplacingMatches(in: dateBusRaw, options: [], range: range, withTemplate: "")
                .replacingOccurrences(of: "T", with: " ")
            let dateBus = self.dateFormatter.date(from: cleanDateBus)
            let deltaTime = dateBus?.timeIntervalSince(dateNow)
            let busTimeInt = lround(deltaTime! / 60)
            var busTimeStr = "In \(busTimeInt) "
            if (busTimeInt > 1) {
                busTimeStr += "minutes !"
            }
            else {
                busTimeStr = "IMMEDIATE !"
            }
            if (!bp.is_real_time!) {
                busTimeStr += " *"
            }
            strResult += busTimeStr
            if (isAPromenadeBus(busPassage: bp)) {
                strResult += " (Promenade)"
            }
            else {
                strResult += " (Nice Nord)"
            }
            strResult += "\n"
        }
        self.mainLabel.text = strResult
    }
    
    func isAPromenadeBus(busPassage: BusPassage) -> Bool {
        return busPassage.dest == "Cathédrale-Vieille Ville"
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if (activeDisplayMode == NCWidgetDisplayMode.compact) {
            self.preferredContentSize = maxSize
        }
        else {
            self.preferredContentSize = CGSize(width: 0, height: 200)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        
//        let stopId = defaults.integer(forKey: "stopId")
//        if stopId != 0 {
//            self.client.fetchBusPassages(stopId: stopId)
//        }
//        else {
//            self.mainLabel.text = "No Stop ID set !"
//        }
        self.client.fetchBusPassages(stopId: 1939)
        
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
