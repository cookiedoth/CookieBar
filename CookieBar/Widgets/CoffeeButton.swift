//
//  CoffeeButton.swift
//  CookieBar
//
//  Created by Semyon Savkin on 13/08/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

class CoffeeButton: NSCustomTouchBarItem {
    private let button = NSButton(image: NSImage(named: "coffee")!, target: self, action: #selector(press))
    
    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)
        button.target = self
        button.cell?.isBordered = false
        view = button
        self.view.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.view.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func press() {
        let script = "tell application \"Finder\" to sleep"
        guard let appleScript = NSAppleScript(source: script) else { return }
        var error: NSDictionary?
        appleScript.executeAndReturnError(&error)
        if let error = error {
            print(error[NSAppleScript.errorAppName] as! String)
            print(error[NSAppleScript.errorBriefMessage] as! String)
            print(error[NSAppleScript.errorMessage] as! String)
            print(error[NSAppleScript.errorNumber] as! NSNumber)
            print(error[NSAppleScript.errorRange] as! NSRange)
        }
    }
}
