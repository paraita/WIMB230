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
    
    let refresher = PullToRefresh()
    let dateFormatter = DateFormatter()
    let client = WIMB230Client()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let defaults = UserDefaults.standard
        self.stopId.text = String(defaults.integer(forKey: "stopId"))
        self.tableView.addPullToRefresh(PullToRefresh()) {
            self.fetch()
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshTableView),
                                               name: NSNotification.Name(rawValue: "fetchedData"),
                                               object: nil)
    }
    
    func refreshTableView() {
        self.tableView.reloadData()
        self.tableView.endRefreshing(at: .top)
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
    
    func fetch() {
        self.client.fetchBusPassages(stopId: Int(self.stopId.text!)!)
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

