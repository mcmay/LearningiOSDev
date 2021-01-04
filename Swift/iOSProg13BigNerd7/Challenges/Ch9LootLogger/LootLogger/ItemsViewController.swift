// 
//  Copyright © 2020 Big Nerd Ranch
//
/*
 * “Bronze Challenge: Sections
 * Have the UITableView display two sections – one for items worth more than $50 and one for the rest. Before you
 * start this challenge, make sure you copy the folder containing the project and all its source files in Finder.
 * Then tackle the challenge in the copied project; you will need the original to build on in the following
 * chapters.”
 *
 * Excerpt From: Aaron Hillegass. “iOS Programming: The Big Nerd Ranch Guide, 7th Edition.” Apple Books.
 */

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    var sections: [(header: String, items: [Item])]!
    var idx = -1
    
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        // If you are currently in editing mode...
        if isEditing {
            // Change text of button to inform user of state
            sender.setTitle("Edit", for: .normal)

            // Turn off editing mode
            setEditing(false, animated: true)
        } else {
            // Change text of button to inform user of state
            sender.setTitle("Done", for: .normal)

            // Enter editing mode
            setEditing(true, animated: true)
        }
    }
    
    @IBAction func addNewItem(_ sender: UIButton) {
        // Create a new item and add it to the store
        let newItem = itemStore.createItem()
        
        sections = itemStore.sectionsSorted
        let index = sections.firstIndex{ $0.items.contains(newItem) }
        // Figure out where that item is in the array
        // (Note: You will have an error on the next line; you will fix it soon)
        if tableView.numberOfSections < 2 && idx != index! {
            idx = index!
            tableView.insertSections(IndexSet(integer: tableView.numberOfSections), with: .automatic)
        }
        
        if sections[index!].items.count > 1 {
            if let i = sections[index!].items.firstIndex(of: newItem) {
                let indexPath = IndexPath(row: i, section: index!)
                // Insert this new row into the table
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    override func numberOfSections (in tableView: UITableView) -> Int {
        if let sections = sections {
            return sections.count
        } else {
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        // Set the text on the cell with the description of the item
        // that is at the nth index of items in the section, where n = row.
        // This cellwill appear in on the table view.
    
        let section = sections[indexPath.section]
        let item = section.items[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "$\(item.valueInDollars)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        // If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            let item = sections[indexPath.section].items[indexPath.row]
            // Remove the item from the store
            itemStore.removeItem(item)
            sections[indexPath.section].items.remove(at: indexPath.row)
            
            // Also remove that row from the table view with an animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            if sections[indexPath.section].items.count == 0 {
                sections.remove(at: indexPath.section)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        // Update the model
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}
