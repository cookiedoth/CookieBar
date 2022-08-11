//
//  BrightnessButton.swift
//  CookieBar
//
//  Created by Semyon Savkin on 10/08/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

class BrightnessButton: NSCustomTouchBarItem {
    private let image = NSImage(named: "sun")!
    private let button = NSButton(title: "", target: self, action: #selector(press))
    private let touchBar: NSTouchBar
    private var brightnessSlider: BrightnessSlider!
    
    init(identifier: NSTouchBarItem.Identifier, touchBar: NSTouchBar, brightnessSlider: BrightnessSlider) {
        self.touchBar = touchBar
        super.init(identifier: identifier)
        button.target = self
        button.image = image
        view = button
        view.widthAnchor.constraint(equalToConstant: 72).isActive = true
        self.brightnessSlider = brightnessSlider
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not bee/Users/cookiedoth/prog/CookieBarn implemented")
    }
    
    @objc func press() {
        brightnessSlider.setValue(value: BrightnessController.shared.getBrightness())
        touchBar.defaultItemIdentifiers = [.brightnessSlider, .closeBrightnessBar]
    }
}

