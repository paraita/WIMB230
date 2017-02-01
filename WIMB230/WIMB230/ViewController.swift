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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var busPassages = [BusPassage]()
    let refresher = PullToRefresh()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.addPullToRefresh(PullToRefresh()) {
            self.fetchBusPassages()
        }
    }
    
    deinit {
        self.tableView.removePullToRefresh(self.tableView.topPullToRefresh!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchBusPassages() {
        Alamofire.request("https://whereismybus230.herokuapp.com/bus230", parameters:["stop_id": "1939"]).responseArray { (response: DataResponse<[BusPassage]>) in
            let busPassages = response.result.value
            if let busPassages = busPassages {
                self.busPassages = busPassages
                print("Bus passages: [")
                for busPassage in self.busPassages {
                    print(busPassage.bus_time!)
                    print(busPassage.dest!)
                    print(busPassage.is_real_time!)
                }
                print("]")
                if (self.busPassages.count == 0) {
                    self.mockData()
                }
                self.tableView.reloadData()
                self.tableView.endRefreshing(at: .top)
            }
        }
    }
    
    func mockData() {
        self.busPassages.removeAll()
        let b1 = BusPassage(bus_time: "2017-01-29 17:15:01",
                            dest: "Mocked Cathédrale Vielle-Ville",
                            is_real_time: true)
        let b2 = BusPassage(bus_time: "2017-01-29 17:22:02",
                            dest: "Mocked Cathédrale Vielle-Ville",
                            is_real_time: false)
        let b3 = BusPassage(bus_time: "2017-01-29 17:32:03",
                            dest: "Mocked Cathédrale Vielle-Ville",
                            is_real_time: false)
        self.busPassages.append(b1)
        self.busPassages.append(b2)
        self.busPassages.append(b3)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busPassages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "PARATOI")
        configureCell(cell, atIndex: indexPath.row)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, atIndex index: Int) {
        let busPassage = busPassages[index]
        if (busPassage.is_real_time!) {
            cell.textLabel!.text = busPassage.bus_time
        }
        else {
            cell.textLabel!.text = "\(busPassage.bus_time) *"
        }
        cell.textLabel!.text = busPassage.bus_time
        cell.detailTextLabel!.text = busPassage.dest
    }
    
}

private extension ViewController {
    
    func setupPullToRefresh() {
        tableView.addPullToRefresh(PullToRefresh()) { [weak self] in
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self?.tableView.endRefreshing(at: .top)
            }
        }
    }
}
