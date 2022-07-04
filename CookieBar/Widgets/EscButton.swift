//
//  EscButton.swift
//  CookieBar
//
//  Created by Semyon Savkin on 03/07/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

class EscButton: NSCustomTouchBarItem {
    private let button = NSButton(title: "esc", target: self, action: #selector(press))

    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)
        button.target = self
        view = button
        self.view.widthAnchor.constraint(equalToConstant: 64).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func press() {
        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
        let cmdd = CGEvent(keyboardEventSource: src, virtualKey: 53, keyDown: true)
        cmdd?.post(tap: CGEventTapLocation.cghidEventTap)
    }
}
