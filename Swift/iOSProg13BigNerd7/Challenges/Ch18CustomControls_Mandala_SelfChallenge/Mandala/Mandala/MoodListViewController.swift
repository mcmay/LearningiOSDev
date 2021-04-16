//
//  MoodListViewController.swift
//  Mandala
//
//  Created by Chao Mei on 4/4/21.
//

import UIKit

class MoodListViewController: UITableViewController {
    private var moodStore: MoodStore!
    
    override func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moodStore.allEntries.count
    }
    
    override func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let moodEntry = moodStore.allEntries[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        cell.imageView?.image = moodEntry.mood.image
        cell.textLabel?.text = "I was \(moodEntry.mood.name)"
        
        let dateString = DateFormatter.localizedString(from: moodEntry.timpestamp, dateStyle: .medium, timeStyle: .short)
        cell.detailTextLabel?.text = "on \(dateString)"
        
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let moodEntry = moodStore.allEntries[indexPath.row]
            
            moodStore.deleteEntry(moodEntry)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension MoodListViewController: MoodsConfigurable {
    func create(from moodStore: MoodStore) {
        self.moodStore = moodStore
    }
    func add(_ moodEntry: MoodEntry) -> Void {
        moodStore.allEntries.insert(moodEntry, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
}
