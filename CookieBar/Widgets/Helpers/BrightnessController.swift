//
//  BrightnessController.swift
//  CookieBar
//
//  Created by Semyon Savkin on 11/08/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

class BrightnessController: NSObject {
    static let shared = BrightnessController()

    func setBrightness(val: Double) {
        var iterator: io_iterator_t = 0
        if IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching("IODisplayConnect"), &iterator) == kIOReturnSuccess {
            var service: io_object_t = 1
            while service != 0 {
                service = IOIteratorNext(iterator)
                IODisplaySetFloatParameter(service, 0, kIODisplayBrightnessKey as CFString, Float(val))
                IOObjectRelease(service)
            }
        }
    }

    func getBrightness() -> Double {
        var brightness: Float = 1.0
        var service: io_object_t = 1
        var iterator: io_iterator_t = 0
        let result: kern_return_t = IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching("IODisplayConnect"), &iterator)
        
        if result == kIOReturnSuccess {
            
            while service != 0 {
                service = IOIteratorNext(iterator)
                IODisplayGetFloatParameter(service, 0, kIODisplayBrightnessKey as CFString, &brightness)
                IOObjectRelease(service)
            }
        }
        return Double(brightness)
    }
}
