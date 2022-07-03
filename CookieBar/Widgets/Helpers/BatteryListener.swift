//
//  BatteryListener.swift
//  CookieBar
//
//  Created by Semyon Savkin on 02/07/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa
import IOKit.ps

class BatteryListener: NSObject {
    var dataFetched = false;
    var currentCharge = 0;
    var isCharging = false;
    var callback: () -> Void = {}

    func start(callback: @escaping () -> Void) {
        self.callback = callback
        let context = UnsafeMutableRawPointer(Unmanaged.passRetained(self).toOpaque())
        let loop = IOPSNotificationCreateRunLoopSource({ context in
            Unmanaged<BatteryListener>.fromOpaque(context!).takeUnretainedValue().batteryUpdated()
        }, context).takeRetainedValue() as CFRunLoopSource
        CFRunLoopAddSource(CFRunLoopGetCurrent(), loop, CFRunLoopMode.defaultMode)
        batteryUpdated()
    }

    func batteryUpdated() {
        let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let psList = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as [CFTypeRef]
        let ps = psList[0]
        let info = IOPSGetPowerSourceDescription(snapshot, ps).takeUnretainedValue() as! [String: AnyObject]
        let currentCharge = info[kIOPSCurrentCapacityKey] as? Int
        let ACPower = info[kIOPSPowerSourceStateKey] as? String
        if (currentCharge != nil && ACPower != nil) {
            self.dataFetched = true
            self.currentCharge = currentCharge!
            self.isCharging = (ACPower! == "AC Power")
        } else {
            self.dataFetched = false
        }
        self.callback()
    }
}
