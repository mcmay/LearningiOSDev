// 
//  Copyright © 2020 Big Nerd Ranch
//
/*
 * “Gold Challenge: Favorite Items
 * Allow the user to select favorite items by swiping right on them. You will want to use the table view edit
 * actions to accomplish this. This is a bit involved; you will need to:

 * Add an isFavorite property to the Item class.

 * Investigate the UITableViewDataSource for a way to add edit actions to a row, then implement this to toggle
 * the isFavorite property on the item.

 * Display whether an item is favorited. This could be done by appending (Favorite) to the item’s name on the
 * textLabel property.

 * Bonus: Implement a way to show only favorited items. This could be done with an additional button in the table
 * view header view that toggles which items are displayed.”

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
    
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
                    -> UISwipeActionsConfiguration? {
        let toggleIsFavorite = UIContextualAction(style: .normal, title: "Favorite", handler: { [self](ac: UIContextualAction, view: UIView, actionPeformed: (Bool)->Void) in
            
            var item = sections[indexPath.section].items[indexPath.row]
            item.isFavorite = true
            let cell = tableView.cellForRow(at: indexPath)
            cell!.textLabel?.text = item.name + "(Favorite)"
            actionPeformed(true)
        })
        return UISwipeActionsConfiguration(actions: [toggleIsFavorite])
    }
}
