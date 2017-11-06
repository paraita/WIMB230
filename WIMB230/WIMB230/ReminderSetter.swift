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
        var busDate = busPassageFormatter.getBusDate(rawBusTime: busPassage.busTime!)
        // hack for UTC+1 as long as I don't include the UTC offset server-side
        //busDate.addTimeInterval(3600)
        let calendarForReminders = eventStore.defaultCalendarForNewReminders()
        let currentCalendar = Calendar.current
        print("rawTime: \(busPassage.busTime!)")
        print("date: \(busDate)")
        let dateComponents = currentCalendar.dateComponents(in: TimeZone.current, from: busDate)
        reminder.title = "\(dest) at \(busTime)"
        reminder.calendar = calendarForReminders
        // try to remove the due date and keep the alarm only
        reminder.dueDateComponents = dateComponents
        // alarm will happen 2 minutes before the due date
        //reminder.addAlarm(EKAlarm(absoluteDate: busDate.addingTimeInterval(-120)))
        reminder.addAlarm(EKAlarm(absoluteDate: busDate))
        do {
            try eventStore.save(reminder, commit: true)
            print("reminder: \(reminder)")
        } catch let error {
            print("Reminder failed with error \(error.localizedDescription)")
        }
    }
}
