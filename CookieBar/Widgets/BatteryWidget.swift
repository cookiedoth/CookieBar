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
    static let segments = 40
    static let ratio = Double(100) / Double(segments)
    private var images: [[NSImage]] = [[], []]
    private let imageView = NSImageView()

    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)

        for i in 0...BatteryWidget.segments {
            self.images[0].append(NSImage(named: "battery\(i)")!)
            self.images[1].append(NSImage(named: "battery\(i)_charging")!)
        }

        self.imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true

        let cell = NSButtonCell()
        cell.isBordered = false
        button.cell = cell

        view = NSStackView(views: [imageView, button])

        batteryListener.start { [self] in
            self.refresh()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func refresh() {
        let imageId = Int(round(Double(batteryListener.currentCharge) / BatteryWidget.ratio))
        self.imageView.image = self.images[batteryListener.isCharging ? 1 : 0][imageId]
        button.title = String(batteryListener.currentCharge) + "%"
    }
}
