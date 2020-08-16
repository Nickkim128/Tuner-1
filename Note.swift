//
//  Note.swift
//  Guitar Tuner
//
//  Created by Nicholas Kim on 2020/07/22.
//  Copyright © 2020 Nicholas Kim. All rights reserved.
//

import Foundation

class Note: Equatable{
    
    
    // cases for Name and Accidentals
    enum Accidental: Int {
        case natural, sharp, flat
    }
    enum Name: Int {
        case a, b, c, d, e, f, g
    }
    
    //12 notes in an octive
    static let all: [Note] = [
        Note(.c, .natural), Note(.c, .sharp), Note(.d, .natural), Note(.e, .flat), Note(.e, .natural), Note(.f, .natural), Note(.f, .sharp), Note(.g, .natural), Note(.a, .flat), Note(.a, .natural), Note(.b, .flat), Note(.b, .natural)
    ]
    
    var aNote: Name
    var aAccidental: Accidental
    
    // initializer
    init(_ aNote: Name, _ aAccidental: Accidental) {
        self.aNote = aNote
        self.aAccidental = aAccidental
    }
    
    // equality operator
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.aNote == rhs.aNote && lhs.aAccidental == rhs.aAccidental
    }
    
    //inequality operator
    static func != (lhs: Note, rhs: Note) -> Bool {
        return !(lhs == rhs)
    }
    
    var frequency: Double {
        let index = Note.all.index(of: self)! - Note.all.index(of: Note(.a, .natural))!
        return 440.0 * pow(2.0, Double(index)/12.0)
       }
    
    
}

