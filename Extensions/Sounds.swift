//
//  Sounds.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 05/10/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

var sound: AVAudioPlayer?

extension UIViewController {
    
    func playSound(soundName: String) {
        let path = Bundle.main.path(forResource: soundName, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            sound = try AVAudioPlayer(contentsOf: url)
            sound?.play()
        }
        catch {
            // couldn't load file :(
        }
    }
}
