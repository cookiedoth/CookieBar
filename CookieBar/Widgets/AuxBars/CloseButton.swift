//
//  CloseButton.swift
//  CookieBar
//
//  Created by Semyon Savkin on 24/07/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

class CloseButton: NSCustomTouchBarItem {
    private let button = NSButton(image: NSImage(named: "exit")!, target: self, action: #selector(press))
    var callback: (() -> Void)?

    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)
        button.target = self
        button.imagePosition = .imageOnly
        button.isBordered = false
        view = button
        self.view.widthAnchor.constraint(equalToConstant: 64).isActive = true
        self.view.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setCallback(callback: @escaping () -> Void) {
        self.callback = callback
    }

    @objc func press() {
        if (callback != nil) {
            callback!()
        }
        TouchBarController.shared.restoreDefaultView()
    }
}
