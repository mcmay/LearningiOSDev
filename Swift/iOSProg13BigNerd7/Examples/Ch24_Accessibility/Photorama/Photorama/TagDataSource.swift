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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let tag = tags[indexPath.row]
        cell.textLabel?.text = tag.name
        cell.accessibilityHint = "Toggles selection"
        cell.accessibilityTraits = [.button]
        return cell
    }
}
