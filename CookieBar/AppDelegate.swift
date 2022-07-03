//
//  AppDelegate.swift
//  CookieBar
//
//  Created by Semyon Savkin on 02/07/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let _ = TouchBarController.shared
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

