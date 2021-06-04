//
//  TagDataSource.swift
//  Photorama
//
//  Created by Chao Mei on 29/5/21.
//

import UIKit
import CoreData

class TagDataSource: NSObject, UITableViewDataSource {
    var tags = [Tag]()
    var photo: Photo!
    var store: PhotoStore!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let tag = tags[indexPath.row]
        cell.textLabel?.text = tag.name
    
        return cell
    }
    func tableView (_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tags.remove(at: indexPath.row)
            photo.removeFromTags(tags[indexPath.row])
            do {
                try store.persistentContainer.viewContext.save()
            } catch {
                print("Core data save failed: \(error)")
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
