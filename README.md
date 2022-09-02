# CookieBar

Macbook touchbar customization plugin

<img width="1085" alt="screenshot" src="https://user-images.githubusercontent.com/42250320/188044023-d7dcb852-bf74-41dc-b30f-b291e24ec910.png">

# Installation

1. Download `CookieBar.app` from Releases tab (optionally saving it in `/Applications/`)
2. Launch the app, it will prompt the following premissions:
	* Location: for the weather widget
	* Reminders: to get the list of reminders from the MacOS app
	* Accessiblity: for `ESC` button
3. Open `/Library/Application Support/CookieBar/config.json`, and specify bluetooth headphones device name and Open Weather Map API key (could be generated [here](https://openweathermap.org/api))
4. Quit the app (its menu can be accessed from the right side of the menu bar), and relaunch it
5. Enjoy!

# Widgets

* ESC button
* Now Playing – displays the name of the current track. Clicking on the cover image switches play/pause, clicking on the track name works as the "next" button. The player should support an [API](#player-api).
* `Reminders.app` widget
* Weather widget – uses Open Weather Map
* Coffee button – activates sleep mode
* Bluetooth headphones button
* Volume slider
* Brightness slider
* Instantenious typing speed widget
* Battery widget
* Time widget

# Adding a widget

To add a widget, you need to do the following steps:

1. Define a widget class, inheriting `NSCustomTouchBarItem` (see implementations of current widgets in `Widgets` folder)
2. Add a widget identifier in `TouchBarIdentifiers.swift`
3. Add initializtion of the widget in `TouchBarController.swift`, and add it to `touchBar.defaultItemIdentifiers`. You can also remove widgets there and change their order.

# Music player API

The application runs a WebSocket server, which receive data about status changes of music player, and sends commands when the music buttons are clicked. The port of the server is specified in config.

The data about track is sent as the following JSON:

```json
{
	"connected": "true",        // if false, the music widget becomes hidden
	"artist": "artist_name",
	"song": "song_name",
	"coverImage": "",           // base64 string of album cover image, could be empty if not available
	"paused": false
}
```

This JSON can contain not all fields if only part of the data has changed.

The server sends `play`, `pause`, and `next` commands over WebSocket to the last connected client.

# References

* [**MTMR**](https://github.com/Toxblh/MTMR) – a highly customizable TouchBar plugin. I was not able to define my widgets in the config, which prompted me to create an app myself
* [**vas3k's post**](https://vas3k.com/blog/touchbar/) for original inspiration and some ideas
* Some icons are taken from [freeicons](https://freeicons.io/) and [icons8](https://icons8.com/)