//
//  UIIMage+Mandala.swift
//  Mandala
//
//  Created by Chao Mei on 30/3/21.
//

import UIKit

enum ImageResource: String {
    case angry
    case confused
    case crying
    case goofy
    case happy
    case meh
    case sad
    case sleepy
}

extension UIImage {
    convenience init(resource: ImageResource) {
        self.init(named: resource.rawValue)!
    }
}
