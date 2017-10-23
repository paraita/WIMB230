//
//  BusPassage.swift
//  WIMB230
//
//  Created by Paraita Wohler on 30/01/2017.
//  Copyright © 2017 Paraita. All rights reserved.
//

import Foundation
import ObjectMapper

class BusPassage: Mappable {
    let PROMTERMINUS = "Cathédrale-Vieille Ville"
    var busTime: String?
    var dest: String?
    var isRealTime: Bool?

    required init? (map: Map) { }

    init(busTime: String, dest: String, isRealTime: Bool) {
        self.busTime = busTime
        self.dest = dest
        self.isRealTime = isRealTime
    }

    func mapping(map: Map) {
        busTime <- map["bus_time"]
        dest <- map["dest"]
        isRealTime <- map["is_real_time"]
    }
    
    func getDisplayableDestination() -> String {
        if dest == PROMTERMINUS {
            return "Promenade"
        } else {
            return "Nice Nord"
        }
    }
}
