//
//  BrightnessSlider.swift
//  CookieBar
//
//  Created by Semyon Savkin on 10/08/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

class BrightnessSlider: SystemSlider {
    init(identifier: NSTouchBarItem.Identifier) {
        let imageLeft = NSImageView(image: NSImage(named: "moon")!)
        let imageRight = NSImageView(image: NSImage(named: "sun")!)
        imageLeft.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageRight.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageLeft.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageRight.heightAnchor.constraint(equalToConstant: 30).isActive = true
        super.init(identifier: identifier, buttonLeft: imageLeft, buttonRight: imageRight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc override func valueUpdated() {
        BrightnessController.shared.setBrightness(val: slider.doubleValue)
    }
}
