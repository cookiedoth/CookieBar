//
//  BatteryWidget.swift
//  CookieBar
//
//  Created by Semyon Savkin on 02/07/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

class BatteryWidget: NSCustomTouchBarItem {
    private let batteryListener = BatteryListener()
    private let button = NSButton()

    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)

        let cell = NSButtonCell()
        cell.isBordered = false
        button.cell = cell
        view = button

        batteryListener.start { [self] in
            self.refresh()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func refresh() {
        var newTitle = String(batteryListener.currentCharge) + "%"
        if (batteryListener.isCharging) {
            newTitle = "⚡️" + newTitle
        }
        button.title = newTitle
    }
}
