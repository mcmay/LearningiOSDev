// 
//  Copyright © 2020 Big Nerd Ranch
//

import UIKit

class Item: Equatable {
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    let dateCreated: Date
    
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.name == rhs.name
            && lhs.serialNumber == rhs.serialNumber
            && lhs.valueInDollars == rhs.valueInDollars
            && lhs.dateCreated == rhs.dateCreated
    }

    init(name: String, serialNumber: String?, valueInDollars: Int) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreated = Date()
    }
    
    convenience init(random: Bool = false) {
        if random {
            let adjectives = ["Fluffy fluffy fluffy fluffy fluffy",
                              "Rusty Rusty Rusty Rusty Rusty Rusty",
                              "Shiny Shiny Shiny Shiny Shiny Shiny"]
            let nouns = ["Bear bear bear bear bear bear bear",
                         "Spork Spork Spork Spork Spork Spork",
                         "Mac Mac Mac Mac Mac Mac Mac Mac Mac"]
            
            let randomAdjective = adjectives.randomElement()!
            let randomNoun = nouns.randomElement()!

            let randomName = "\(randomAdjective) \(randomNoun)"
            let randomValue = Int.random(in: 0..<100)
            let randomSerialNumber =
                UUID().uuidString.components(separatedBy: "-").first!

            self.init(name: randomName,
                      serialNumber: randomSerialNumber,
                      valueInDollars: randomValue)
        } else {
            self.init(name: "", serialNumber: nil, valueInDollars: 0)
        }
    }
    
}
