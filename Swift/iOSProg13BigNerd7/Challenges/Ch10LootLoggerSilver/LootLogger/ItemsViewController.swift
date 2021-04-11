// 
//  Copyright © 2020 Big Nerd Ranch
//
/*
 *“Silver Challenge: Long Item Names
 * Currently, if the item’s name is long it will overlap with the value
 * label (Figure 10.11). This will be more important in Chapter 11 and
 * Chapter 12 when you will add the ability for the user to edit an item. To
 * see this for now, update Item’s initializer in Item.swift to have an
 * extra-long name.

 * Figure 10.11  Labels overlapping on the cell

 * Fix this problem by allowing the nameLabel to wrap to multiple lines if
 * the name gets too long (Figure 10.12). You will need to add at least one
 * new constraint and allow the label to wrap multiple lines as you did in
 * Chapter 7.”

 * Excerpt From: Aaron Hillegass. “iOS Programming: The Big Nerd Ranch
 * Guide, 7th Edition.” Apple Books.
 */
import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
        
    }
    
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

        // Figure out where that item is in the array
        // (Note: You will have an error on the next line; you will fix it soon)
        if let index = itemStore.allItems.firstIndex(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)

            // Insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView,
            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell",
            for: indexPath) as! ItemCell
        
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the table view
        let item = itemStore.allItems[indexPath.row]

        // Configure the cell with the Item
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = "$\(item.valueInDollars)"
        //cell.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        //cell.nameLabel.trailingAnchor.constraint(equalTo: cell.valueLabel.leadingAnchor, constant: -10).isActive = true
        if item.valueInDollars < 50 {
            cell.valueLabel.textColor = UIColor.green
        } else {
            cell.valueLabel.textColor = UIColor.red
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        // If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            // Remove the item from the store
            itemStore.removeItem(item)

            // Also remove that row from the table view with an animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        // Update the model
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }

}
