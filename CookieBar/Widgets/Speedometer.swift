//
//  TypingSpeedWidget.swift
//  CookieBar
//
//  Created by Semyon Savkin on 02/07/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

class Speedometer: NSCustomTouchBarItem {
    private let button = NSButton()
    private let keyboardMonitor = KeyboardMonitor()

    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)

        let cell = NSButtonCell()
        cell.isBordered = false
        button.cell = cell
        view = button

        keyboardMonitor.start(callback: { [self] (speed: Int) in
            self.refresh(speed: speed)})
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func refresh(speed: Int) {
        button.title = String(speed)
    }
}
