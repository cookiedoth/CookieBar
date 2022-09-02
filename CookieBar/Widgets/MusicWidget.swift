//
//  MusicWidget.swift
//  CookieBar
//
//  Created by Semyon Savkin on 27/08/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa

class MusicWidget: NSCustomTouchBarItem, NSGestureRecognizerDelegate {
    private let imageView = NSButton()
    private let artistLabel = NSButton()
    private let songLabel = NSButton()
    private var stackView: NSStackView!
    private var labelView: NSStackView!

    private func setupButton(button: NSButton) {
        let cell = NSButtonCell()
        cell.isBordered = false
        button.cell = cell
    }
    
    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)
        setupButton(button: artistLabel)
        setupButton(button: songLabel)
        setupButton(button: imageView)
        MusicServer.shared.setCallback { [self] in
            DispatchQueue.main.async {
                self.statusUpdated()
            }
        }
        artistLabel.target = MusicServer.shared
        artistLabel.action = #selector(MusicServer.shared.next)
        songLabel.target = MusicServer.shared
        songLabel.action = #selector(MusicServer.shared.next)
        imageView.target = MusicServer.shared
        imageView.action = #selector(MusicServer.shared.flipPause)
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        labelView = NSStackView(views: [songLabel, artistLabel])
        labelView.orientation = .vertical
        labelView.alignment = .left
        labelView.spacing = 0
        stackView = NSStackView(views: [imageView, labelView])
        stackView.edgeInsets.right = 20
        view = stackView
        statusUpdated()
    }

    func statusUpdated() {
        if MusicServer.shared.connected {
            if MusicServer.shared.paused {
                imageView.image = NSImage(named: NSImage.touchBarPlayTemplateName)!
            } else {
                imageView.image = MusicServer.shared.coverImage
            }
            artistLabel.attributedTitle = NSAttributedString(string: MusicServer.shared.artist, attributes: [ NSAttributedString.Key.foregroundColor : NSColor.gray])
            songLabel.title = MusicServer.shared.song
            stackView.setViews([imageView, labelView], in: .leading)
        } else {
            stackView.setViews([], in: .leading)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
