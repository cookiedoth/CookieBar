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
    }

    override init() {
        super.init()
        initializeItems()
    }

    func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = [.time]
        return touchBar
    }

    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        return items[identifier]
    }
}