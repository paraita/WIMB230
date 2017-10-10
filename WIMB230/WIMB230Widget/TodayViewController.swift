//
//  TodayViewController.swift
//  WIMB230Widget
//
//  Created by Paraita Wohler on 14/02/2017.
//  Copyright © 2017 Paraita. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource {

    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    let client = WIMB230Client()
    let dateFormatter = DateFormatter()
    let defaults = UserDefaults.standard

    enum CellCreationError: Error {
        case errorDuringRegexCreation
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshLabel),
                                               name: NSNotification.Name(rawValue: "fetchedData"),
                                               object: nil)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.tableView.rowHeight = 25
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "PARATOI2")
        let bp = self.client.busPassages[indexPath.row]
        let dateBusRaw = bp.busTime!
        let dateNow = Date()
        guard let regex = try? NSRegularExpression(pattern: "\\..*$",
                                               options: NSRegularExpression.Options.caseInsensitive)
            else {
                print("Creation of the regex failed !")
                return cell
            }
        let range = NSRange(location: 0, length: dateBusRaw.characters.count)
        let cleanDateBus = regex.stringByReplacingMatches(in: dateBusRaw, options: [], range: range, withTemplate: "")
            .replacingOccurrences(of: "T", with: " ")
        let dateBus = self.dateFormatter.date(from: cleanDateBus)
        let deltaTime = dateBus?.timeIntervalSince(dateNow)
        let busTimeInt = lround(deltaTime! / 60)
        var busTimeStr = "In \(busTimeInt) "
        if busTimeInt > 1 {
            busTimeStr += "mins"
        } else {
            busTimeStr = "IMMEDIATE !"
        }
        if !bp.isRealTime! {
            busTimeStr += " *"
        }
        //var busDirection = "towards "
        var busDirection = ""
        if isAPromenadeBus(busPassage: bp) {
            busDirection += "Promenade"
        } else {
            busDirection += "Nice Nord"
        }
        cell.textLabel?.text = busTimeStr
        cell.detailTextLabel?.text = busDirection
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.client.busPassages.count
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 10.0;//Choose your custom row height
//    }

    @IBAction func refreshWidget(_ sender: Any) {
        self.mainLabel.text = "Searching..."
        self.client.fetchBusPassages(stopId: 1939)
    }

    @objc func refreshLabel() {
        self.mainLabel.text = ""
        self.tableView.reloadData()
    }

    func isAPromenadeBus(busPassage: BusPassage) -> Bool {
        return busPassage.dest == "Cathédrale-Vieille Ville"
    }

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == NCWidgetDisplayMode.compact {
            self.preferredContentSize = maxSize
        } else {
            let count = 100
            self.preferredContentSize = CGSize(width: 0, height: count)
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
