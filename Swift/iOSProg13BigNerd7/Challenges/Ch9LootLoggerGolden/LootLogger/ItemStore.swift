// 
//  Copyright © 2020 Big Nerd Ranch
//

import UIKit

class ItemStore {
    let criteria = 50
    var headers: [String] { ["$\(criteria) and above", "Less than $\(criteria)"] }
    var allItems = [Item]()
    var groups: Dictionary<String, [Item]> { Dictionary(grouping: allItems){
        return  headers[$0.valueInDollars >= criteria ? 0 : 1] } }
    var sections: [(header: String, items: [Item])] { groups.map{(header, items) in
        return (header, items)
     }
    }
    let ascending = false
    var sectionsSorted: [(header: String, items: [Item])] { sections.sorted {
            return ascending ? ($0.items.first!.valueInDollars < $1.items.first!.valueInDollars) : ($0.items.first!.valueInDollars >= $1.items.first!.valueInDollars)
        }
    }
    
    @discardableResult func createItem() -> Item {
        var newItem = Item(random: true)
        if allItems.count == 0 {
            if ascending {
                while newItem.valueInDollars >= criteria {
                    newItem = Item(random: true)
                }
            } else {
                while newItem.valueInDollars < criteria {
                    newItem = Item(random: true)
                }
            }
        }
        allItems.append(newItem)
        
        return newItem
    }
    
    func removeItem(_ item: Item) {
        if let index = allItems.firstIndex(of: item) {
            allItems.remove(at: index)
        }
    }
    
    func moveItem(from fromIndex: Int, to toIndex: Int) {
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
}
