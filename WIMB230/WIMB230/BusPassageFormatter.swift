//
//  BusPassageFormatter.swift
//  WIMB230
//
//  Created by Paraita Wohler on 23/10/2017.
//  Copyright © 2017 Paraita. All rights reserved.
//

import Foundation
import UIKit

class BusPassageFormatter {

    static let PROMTERMINUS = "Cathédrale-Vieille Ville"
    let fullDateFormatter = DateFormatter()
    let timeDateFormatter = DateFormatter()

    init() {
        fullDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //fullDateFormatter.timeZone = TimeZone(identifier: "Europe/Paris")!
        //fullDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        timeDateFormatter.dateFormat = "HH:mm"
        //timeDateFormatter.timeZone = TimeZone(identifier: "Europe/Paris")!
        //timeDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    }

    func getDisplayableDestination(_ dest: String) -> String {
        if dest == BusPassageFormatter.PROMTERMINUS {
            return "Promenade"
        } else {
            return "Nice Nord"
        }
    }

    func getBusDate(rawBusTime: String) -> Date {
        guard let regex = try? NSRegularExpression(pattern: "\\..*$",
                                                   options: NSRegularExpression.Options.caseInsensitive)
            else {
                print("Creation of the regex failed !")
                return Date()
        }
        let range = NSRange(location: 0, length: rawBusTime.characters.count)
        let cleanDateBus1 = regex.stringByReplacingMatches(in: rawBusTime,
                                                          options: [],
                                                          range: range,
                                                          withTemplate: "")
            .replacingOccurrences(of: "T", with: " ")
        let cleanDateBus = cleanDateBus1 as String
        print("cleanDate: \(cleanDateBus)")
        if let dateBus = self.fullDateFormatter.date(from: cleanDateBus) {
            let dateWrong = self.timeDateFormatter.string(from: dateBus)
            print("fullDateFormatter: \(dateBus)")
            print("timeDateFormatter: \(dateWrong)")
            return dateBus
        } else {
            print("Parsing of the date [\(cleanDateBus)] failed !")
            return Date()
        }
    }

    func getBusTimeLeft(busDate: Date) -> (nbMinutes: Int, stringRep: String, colorRep: UIColor) {
        let dateNow = Date()
        print("dateNow: \(dateNow)")
        let deltaTime = busDate.timeIntervalSince(dateNow)
        let busTimeInt = lround(deltaTime / 60)
        var busTimeStr = "-\(busTimeInt) "
        var timeLeftColor: UIColor
        if busTimeInt > 1 {
            busTimeStr += "minutes !"
        } else {
            busTimeStr += "minute !!"
        }
        if busTimeInt == 0 {
            busTimeStr = "Immediate !!!"
        }
        if busTimeInt < 5 {
            timeLeftColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        } else if busTimeInt < 10 {
            timeLeftColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        } else {
            timeLeftColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
        return (busTimeInt, busTimeStr, timeLeftColor)
    }

    func getDisplayableTime(_ rawBusTime: String) -> String {
        let date = getBusDate(rawBusTime: rawBusTime)
        return timeDateFormatter.string(from: date)
    }
}
