//
//  VolumeController.swift
//  CookieBar
//
//  Created by Semyon Savkin on 24/07/2022.
//  Copyright © 2022 Semyon Savkin. All rights reserved.
//

import Cocoa
import AudioToolbox

class VolumeController : NSObject {
    static let shared = VolumeController()

    private func getDefaultOutputDeviceID() -> AudioDeviceID {
        var defaultOutputDeviceID = AudioDeviceID(0)
        var defaultOutputDeviceIDSize = UInt32(MemoryLayout.size(ofValue: defaultOutputDeviceID))
        
        var getDefaultOutputDevicePropertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultOutputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMaster))
        
        AudioObjectGetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
            &getDefaultOutputDevicePropertyAddress,
            0,
            nil,
            &defaultOutputDeviceIDSize,
            &defaultOutputDeviceID)

        return defaultOutputDeviceID
    }

    func setVolume(val: Double) {
        let defaultOutputDeviceID = getDefaultOutputDeviceID()

        var volume = Float32(val)
        let volumeSize = UInt32(MemoryLayout.size(ofValue: volume))
        
        var volumePropertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioHardwareServiceDeviceProperty_VirtualMasterVolume,
            mScope: kAudioDevicePropertyScopeOutput,
            mElement: kAudioObjectPropertyElementMaster)
        
        AudioObjectSetPropertyData(
            defaultOutputDeviceID,
            &volumePropertyAddress,
            0,
            nil,
            volumeSize,
            &volume)
    }

    func setMuted(isMuted: Bool) {
        let defaultOutputDeviceID = getDefaultOutputDeviceID()

        var muted = UInt(isMuted ? 1 : 0)
        let mutedSize = UInt32(MemoryLayout.size(ofValue: muted))

        var address = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyMute,
            mScope: kAudioDevicePropertyScopeOutput,
            mElement: kAudioObjectPropertyElementMaster
        )

        AudioObjectSetPropertyData(defaultOutputDeviceID, &address, 0, nil, mutedSize, &muted)
    }

    func getVolume() -> Double {
        let defaultOutputDeviceID = getDefaultOutputDeviceID()
        
        var volume = Float32(0.0)
        var volumeSize = UInt32(MemoryLayout.size(ofValue: volume))
        
        var volumePropertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioHardwareServiceDeviceProperty_VirtualMasterVolume,
            mScope: kAudioDevicePropertyScopeOutput,
            mElement: kAudioObjectPropertyElementMaster)
        
        AudioObjectGetPropertyData(
            defaultOutputDeviceID,
            &volumePropertyAddress,
            0,
            nil,
            &volumeSize,
            &volume)
        
        return Double(volume)
    }

    func setVolumeAndMuted(val: Double) {
        setVolume(val: val)
        setMuted(isMuted: val < 0.003)
    }
}
