//
//  ViewController.swift
//  WIMB230
//
//  Created by Paraita Wohler on 30/01/2017.
//  Copyright © 2017 Paraita. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import PullToRefresh

class WIMB230ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    let stopId = 1939

    let refresher = PullToRefreshBus(at: .top)
    let dateFormatter = DateFormatter()
    let client = WIMB230Client()
    let PROMTERMINUS = "Cathédrale-Vieille Ville"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addPullToRefresh(refresher) {
            self.fetch()
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshTableView),
                                               name: NSNotification.Name(rawValue: "fetchedData"),
                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(fetch),
//                                               name: NSNotification.Name(rawValue: "savedPreferences"),
//                                               object: nil)
    }

    @objc func refreshTableView() {
        self.tableView.reloadData()
        self.tableView.endRefreshing(at: .top)
    }

    deinit {
        self.tableView.removePullToRefresh(self.tableView.topPullToRefresh!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func fetch() {
        self.client.fetchBusPassages(stopId: Int(self.stopId))
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.client.busPassages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TITOI", for: indexPath)
        if var customCell = cell as? PassageCell {
            customCell = configureCell(customCell, atIndex: indexPath.row)
            return customCell
        } else {
            print("Shit happened when configuring the passage cell")
            cell.textLabel?.text = "Nope"
            return cell
        }
    }

    func configureCell(_ cell: PassageCell, atIndex index: Int) -> PassageCell {
        let busPassage = self.client.busPassages[index]

        // busTime
        let busDate = getBusDate(rawBusTime: busPassage.busTime!)
        dateFormatter.dateFormat = "HH:mm"
        cell.busTime.text = dateFormatter.string(from: busDate)

        // busTimeLeft
        let busTimeLeft = getBusTimeLeft(busDate: busDate)
        cell.busTimeLeft.text = busTimeLeft.stringRep
        cell.busTimeLeft.backgroundColor = busTimeLeft.colorRep
        cell.busTimeLeft.layer.masksToBounds = true
        cell.busTimeLeft.layer.cornerRadius = 8

        // busType
        cell.busType.text = getBusType(busDestination: busPassage.dest!)

        // TODO: put a proper image
        if busPassage.isRealTime ?? false {
            cell.realTimeBadge.image = #imageLiteral(resourceName: "wheel2")
        }
        return cell
    }

    func getBusDate(rawBusTime: String) -> Date {
        guard let regex = try? NSRegularExpression(pattern: "\\..*$",
                                                   options: NSRegularExpression.Options.caseInsensitive)
            else {
                print("Creation of the regex failed !")
                return Date()
        }
        let range = NSRange(location: 0, length: rawBusTime.characters.count)
        let cleanDateBus = regex.stringByReplacingMatches(in: rawBusTime,
                                                          options: [],
                                                          range: range,
                                                          withTemplate: "")
            .replacingOccurrences(of: "T", with: " ")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let dateBus = self.dateFormatter.date(from: cleanDateBus) {
            return dateBus
        } else {
            print("Parsing of the date [\(cleanDateBus)] failed !")
            return Date()
        }
    }
    
    func getBusTimeLeft(busDate: Date) -> (stringRep: String, intRep: Int, colorRep: UIColor) {
        let dateNow = Date()
        let deltaTime = busDate.timeIntervalSince(dateNow)
        let busTimeInt = lround(deltaTime / 60)
        var busTimeStr = "-\(busTimeInt) "
        var timeLeftColor: UIColor

        if busTimeInt > 1 {
            busTimeStr += "minutes !"
        } else {
            busTimeStr += "minute !!"
        }
        if busTimeInt == 0 {
            busTimeStr = "Immediate !!!"
        }

        if busTimeInt < 5 {
            timeLeftColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        } else if busTimeInt < 10 {
            timeLeftColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        } else {
            timeLeftColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }

        return (busTimeStr, busTimeInt, timeLeftColor)
    }
    
    func getBusType(busDestination: String) -> String {
        if busDestination == PROMTERMINUS {
            return "Promenade"
        } else {
            return "Nice Nord"
        }
    }
}

private extension WIMB230ViewController {

    // Binds the pull-to-refresh to our tableview
    func setupPullToRefresh() {
        tableView.addPullToRefresh(PullToRefresh()) { [weak self] in
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self?.tableView.endRefreshing(at: .top)
            }
        }
    }
}
