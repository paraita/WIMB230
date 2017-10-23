//
//  ViewController.swift
//  WIMB230
//
//  Created by Paraita Wohler on 30/01/2017.
//  Copyright © 2017 Paraita. All rights reserved.
//

import UIKit
import EventKit
import Alamofire
import AlamofireObjectMapper
import PullToRefresh

class WIMB230ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
UITextFieldDelegate, UIViewControllerPreviewingDelegate {

    @IBOutlet weak var tableView: UITableView!

    let refresher = PullToRefreshBus(at: .top)
    let dateFormatter = DateFormatter()
    let client = WIMB230Client()
    let reminderSetter = ReminderSetter()
    let busPassageFormatter = BusPassageFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addPullToRefresh(refresher) {
            self.fetch()
        }
        NotificationCenter.default.addObserver(self,
                                          selector: #selector(refreshTableView),
                                          name: NSNotification.Name(rawValue: "fetchedData"),
                                          object: nil)
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: self.tableView)
        }
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
        let stopId = UserDefaults.standard.integer(forKey: "stopId")
        self.client.fetchBusPassages(stopId: stopId)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let nbBusPassages = self.client.busPassages.count
        if nbBusPassages > 0 {
            self.tableView.separatorStyle = .none
        } else {
            self.tableView.separatorStyle = .singleLine
        }
        return nbBusPassages
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
        cell.busPassage = busPassage
        cell.reminderSetter = self.reminderSetter

        // busTime
        cell.busTime.text = busPassageFormatter.getDisplayableTime(busPassage.busTime!)

        // busTimeLeft
        let busDate = busPassageFormatter.getBusDate(rawBusTime: busPassage.busTime!)
        let busTimeLeft = busPassageFormatter.getBusTimeLeft(busDate: busDate)
        cell.busTimeLeft.text = busTimeLeft.stringRep
        cell.busTimeLeft.backgroundColor = busTimeLeft.colorRep
        cell.busTimeLeft.layer.masksToBounds = true
        cell.busTimeLeft.layer.cornerRadius = 8

        // busType
        cell.busType.text = busPassageFormatter.getDisplayableDestination(busPassage.dest!)

        // TODO: put a proper image
        if busPassage.isRealTime ?? false {
            cell.realTimeBadge.image = #imageLiteral(resourceName: "wheel2")
        }
        cell.selectionStyle = .none
        return cell
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location) else {return nil}
        guard let cell = tableView.cellForRow(at: indexPath) as? PassageCell else {return nil}
        guard let passagePeekView = storyboard?.instantiateViewController(withIdentifier: "passagePeekView")
            as? PassagePeekView
            else {return nil}
        passagePeekView.busPassage = cell.busPassage
        passagePeekView.preferredContentSize = CGSize(width: 0.0, height: 200)
        previewingContext.sourceRect = cell.frame
        return passagePeekView
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           commit viewControllerToCommit: UIViewController) {
        //showDetailViewController(viewControllerToCommit, sender: self)
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
