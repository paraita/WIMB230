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

    func addReminder(_ busPassage: BusPassage, _ title: String, _ offsetInSeconds: Int) {
        let reminder = EKReminder(eventStore: eventStore)
        let busDate = busPassageFormatter.getBusDate(rawBusTime: busPassage.busTime!)
        let calendarForReminders = eventStore.defaultCalendarForNewReminders()
        let currentCalendar = Calendar.current
        let dateComponents = currentCalendar.dateComponents(in: TimeZone.current, from: busDate)
        reminder.title = title
        reminder.calendar = calendarForReminders
        reminder.dueDateComponents = dateComponents
        let dateNow = Date()
        let timeDelta = TimeInterval(offsetInSeconds)
        let alarm = EKAlarm(absoluteDate: dateNow.addingTimeInterval(timeDelta))
        reminder.addAlarm(alarm)
        do {
            try eventStore.save(reminder, commit: true)
            print("reminder: \(reminder)")
        } catch let error {
            print("Reminder failed with error \(error.localizedDescription)")
        }
    }
}
