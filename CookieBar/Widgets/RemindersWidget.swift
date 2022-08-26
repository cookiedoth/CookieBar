//
//  RemindersWidget.swift
//  CookieBar
//
//  Created by Semyon Savkin on 20/08/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa
import EventKit

class RemindersWidget: NSCustomTouchBarItem {
    private var stackView: NSStackView
    private var timer: Timer!
    private var store = EKEventStore()
    
    override init(identifier: NSTouchBarItem.Identifier) {
        stackView = NSStackView(views: [])

        super.init(identifier: identifier)
        
        let scrollView = NSScrollView()
        scrollView.documentView = stackView
        view = scrollView

        store.requestAccess(to: .reminder) { granted, error in
            self.updateReminders()
            NotificationCenter.default.addObserver(self, selector: #selector(self.updateReminders), name: Notification.Name.EKEventStoreChanged, object: nil)
        }
    }

    @objc func completeReminder(sender: NSButton) {
        let buttonTitle = sender.title
        self.store.fetchReminders(matching: self.store.predicateForReminders(in: nil), completion: {(_ reminders: [EKReminder]?) -> Void in
            for reminder in reminders! {
                if reminder.title == buttonTitle {
                    try! self.store.remove(reminder, commit: true)
                }
            }
        })
    }

    @objc func updateReminders() {
        self.store.fetchReminders(matching: self.store.predicateForReminders(in: nil), completion: {(_ reminders: [EKReminder]?) -> Void in
            var buttons: [NSView] = []
            for reminder in reminders! {
                if !reminder.isCompleted {
                    buttons.append(NSButton(title: reminder.title, target: self, action: #selector(self.completeReminder)))
                }
            }
            DispatchQueue.main.async {
                self.stackView.setViews(buttons, in: .leading)
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
