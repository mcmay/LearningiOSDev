//
//  ImageStore.swift
//  LootLogger
//
//  Created by Chao Mei on 13/3/21.
//

import UIKit

class ImageStore {
    let cache = NSCache<NSString, UIImage> ()
    
    func setImage(_ image: UIImage, forKey key: String) -> Void {
        cache.setObject(image, forKey: key as NSString)
    }
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    func deleteImage(forKey key: String) -> Void {
        cache.removeObject(forKey: key as NSString)
    }
}
