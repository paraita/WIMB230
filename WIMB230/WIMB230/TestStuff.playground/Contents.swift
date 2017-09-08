//: Playground - noun: a place where people can play

import Foundation
import UIKit

let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

let dateNow = Date()

let date1 = dateFormatter.date(from: "2017-02-08 21:33:42")

date1!.timeIntervalSince(dateNow) / 60
