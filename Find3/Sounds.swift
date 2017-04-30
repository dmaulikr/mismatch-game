//
//  Sounds.swift
//  Find3
//
//  Created by Susan Stevens on 6/26/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import Foundation
import AVFoundation

/// Singleton class for music and sound effects
class Sounds {
    var backgroundMusic     = AVAudioPlayer()
    var selectSound         = AVAudioPlayer()
    var validGroupSound     = AVAudioPlayer()
    var invalidGroupSound   = AVAudioPlayer()
    
    static let sharedInstance = Sounds()
    
    fileprivate init() {
        backgroundMusic     = setupAudioPlayer("mismatch-background-music", type: "mp3")
        selectSound         = setupAudioPlayer("select-sound", type: "wav")
        validGroupSound     = setupAudioPlayer("valid-group-sound", type: "wav")
        invalidGroupSound   = setupAudioPlayer("invalid-group-sound", type: "wav")
        
        backgroundMusic.volume = 0.25
        selectSound.volume = 0.6
    }
    
    /// Return AVAudioPlayer for given audio file
    func setupAudioPlayer(_ file: String, type: String) -> AVAudioPlayer {
        
        let path = Bundle.main.path(forResource: file, ofType: type)
        let url = URL(fileURLWithPath: path!)
        
        // var error: NSError?
        
        var audioPlayer: AVAudioPlayer?
        audioPlayer = try! AVAudioPlayer(contentsOf: url)
        
        return audioPlayer!
    }
    
}
