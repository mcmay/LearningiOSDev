//
//  ItemStore.swift
//  LootLogger
//
//  Created by Chao Mei on 3/2/21.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    let itemArchiveURL: URL = {
        // In iOS, the .userDomainMask is the only domain option avaliable, unlik on MacOS
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        return documentDirectory.appendingPathComponent("items.plist")
    } ()
    init () {
        do {
            let data = try Data(contentsOf: itemArchiveURL)
            let unarchiver = PropertyListDecoder()
            let items = try unarchiver.decode([Item].self, from: data)
            allItems = items
        } catch {
            print("Error reading in saved items: \(error)")
        }
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(saveChanges),
                                           name: UIScene.didEnterBackgroundNotification, object: nil)
    }
    @discardableResult func createItem () -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    func removeItem (_ item: Item) {
        if let index = allItems.firstIndex(of: item) {
            allItems.remove(at: index)
        }
    }
    func moveItem (from fromIndex: Int, to toIndex: Int) -> Void {
        if fromIndex == toIndex {
            return
        }
        // Get reference to object being moved so you can reinsert it
        let movedItem = allItems[fromIndex]
        
        // Remove item from array
        allItems.remove(at: fromIndex)
        
        // Insert item in array at new location
        allItems.insert(movedItem, at: toIndex)
    }
    // ref.: notificationCenter.addObserver in init()
    @objc func saveChanges () throws {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allItems)
            // .atomic is used to ensure that potential write error will not
            // erase possibly existing items.plist file
            try data.write(to: itemArchiveURL, options: [.atomic])
            print("Saved all of the items")
        } catch let encodingError {
            print("Error encoding allItems: \(encodingError)")
        }
    }
}
