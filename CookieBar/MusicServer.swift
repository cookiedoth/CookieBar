//
//  MusicServer.swift
//  CookieBar
//
//  Created by Semyon Savkin on 26/08/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa
import Swifter

class MusicServer: NSObject {
    static let shared = MusicServer()

    private let server = HttpServer()
    private var lastSession: WebSocketSession?

    private var callback: () -> Void = {}

    var connected = false
    var artist = ""
    var song = ""
    var coverImage = NSImage()
    var paused = false

    override init() {
    }

    func updateStatus(text: String) {
        let json = try? JSONSerialization.jsonObject(with: text.data(using: .utf8)!, options: [])
        if let root = json as? [String: Any] {
            if let connected = root["connected"] as? Bool {
                self.connected = connected
            }

            if let artist = root["artist"] as? String {
                self.artist = artist
            }

            if let song = root["song"] as? String {
                self.song = song
            }

            if let coverImage = root["coverImage"] as? String {
                let imageData = Data(base64Encoded: coverImage)
                if imageData != nil {
                    self.coverImage = NSImage(data: imageData!) ?? NSImage()
                }
            }

            if let paused = root["paused"] as? Bool {
                self.paused = paused
            }
        }
        self.callback()
    }

    func start() {
        server["/music"] = websocket(text: { session, text in
            self.lastSession = session
            self.updateStatus(text: text)
        })
        try! server.start(UInt16(ConfigManager.shared.musicServerPort!))
    }

    func setCallback(callback: @escaping () -> Void) {
        self.callback = callback
    }

    @objc func flipPause() {
        lastSession?.writeText(paused ? "play" : "pause")
    }

    @objc func next() {
        lastSession?.writeText("next")
    }
}
