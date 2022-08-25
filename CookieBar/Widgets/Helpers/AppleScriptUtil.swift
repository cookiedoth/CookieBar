//
//  AppleScriptUtil.swift
//  CookieBar
//
//  Created by Semyon Savkin on 25/08/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

func runAppleScriptFromResource(resourceName: String, args: [String] = []) -> String? {
    let scriptPath = Bundle.main.path(forResource: resourceName, ofType: "scpt")!

    let process = Process()
    if process.isRunning == false {
        let outputPipe = Pipe()
        process.launchPath = "/usr/bin/osascript"
        process.arguments = [scriptPath] + args
        process.standardOutput = outputPipe
        process.launch()
        let outData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: outData, encoding: .utf8)
        return output
    }

    return nil
}
