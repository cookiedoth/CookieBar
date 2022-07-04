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

    func initializeItems() {
        items[NSTouchBarItem.Identifier.time] = TimeWidget(identifier: NSTouchBarItem.Identifier.time)
        items[NSTouchBarItem.Identifier.battery] = BatteryWidget(identifier: NSTouchBarItem.Identifier.battery)
        items[NSTouchBarItem.Identifier.speedometer] = Speedometer(identifier: NSTouchBarItem.Identifier.speedometer)
    }

    private override init() {
        super.init()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = [.time, .battery, .speedometer]
        initializeItems()
        self.presentTouchBar()
    }

    func foo() {}

    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        return items[identifier]
    }
    
    @objc private func presentTouchBar() {
        NSTouchBar.presentSystemModalTouchBar(touchBar, placement: 1, systemTrayItemIdentifier: .controlStripItem)
    }
    
    private func dismissTouchBar() {
        NSTouchBar.minimizeSystemModalTouchBar(touchBar)
    }
}
