//
//  ReminderSetter.swift
//  WIMB230
//
//  Created by Paraita Wohler on 23/10/2017.
//  Copyright © 2017 Paraita. All rights reserved.
//

import Foundation
import EventKit

class ReminderSetter {

    let eventStore = EKEventStore()
    let busPassageFormatter = BusPassageFormatter()

    init() {
        print("Initialization of the ReminderSetter in progress...")
        eventStore.requestAccess(to: EKEntityType.reminder, completion: {(granted, error) -> Void in
            if granted {
                print("[ReminderSetter]    COOOL")
            } else {
                print("[ReminderSetter]    error:\(error!)")
            }
        })
    }

    func addReminder(_ busPassage: BusPassage) {
        let reminder = EKReminder(eventStore: eventStore)
        let dest = busPassageFormatter.getDisplayableDestination(busPassage.dest!)
        let busTime = busPassageFormatter.getDisplayableTime(busPassage.busTime!)
        let calendar = eventStore.defaultCalendarForNewReminders()
        reminder.title = "\(dest) at \(busTime)"
        reminder.calendar = calendar
//        reminder.dueDateComponents = DateComponents(calendar: calendar,
//                                                    timeZone: TimeZone.current,
//                                                    era: <#T##Int?#>,
//                                                    year: <#T##Int?#>,
//                                                    month: <#T##Int?#>,
//                                                    day: <#T##Int?#>,
//                                                    hour: <#T##Int?#>,
//                                                    minute: <#T##Int?#>,
//                                                    second: <#T##Int?#>,
//                                                    nanosecond: <#T##Int?#>,
//                                                    weekday: <#T##Int?#>,
//                                                    weekdayOrdinal: <#T##Int?#>,
//                                                    quarter: <#T##Int?#>,
//                                                    weekOfMonth: <#T##Int?#>,
//                                                    weekOfYear: <#T##Int?#>,
//                                                    yearForWeekOfYear: <#T##Int?#>)
        do {
            try eventStore.save(reminder, commit: true)
        } catch let error {
            print("Reminder failed with error \(error.localizedDescription)")
        }
    }
}
