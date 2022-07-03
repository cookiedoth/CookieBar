//
//  TouchBarExtension.swift
//  CookieBar
//
//  Created by Semyon Savkin on 02/07/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

class TouchBarController : NSObject, NSTouchBarDelegate {

    private var items: [NSTouchBarItem.Identifier : NSCustomTouchBarItem] = [:]

    func initializeItems() {
        items[NSTouchBarItem.Identifier.time] = TimeWidget(identifier: NSTouchBarItem.Identifier.time)
        items[NSTouchBarItem.Identifier.battery] = BatteryWidget(identifier: NSTouchBarItem.Identifier.battery)
        items[NSTouchBarItem.Identifier.speedometer] = Speedometer(identifier: NSTouchBarItem.Identifier.speedometer)
    }

    override init() {
        super.init()
        initializeItems()
    }

    func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = [.time, .battery, .speedometer]
        return touchBar
    }

    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        return items[identifier]
    }
}
