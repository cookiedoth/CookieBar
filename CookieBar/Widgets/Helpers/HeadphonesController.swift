//
//  HeadphonesController.swift
//  CookieBar
//
//  Created by Semyon Savkin on 15/08/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa
import IOBluetooth

class HeadphonesController: NSObject {
    private var device: IOBluetoothDevice?
    private var callback: () -> Void = {}

    func isDeviceFound() -> Bool {
        return device != nil
    }

    func isConnected() -> Bool {
        return (device != nil) ? device!.isConnected() : false
    }

    @objc func connected() {
        callback()
    }

    @objc func disconnected() {
        callback()
    }
    
    func attachDevice(name: String, callback: @escaping () -> Void) -> Bool {
        self.callback = callback
        guard let devices = IOBluetoothDevice.pairedDevices() else {
            return false
        }
        for item in devices {
            if let device = item as? IOBluetoothDevice {
                if device.name == name {
                    self.device = device
                    IOBluetoothDevice.register(forConnectNotifications: self, selector: #selector(connected))
                    device.register(forDisconnectNotification: self, selector: #selector(disconnected))
                    return true
                }
            }
        }
        return false
    }

    func toggleConnection() {
        if (isConnected()) {
            device?.closeConnection()
        } else {
            device?.openConnection()
        }
    }
}
