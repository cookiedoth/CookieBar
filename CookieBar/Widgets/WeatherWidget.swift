//
//  WeatherWidget.swift
//  CookieBar
//
//  Created by Semyon Savkin on 12/08/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa
import CoreLocation

class WeatherWidget: NSCustomTouchBarItem, CLLocationManagerDelegate {
    static let kNoWeatherText = "🤔 ??°"
    static let iconMapping = [
        "01d": "☀️",
        "01n": "🌙",
        "02d": "⛅",
        "02n": "🌌",
        "03d": "☁️",
        "03n": "☁️",
        "04d": "☁️",
        "04n": "☁️",
        "09d": "☂️",
        "09n": "☂️",
        "10d": "☂️",
        "10n": "☂️",
        "11d": "⚡",
        "11n": "⚡",
        "13d": "❄️",
        "13n": "❄️",
        "50n": "🌫️",
        "50d": "🌫️",
    ]
    
    private let activity: NSBackgroundActivityScheduler
    private let button = NSButton()
    private let apiKey: String
    private let locationManager: CLLocationManager
    private var location: CLLocation?
    
    init(identifier: NSTouchBarItem.Identifier, apiKey: String) {
        activity = NSBackgroundActivityScheduler(identifier: "CookieBar.weather")
        activity.interval = 600
        locationManager = CLLocationManager()
        self.apiKey = apiKey
        
        super.init(identifier: identifier)
        
        let cell = NSButtonCell()
        cell.isBordered = false
        button.cell = cell
        view = button
        button.title = WeatherWidget.kNoWeatherText
        button.target = self
        button.action = #selector(press)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        
        activity.repeats = true
        activity.qualityOfService = .utility
        activity.schedule { (completion: NSBackgroundActivityScheduler.CompletionHandler) in
            self.updateWeather()
            completion(NSBackgroundActivityScheduler.Result.finished)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            if (self.location == nil) {
                self.location = location
                updateWeather()
            } else {
                self.location = location
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func updateWeather() {
        if location == nil {
            return
        }
        let request = URLRequest(url: URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(location!.coordinate.latitude)&lon=\(location!.coordinate.longitude)&appid=\(apiKey)&units=metric")!)
        
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.button.title = WeatherWidget.kNoWeatherText
                }
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            var temp: Int?
            var emoji: String?
            if let dict = json as? [String: Any] {
                if let weatherArr = dict["weather"] as? [Any],
                    let weather = weatherArr[0] as? [String: Any],
                    let icon = weather["icon"] as? String {
                    emoji = WeatherWidget.iconMapping[icon]
                }
                if let main = dict["main"] as? [String: Any],
                    let tempDouble = main["temp"] as? Double {
                    temp = Int(round(tempDouble))
                }
            }
            
            if temp != nil && emoji != nil {
                DispatchQueue.main.async {
                    self.button.title = "\(emoji!) \(temp!)°"
                }
            } else {
                print("bad response from openweathermap API:")
                print(String(data: data, encoding: .utf8)!)
            }
        }
        
        task.resume()
    }
    
    @objc func press() {
        updateWeather()
    }
}
