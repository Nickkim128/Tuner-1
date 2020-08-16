//
//  Pitch.swift
//  Guitar Tuner
//
//  Created by Nicholas Kim on 2020/07/22.
//  Copyright © 2020 Nicholas Kim. All rights reserved.
//

import Foundation
import AudioKit

class Pitch {
    
    // Properties
    let frequency: Double
    let note: Note
    let octave: Int
    
    // initilizer for pitch
    private init (note: Note, octave: Int){
        self.note = note
        self.octave = octave
        self.frequency = note.frequency * pow(2.0, Double(octave) - 4.0)
    }
    
    // all holds all 12 notes from the 0th to 8th octave
    static let all = Array((0...8).map {octave -> [Pitch] in Note.all.map {note -> Pitch in Pitch(note: note, octave: octave)
        }
    }).joined()
    
    
/*
     Creates an array with each element holding a Pitch instance for each note and the difference between a certain frequency freq and each note's frequency and returns the pitch with the smallest difference to freq.
     */
    static func findClosestNote(_ freq: Double) -> Pitch {
        var list = all.map { pitch -> (pitch: Pitch, distance: Double)
            in (pitch: pitch, distance: abs(pitch.frequency - freq))
        }
        
        list.sort{$0.distance < $1.distance}
        return list.first!.pitch
    }
}
