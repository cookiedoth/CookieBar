//
//  ConfigManager.swift
//  CookieBar
//
//  Created by Semyon Savkin on 12/08/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

class ConfigManager: NSObject {
    static let shared = ConfigManager()
    
    static let configFolder =  NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first!.appending("/CookieBar")
    static let configPath = configFolder.appending("/config.json")
    
    var apiKey: String?
    
    func tryParseConfig() -> Bool {
        if !FileManager.default.fileExists(atPath: ConfigManager.configPath) {
            return false
        }
        let data = try? NSData.init(contentsOfFile: ConfigManager.configPath) as Data
        if (data == nil) {
            return false
        }
        let json = try? JSONSerialization.jsonObject(with: data!, options: [])
        
        apiKey = nil
        if let root = json as? [String: Any],
            let apiKeyAny = root["api_key"] {
            apiKey = apiKeyAny as? String
        }
        
        return true
    }
    
    func readConfig() {
        if !tryParseConfig() {
            let defaultConfigPath = Bundle.main.path(forResource: "defaultConfig", ofType: "json")!
            try? FileManager.default.createDirectory(atPath: ConfigManager.configFolder, withIntermediateDirectories: true)
            try! FileManager.default.copyItem(atPath: defaultConfigPath, toPath: ConfigManager.configPath)
            _ = tryParseConfig()
        }
    }
}
