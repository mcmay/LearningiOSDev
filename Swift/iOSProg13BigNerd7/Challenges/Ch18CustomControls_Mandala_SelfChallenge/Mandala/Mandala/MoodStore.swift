//
//  MoodStore.swift
//  Mandala
//
//  Created by Chao Mei on 16/4/21.
//

import UIKit

class MoodStore {
    var allEntries = [MoodEntry]()
    
    func addEntry (_ entry: MoodEntry, at index: Int) -> Void {
        allEntries.insert(entry, at: index)
    }
    
    func deleteEntry(_ entry: MoodEntry) -> Void {
        if let index = allEntries.firstIndex(of: entry) {
            allEntries.remove(at: index)
        }
    }
    
    func saveChanges () -> Bool {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allEntries)
        }
    }
}
