//
//  HeadphonesWidget.swift
//  CookieBar
//
//  Created by Semyon Savkin on 15/08/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

class HeadphonesWidget: NSCustomTouchBarItem {
    private let button = NSButton(image: NSImage(named: "airpods_not_found")!, target: self, action: #selector(press))
    private let controller = HeadphonesController()
    private var deviceName: String?

    func tryAttachDevice() {
        if (deviceName != nil) {
            _ = controller.attachDevice(name: deviceName!, callback: { [self] in
                self.updateStatus()})
        }
    }

    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)
        deviceName = ConfigManager.shared.headphonesName
        tryAttachDevice()

        button.target = self
        button.cell?.isBordered = false
        view = button
        self.view.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.view.heightAnchor.constraint(equalToConstant: 30).isActive = true

        updateStatus()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateStatus() {
        if !controller.isDeviceFound() {
            button.image = NSImage(named: "airpods_not_found")!
        } else if !controller.isConnected() {
            button.image = NSImage(named: "airpods")!
        } else {
            button.image = NSImage(named: "airpods_connected")!
        }
    }
    
    @objc func press() {
        if controller.isDeviceFound() {
            controller.toggleConnection()
        } else {
            tryAttachDevice()
        }
    }
}
