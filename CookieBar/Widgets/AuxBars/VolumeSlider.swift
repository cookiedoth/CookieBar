//
//  VolumeSlider.swift
//  CookieBar
//
//  Created by Semyon Savkin on 17/07/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

class VolumeSlider: NSCustomTouchBarItem {
    private static let color = NSColor(red: 54 / 255, green: 54 / 255, blue: 54 / 255, alpha: 1.0).cgColor
    private let slider = NSSlider(target: self, action: #selector(valueUpdated))
    private let buttonLeft = NSImageView(image: NSImage(named: NSImage.touchBarAudioOutputVolumeOffTemplateName)!)
    private let buttonRight = NSImageView(image: NSImage(named: NSImage.touchBarAudioOutputVolumeHighTemplateName)!)

    @objc func valueUpdated() {
        VolumeController.shared.setVolumeAndMuted(val: slider.doubleValue)
    }

    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)
        slider.target = self
        let view = NSStackView(views: [buttonLeft, slider, buttonRight])
        view.widthAnchor.constraint(equalToConstant: 400).isActive = true
        view.wantsLayer = true
        view.layer?.backgroundColor = VolumeSlider.color
        view.layer?.cornerRadius = 10
        view.spacing = 30
        view.edgeInsets.left = 20
        view.edgeInsets.right = 20
        self.view = view
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setValue(value: Double) {
        slider.doubleValue = value
    }
}
