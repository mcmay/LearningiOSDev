//
//  Mood.swift
//  Mandala
//
//  Created by Chao Mei on 30/3/21.
//

import UIKit

class Mood: Equatable {
    
    var name: String
    var image: UIImage
    var color: UIColor
    var imageBase64String: String!
    
    init(name: String, image: UIImage, color: UIColor) {
        self.name = name
        self.image = image
        self.color = color
    }
    static func == (lhs: Mood, rhs: Mood) -> Bool {
        return lhs.name == rhs.name && lhs.image == rhs.image
            && lhs.color == rhs.color
    }
    func encode (to encoder: Encoder) throws {
        
        do {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(name, forKey: .name)
            let imageData = image.pngData()
            imageBase64String = imageData!.base64EncodedString()
            try container.encode(imageBase64String, forKey: .imageBase64String)
            
            let colorData = try NSKeyedArchiver.archivedData(withRootObject: color,
                                                             requiringSecureCoding: false)
            try container.encode(colorData, forKey: .color)
        } catch {
            print("Error encoding entries: \(error)")
        }
    }
    
    required init (from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
            
        name = try container.decode(String.self, forKey: .name)
                                                            
        imageBase64String = try container.decode(String.self, forKey: .imageBase64String)
                                                                // I mistakenly typed ".image" here
                                                                // instead of .imageBased64String
                                                                // when I decoded it, the key became ".imageBase64String.
                                                                // Hence, the decoding error.
        let imageData = Data(base64Encoded: imageBase64String)
            
        //if let imageData = imageData {
            image = UIImage(data: imageData!)!
        // }
            
        let colorData = try container.decode(Data.self, forKey: .color)
            
        color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor ?? UIColor.black
    }
}

extension Mood: Codable {
    static let angry = Mood(name: "angry", image: UIImage(resource: .angry), color: UIColor.angry)
    static let confused = Mood(name: "confused", image: UIImage(resource: .confused), color: UIColor.confused)
    static let crying = Mood(name: "crying", image: UIImage(resource: .crying), color: UIColor.crying)
    static let goofy = Mood(name: "goofy", image: UIImage(resource: .goofy), color: UIColor.goofy)
    static let happy = Mood(name: "happy", image: UIImage(resource: .happy), color: UIColor.happy)
    static let meh = Mood(name: "meh", image: UIImage(resource: .meh), color: UIColor.meh)
    static let sad = Mood(name: "sad", image: UIImage(resource: .sad), color: UIColor.sad)
    static let sleepy = Mood(name: "sleepy", image: UIImage(resource: .sleepy), color: UIColor.sleepy)
    
    enum CodingKeys: String, CodingKey {
        case name
        case image
        case color
        case imageBase64String
    }
}
