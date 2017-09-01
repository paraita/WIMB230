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
    
    let refresher = PullToRefresh()
    let dateFormatter = DateFormatter()
    let client = WIMB230Client()
    let NICE_PROM = "Cathédrale-Vieille Ville"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addPullToRefresh(PullToRefresh()) {
            self.fetch()
        }
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshTableView),
                                               name: NSNotification.Name(rawValue: "fetchedData"),
                                               object: nil)
    }
    
    func refreshTableView() {
        self.tableView.reloadData()
        self.tableView.endRefreshing(at: .top)
    }
    
    deinit {
        self.tableView.removePullToRefresh(self.tableView.topPullToRefresh!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "PARATOI")
        configureCell(cell, atIndex: indexPath.row)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, atIndex index: Int) {
        let busPassage = self.client.busPassages[index]
        let dateNow = Date()
        let regex = try! NSRegularExpression(pattern: "\\..*$", options: NSRegularExpression.Options.caseInsensitive)
        let range = NSMakeRange(0, busPassage.bus_time!.characters.count)
        let cleanDateBus = regex.stringByReplacingMatches(in: busPassage.bus_time!, options: [], range: range, withTemplate: "")
            .replacingOccurrences(of: "T", with: " ")
        let dateBus = self.dateFormatter.date(from: cleanDateBus)
        let deltaTime = dateBus?.timeIntervalSince(dateNow)
        let busTimeInt = lround(deltaTime! / 60)
        var busTimeStr = "In \(busTimeInt) "
        if (busTimeInt > 1) {
            busTimeStr += "minutes !"
        }
        else {
            busTimeStr += "minute !!!"
        }
        if (!busPassage.is_real_time!) {
            busTimeStr += " *"
        }
        cell.textLabel!.text = busTimeStr
        
        if (busPassage.dest == NICE_PROM) {
            cell.detailTextLabel!.text = "Nice Prom"
        }
        else {
            cell.detailTextLabel!.text = "Nice Nord"
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

