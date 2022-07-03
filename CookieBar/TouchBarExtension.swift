//
//  TouchBarExtension.swift
//  CookieBar
//
//  Created by Semyon Savkin on 02/07/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

extension WindowController : NSTouchBarDelegate {

    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = [.label]
        return touchBar
    }

    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        switch (identifier) {
        case NSTouchBarItem.Identifier.label:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = NSButton(title: "hey", target: self, action: #selector(onClick))
            return item

        default:
            return nil
        }
    }

    @objc func onClick() {
        print("clicked")
    }
}
