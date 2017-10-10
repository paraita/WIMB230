//
//  WIMB230Client.swift
//  WIMB230
//
//  Created by Paraita Wohler on 14/02/2017.
//  Copyright © 2017 Paraita. All rights reserved.
//
import Foundation
import Alamofire
import AlamofireObjectMapper
import UIKit

class WIMB230Client {

    var busPassages = [BusPassage]()
    let dateFormatter = DateFormatter()

    init() {
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }

    func fetchBusPassages(stopId: Int) {
        print("Fetching bus passages for stop \(stopId)")
        Alamofire.request("https://whereismybus230.herokuapp.com/bus230",
                          parameters:["stop_id": stopId])
            .responseArray { (response: DataResponse<[BusPassage]>) in
                let busPassages = response.result.value
                //sleep(2)
                if let busPassages = busPassages {
                    self.busPassages = busPassages
                    print("Bus passages: [")
                    for busPassage in self.busPassages {
                        print(busPassage.busTime!)
                        print(busPassage.dest!)
                        print(busPassage.isRealTime!)
                    }
                    print("]")
                    if self.busPassages.count == 0 {
                        self.mockData()
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchedData"), object: nil)
                }
        }
    }

    func mockData() {
        self.busPassages.removeAll()
        let dateNow = Date()
        self.busPassages.append(BusPassage(busTime: self.dateFormatter.string(from: dateNow.addingTimeInterval(72)),
                                           dest: "Cathédrale-Vieille Ville",
                                           isRealTime: false))
        self.busPassages.append(BusPassage(busTime: self.dateFormatter.string(from: dateNow.addingTimeInterval(120)),
                                           dest: "Mocked Gambetta",
                                           isRealTime: true))
        self.busPassages.append(BusPassage(busTime: self.dateFormatter.string(from: dateNow.addingTimeInterval(431)),
                                           dest: "Cathédrale-Vieille Ville",
                                           isRealTime: false))
    }
}
