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
    
    private init() {
        backgroundMusic     = setupAudioPlayer("mismatch-background-music", type: "mp3")
        selectSound         = setupAudioPlayer("select-sound", type: "wav")
        validGroupSound     = setupAudioPlayer("valid-group-sound", type: "wav")
        invalidGroupSound   = setupAudioPlayer("invalid-group-sound", type: "wav")
        
        backgroundMusic.volume = 0.25
        selectSound.volume = 0.6
    }
    
    /// Returns AVAudioPlayer for given audio file
    func setupAudioPlayer(file: String, type: String) -> AVAudioPlayer {
        
        var path = NSBundle.mainBundle().pathForResource(file, ofType: type)
        var url = NSURL.fileURLWithPath(path!)
        
        var error: NSError?
        
        var audioPlayer: AVAudioPlayer?
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        
        return audioPlayer!
    }
    
}
