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
    @IBOutlet var stopId: UITextField!
    
    var busPassages = [BusPassage]()
    let refresher = PullToRefresh()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let defaults = UserDefaults.standard
        self.stopId.text = String(defaults.integer(forKey: "stopId"))
        self.tableView.addPullToRefresh(PullToRefresh()) {
            self.fetchBusPassages()
        }
        self.stopId.keyboardType = UIKeyboardType.decimalPad
        
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(WIMB230ViewController.doneButtonAction))
        //array of BarButtonItems
        var arr = [UIBarButtonItem]()
        arr.append(flexSpace)
        arr.append(doneBtn)
        toolbar.setItems(arr, animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.stopId.inputAccessoryView = toolbar
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    func doneButtonAction(){
        self.view.endEditing(true)
    }
    
    @IBAction func manualSaveStopId(_ sender: Any) {
        let defaults = UserDefaults.standard
        let stopId = Int(self.stopId.text!)
        defaults.setValue(stopId, forKey: "stopId")
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.stopId.resignFirstResponder()
        return true
    }
    
    deinit {
        self.tableView.removePullToRefresh(self.tableView.topPullToRefresh!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchBusPassages() {
        if let param = self.stopId.text {
            print("Fetching bus passages for stop \(param)")
            Alamofire.request("https://whereismybus230.herokuapp.com/bus230",
                              parameters:["stop_id": param])
                .responseArray {
                    (response: DataResponse<[BusPassage]>) in
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
    }
    
    func mockData() {
        self.busPassages.removeAll()
        let dateNow = Date()
        
        let b1 = BusPassage(bus_time: "2017-01-29 17:15:01",
                            dest: "Mocked Cathédrale Vielle-Ville",
                            is_real_time: true)
        let b2 = BusPassage(bus_time: "2017-01-29 17:22:02",
                            dest: "Mocked Gambetta",
                            is_real_time: true)
        let b3 = BusPassage(bus_time: "2017-01-29 17:32:03",
                            dest: "Mocked Cathédrale Vielle-Ville",
                            is_real_time: false)
        let b4 = BusPassage(bus_time: self.dateFormatter.string(from: dateNow.addingTimeInterval(72)),
                            dest: "Mocked Cathédrale Vielle-Ville",
                            is_real_time: false)
        let b5 = BusPassage(bus_time: self.dateFormatter.string(from: dateNow.addingTimeInterval(120)),
                            dest: "Mocked Gambetta",
                            is_real_time: true)
        let b6 = BusPassage(bus_time: self.dateFormatter.string(from: dateNow.addingTimeInterval(431)),
                            dest: "Mocked Cathédrale Vielle-Ville",
                            is_real_time: false)
        self.busPassages.append(b1)
        self.busPassages.append(b2)
        self.busPassages.append(b3)
        self.busPassages.append(b4)
        self.busPassages.append(b5)
        self.busPassages.append(b6)
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
        let dateNow = Date()
        let busTimeInt = lround((self.dateFormatter.date(from: busPassage.bus_time!)?.timeIntervalSince(dateNow))! / 60)
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
        cell.detailTextLabel!.text = busPassage.dest
    }
}

private extension WIMB230ViewController {
    
    func setupPullToRefresh() {
        tableView.addPullToRefresh(PullToRefresh()) { [weak self] in
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self?.tableView.endRefreshing(at: .top)
            }
        }
    }
}

