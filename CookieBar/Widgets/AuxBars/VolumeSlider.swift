//
//  VolumeSlider.swift
//  CookieBar
//
//  Created by Semyon Savkin on 17/07/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

class VolumeSlider: SystemSlider {
    init(identifier: NSTouchBarItem.Identifier) {
        let imageLeft = NSImageView(image: NSImage(named: NSImage.touchBarAudioOutputVolumeOffTemplateName)!)
        let imageRight = NSImageView(image: NSImage(named: NSImage.touchBarAudioOutputVolumeHighTemplateName)!)
        super.init(identifier: identifier, buttonLeft: imageLeft, buttonRight: imageRight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc override func valueUpdated() {
        VolumeController.shared.setVolumeAndMuted(val: slider.doubleValue)
    }
}
