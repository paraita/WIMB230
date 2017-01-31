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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var busPassages = [BusPassage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchBusPassages()
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
                self.busPassages.removeAll()
                self.mockData()
                self.tableView.reloadData()
            }
        }
    }
    
    func mockData() {
        self.busPassages.removeAll()
        let b1 = BusPassage(bus_time: "2017-01-29 17:15:01",
                            dest: "Cathédrale Vielle-Ville",
                            is_real_time: true)
        let b2 = BusPassage(bus_time: "2017-01-29 17:22:02",
                            dest: "Cathédrale Vielle-Ville",
                            is_real_time: false)
        let b3 = BusPassage(bus_time: "2017-01-29 17:32:03",
                            dest: "Cathédrale Vielle-Ville",
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

