//
//  RemindersWidget.swift
//  CookieBar
//
//  Created by Semyon Savkin on 20/08/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

class RemindersWidget: NSCustomTouchBarItem {
    private var stackView: NSStackView
    private var timer: Timer!
    
    override init(identifier: NSTouchBarItem.Identifier) {
        stackView = NSStackView(views: [])

        super.init(identifier: identifier)
        
        let scrollView = NSScrollView()
        scrollView.documentView = stackView
        view = scrollView

        updateReminders()
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateReminders), userInfo: nil, repeats: true)
    }

    @objc func completeReminder(sender: NSButton) {
        _ = runAppleScriptFromResource(resourceName: "completeReminder", args: [sender.title])
        updateReminders()
    }

    @objc func updateReminders() {
        var buttons: [NSView] = []
        if let reminders = runAppleScriptFromResource(resourceName: "getReminders") {
            let nameArr = reminders.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ", ")
            for reminderName in nameArr {
                if reminderName != "" {
                    buttons.append(NSButton(title: reminderName, target: self, action: #selector(completeReminder)))
                }
            }
        }
        stackView.setViews(buttons, in: .leading)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
