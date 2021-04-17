//
//  MoodStore.swift
//  Mandala
//
//  Created by Chao Mei on 16/4/21.
//

import UIKit

class MoodStore {
    var allEntries = [MoodEntry]()
    let entryArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent("entries.plist")
    } ()
    
    init () {
        do {
            let data = try Data(contentsOf: entryArchiveURL)
            let unarchiver = PropertyListDecoder()
            let entries = try unarchiver.decode([MoodEntry].self, from: data)
            allEntries = entries
        } catch {
            print("Error reading in saved items: \(error)")
        }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges),
                                       name: UIScene.didEnterBackgroundNotification, object: nil)
    }
    
    func addEntry (_ entry: MoodEntry, at index: Int) -> Void {
        allEntries.insert(entry, at: index)
    }
    
    func deleteEntry(_ entry: MoodEntry) -> Void {
        if let index = allEntries.firstIndex(of: entry) {
            allEntries.remove(at: index)
        }
    }
    
    @objc func saveChanges () -> Bool {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allEntries)
            try data.write(to: entryArchiveURL, options: [.atomic])
            print("Entries are saved.")
            return true
        } catch let encodingError {
            print("Error encoding allEntries: \(encodingError)")
            return false
        }
    }
}
