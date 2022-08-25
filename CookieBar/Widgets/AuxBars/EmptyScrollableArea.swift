//
//  EmptyScrollableArea.swift
//  CookieBar
//
//  Created by Semyon Savkin on 25/08/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

class EmptyScrollableArea: NSCustomTouchBarItem {
    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)

        let scrollView = NSScrollView()
        view = scrollView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
