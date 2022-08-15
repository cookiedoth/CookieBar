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
    private let imageView = NSImageView()

    static let maxRange = 600
    static let imageCount = 60
    static let ratio = Double(maxRange) / Double(imageCount)
    private var images: [NSImage] = []

    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)

        for i in 0...Speedometer.imageCount {
            images.append(NSImage(named: "speed\(i)")!)
        }

        self.imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let cell = NSButtonCell()
        cell.isBordered = false
        button.cell = cell

        button.widthAnchor.constraint(greaterThanOrEqualToConstant: 10)

        view = NSStackView(views: [imageView, button])

        keyboardMonitor.start(callback: { [self] (speed: Int) in
            self.refresh(speed: speed)})
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func refresh(speed: Int) {
        button.title = String(speed)
        imageView.image = images[min(Speedometer.imageCount, Int(Double(speed) / Speedometer.ratio))]
    }
}
