//
//  RemindersWidget.swift
//  CookieBar
//
//  Created by Semyon Savkin on 20/08/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa
import EventKit

class ReminderKiller : NSObject {
    private let store: EKEventStore
    private let title: String
    
    init(store: EKEventStore, title: String) {
        self.store = store
        self.title = title
        super.init()
    }

    @objc func completeReminder(sender: NSGestureRecognizer) {
        print("remove ", self.title)
        self.store.fetchReminders(matching: self.store.predicateForReminders(in: nil), completion: {(_ reminders: [EKReminder]?) -> Void in
            for reminder in reminders! {
                if reminder.title == self.title {
                    try! self.store.remove(reminder, commit: true)
                }
            }
        })
    }
}

class RemindersWidget: NSCustomTouchBarItem {
    private var stackView: NSStackView
    private var timer: Timer!
    private var store = EKEventStore()
    private var reminderKillers: [ReminderKiller] = []
    
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

    @objc func pass(sender: NSButton) {}

    func doUpdateReminders(reminders: [EKReminder]) {
        var buttons: [NSView] = []
        self.reminderKillers = []
        for reminder in reminders {
            if !reminder.isCompleted {
                let button = NSButton(title: reminder.title, target: self, action: #selector(self.pass))
                let g = NSPressGestureRecognizer()
                let target = ReminderKiller(store: self.store, title: button.title)
                g.numberOfTouchesRequired = 1;
                g.minimumPressDuration = 1.1;
                g.target = target;
                g.action = #selector(target.completeReminder)
                g.allowedTouchTypes = .direct
                button.addGestureRecognizer(g)
                buttons.append(button)
                self.reminderKillers.append(target)
            }
        }
        buttons.append(NSButton(image: NSImage(named: NSImage.touchBarAddTemplateName)!, target: self, action: #selector(self.openReminders)))
        self.stackView.setViews(buttons, in: .leading)
        
    }

    @objc func updateReminders() {
        self.store.fetchReminders(matching: self.store.predicateForReminders(in: nil), completion: {(_ reminders: [EKReminder]?) -> Void in
            DispatchQueue.main.async {
                self.doUpdateReminders(reminders: reminders!)
            }
        })
    }

    @objc func openReminders() {
        if let remindersApp = FileManager.default.urls(
            for: .applicationDirectory,
            in: .systemDomainMask
            ).first?.appendingPathComponent("Reminders.app") {
            NSWorkspace.shared.open(remindersApp)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
