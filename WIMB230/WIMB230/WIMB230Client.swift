//
//  WIMB230Client.swift
//  WIMB230
//
//  Created by Paraita Wohler on 14/02/2017.
//  Copyright © 2017 Paraita. All rights reserved.
//
import Foundation
import Alamofire
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
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchedData"), object: nil)
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
        //self.busPassages.append(b1)
        //self.busPassages.append(b2)
        //self.busPassages.append(b3)
        self.busPassages.append(b4)
        self.busPassages.append(b5)
        self.busPassages.append(b6)
    }
    
    
}
