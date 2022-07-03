//
//  Time.swift
//  CookieBar
//
//  Created by Semyon Savkin on 02/07/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

class TimeWidget: NSCustomTouchBarItem {
    private let button = NSButton()
    private let dateFormatter = DateFormatter()
    private var timer: Timer!

    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)

        dateFormatter.dateFormat = "HH:mm"

        let cell = NSButtonCell()
        cell.isBordered = false
        button.cell = cell
        view = button

        updateTime()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func onClick() {}

    @objc func updateTime() {
        button.title = dateFormatter.string(from: Date())
    }
}
