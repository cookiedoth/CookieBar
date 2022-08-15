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
        items[.time] = TimeWidget(identifier: .time)
        items[.battery] = BatteryWidget(identifier: .battery)
        items[.speedometer] = Speedometer(identifier: .speedometer)
        items[.esc] = EscButton(identifier: .esc)
        let volumeSlider = VolumeSlider(identifier: .volumeSlider)
        let closeVolumeBar = CloseButton(identifier: .closeVolumeBar)
        items[.volumeSlider] = volumeSlider
        items[.closeVolumeBar] = closeVolumeBar
        items[.volume] = VolumeButton(identifier: .volume, touchBar: touchBar, volumeSlider: volumeSlider, closeButton: closeVolumeBar)
        let brightnessSlider = BrightnessSlider(identifier: .brightnessSlider)
        items[.brightnessSlider] = brightnessSlider
        items[.closeBrightnessBar] = CloseButton(identifier: .closeBrightnessBar)
        items[.brightness] = BrightnessButton(identifier: .brightness, touchBar: touchBar, brightnessSlider: brightnessSlider)
        items[.weather] = WeatherWidget(identifier: .weather, apiKey: ConfigManager.shared.apiKey!)
        items[.coffee] = CoffeeButton(identifier: .coffee)
        items[.headphones] = HeadphonesWidget(identifier: .headphones)
    }

    private override init() {
        super.init()
        ConfigManager.shared.readConfig()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = [
            .esc,
            .time,
            .battery,
            .speedometer,
            .volume,
            .brightness,
            .weather,
            .coffee,
            .headphones]
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
