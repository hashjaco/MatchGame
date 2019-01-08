//
//  SoundManager.swift
//  Match App
//
//  Created by Hashim Jacobs on 1/8/19.
//  Copyright © 2019 Syntheticherorism. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case shuffle
        case match
        case noMatch
    }
    
    static func playSound(_ effect:SoundEffect) {
        var soundFileName = ""
        
        switch effect {
            
        case .flip:
            soundFileName = "cardflip"
        
        case .match:
            soundFileName = "dingcorrect"
        
        case .shuffle:
            soundFileName = "shuffle"
        
        case .noMatch:
            soundFileName = "dingwrong"
            
        }
        
        // Get path to sound file inside bundle
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: "wav")
        
        guard bundlePath != nil else {
            print("Couldn't find sound file \(soundFileName) in the bundle.")
            return
        }
        
        // Create URL object from string path
        let soundURL = URL(fileURLWithPath: bundlePath!)
        do {
            // Create audio player object
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            // Play sound
            audioPlayer?.play()
        }
        catch {
            // Couldn't create audio player object. Log the error
            print("Couldn't create the audio player object for the sound file \(soundFileName)")
        }
    }
    
}
