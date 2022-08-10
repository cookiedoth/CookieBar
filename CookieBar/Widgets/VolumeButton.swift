//
//  VolumeButton.swift
//  CookieBar
//
//  Created by Semyon Savkin on 17/07/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

class VolumeButton: NSCustomTouchBarItem {
    private let volumeImages = [
        NSImage(named: NSImage.touchBarAudioOutputVolumeOffTemplateName)!,
        NSImage(named: NSImage.touchBarAudioOutputVolumeLowTemplateName)!,
        NSImage(named: NSImage.touchBarAudioOutputVolumeMediumTemplateName)!,
        NSImage(named: NSImage.touchBarAudioOutputVolumeHighTemplateName)!
    ]
    private let button = NSButton(title: "", target: self, action: #selector(press))
    private let touchBar: NSTouchBar
    private var timer: Timer!
    private var volumeSlider: VolumeSlider!

    init(identifier: NSTouchBarItem.Identifier, touchBar: NSTouchBar, volumeSlider: VolumeSlider, closeButton: CloseButton) {
        self.touchBar = touchBar
        super.init(identifier: identifier)
        button.target = self
        view = button
        self.volumeSlider = volumeSlider
        closeButton.setCallback { [self] in
            self.retrieveVolume()
        }
        retrieveVolume()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(retrieveVolume), userInfo: nil, repeats: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not bee/Users/cookiedoth/prog/CookieBarn implemented")
    }
    
    @objc func press() {
        touchBar.defaultItemIdentifiers = [.volumeSlider, .closeButton]
    }

    @objc func retrieveVolume() {
        let volume = VolumeController.shared.getVolume()
        volumeSlider.setValue(value: volume)
        if (volume < 0.0001) {
            button.image = volumeImages[0]
        } else if (volume < 1 / 3) {
            button.image = volumeImages[1]
        } else if (volume < 2 / 3) {
            button.image = volumeImages[2]
        } else {
            button.image = volumeImages[3]
        }
    }
}
