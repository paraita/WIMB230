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
    var bus_time: String?
    var dest: String?
    var is_real_time: Bool?
    
    required init?(map: Map){ }
    
    init(bus_time: String, dest: String, is_real_time: Bool) {
        self.bus_time = bus_time;
        self.dest = dest;
        self.is_real_time = is_real_time;
    }
    
    func mapping(map: Map) {
        bus_time <- map["bus_time"]
        dest <- map["dest"]
        is_real_time <- map["is_real_time"]
    }
}
