//
//  KeyboardMonitor.swift
//  CookieBar
//
//  Created by Semyon Savkin on 02/07/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

class KeyboardMonitor: NSObject {
    private var monitor: Any?
    private var timer: Timer!
    private var callback: (Int) -> Void = {_ in }
    
    var speed = 0
    private var realSpeed = 0.0
    private var lastUpdate = 0.0
    private var lastKeystroke = 0.0

    static let decay = 0.9
    static let mult = -60 * log(decay)
    static let idleTime = 7.0
    
    func start(callback: @escaping (Int) -> Void) {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String : true]
        let access = AXIsProcessTrustedWithOptions(options)
        print(access)
        self.monitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown, handler: {
            [self] (event: NSEvent) in
            self.keyPressed(event: event)})
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
        self.callback = callback
        self.callback(0)
    }

    private func processTimePass(time: Double) {
        realSpeed *= pow(KeyboardMonitor.decay, time - lastUpdate)
        lastUpdate = time
    }

    private func updateSpeed() {
        if (lastUpdate - lastKeystroke > KeyboardMonitor.idleTime) {
            speed = 0
        } else {
            speed = Int(round(realSpeed))
        }
        callback(speed)
    }

    func keyPressed(event: NSEvent) {
        let time = NSDate().timeIntervalSince1970
        processTimePass(time: time)
        lastKeystroke = time
        realSpeed += KeyboardMonitor.mult
        updateSpeed()
    }

    @objc func onTimer() {
        let time = NSDate().timeIntervalSince1970
        processTimePass(time: time)
        updateSpeed()
    }
}
