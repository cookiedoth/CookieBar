//
//  WindowController.swift
//  CookieBar
//
//  Created by Semyon Savkin on 02/07/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, NSTouchBarDelegate {

    private let touchBarController = TouchBarController()

    override func windowDidLoad() {
        super.windowDidLoad()
    }

    override func makeTouchBar() -> NSTouchBar? {
        return touchBarController.makeTouchBar()
    }

}
