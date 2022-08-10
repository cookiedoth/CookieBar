//
//  TouchBarExtension.swift
//  CookieBar
//
//  Created by Semyon Savkin on 02/07/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

class TouchBarController : NSObject, NSTouchBarDelegate {

    static let shared = TouchBarController()

    let touchBar = NSTouchBar()

    private var items: [NSTouchBarItem.Identifier : NSCustomTouchBarItem] = [:]
    private var defaultIdentifiers: [NSTouchBarItem.Identifier] = []

    func initializeItems() {
        items[NSTouchBarItem.Identifier.time] = TimeWidget(identifier: NSTouchBarItem.Identifier.time)
        items[NSTouchBarItem.Identifier.battery] = BatteryWidget(identifier: NSTouchBarItem.Identifier.battery)
        items[NSTouchBarItem.Identifier.speedometer] = Speedometer(identifier: NSTouchBarItem.Identifier.speedometer)
        items[NSTouchBarItem.Identifier.esc] = EscButton(identifier: NSTouchBarItem.Identifier.esc)
        let volumeSlider = VolumeSlider(identifier: NSTouchBarItem.Identifier.volumeSlider)
        let closeButton = CloseButton(identifier: NSTouchBarItem.Identifier.closeButton)
        items[NSTouchBarItem.Identifier.volumeSlider] = volumeSlider
        items[NSTouchBarItem.Identifier.closeButton] = closeButton
        items[NSTouchBarItem.Identifier.volume] = VolumeButton(identifier: NSTouchBarItem.Identifier.volume, touchBar: touchBar, volumeSlider: volumeSlider, closeButton: closeButton)
    }

    private override init() {
        super.init()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = [
            .esc,
            .time,
            .battery,
            .speedometer,
            .volume]
        self.defaultIdentifiers = touchBar.defaultItemIdentifiers
        initializeItems()
        self.presentTouchBar()
    }

    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        return items[identifier]
    }
    
    @objc private func presentTouchBar() {
        NSTouchBar.presentSystemModalTouchBar(touchBar, placement: 1, systemTrayItemIdentifier: .controlStripItem)
    }
    
    private func dismissTouchBar() {
        NSTouchBar.minimizeSystemModalTouchBar(touchBar)
    }

    func restoreDefaultView() {
        touchBar.defaultItemIdentifiers = self.defaultIdentifiers
    }
}
