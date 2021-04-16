//
//  MoodEntry.swift
//  Mandala
//
//  Created by Chao Mei on 30/3/21.
//

import Foundation

struct MoodEntry: Equatable {
    var mood: Mood
    var timpestamp: Date
    
    static func == (lhs: MoodEntry, rhs: MoodEntry) -> Bool {
        return lhs.mood == rhs.mood && lhs.timpestamp == rhs.timpestamp
    }
}
