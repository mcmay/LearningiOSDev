//
//  PhotoDataSource.swift
//  Photorama
//
//  Created by Chao Mei on 13/5/21.
//

import UIKit
/*
 To conform to the UICollectionViewDataSource protocol, a type also needs to conform to the
 NSObjectProtocol. The easiest and most common way to conform to this protocol is to subclass from
 NSObject.
 */
class PhotoDataSource: NSObject, UICollectionViewDataSource {
    var photos = [Photo]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "PhotoCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoCollectionViewCell

        cell.update(displaying: nil) // Preparing cell for showing photo
        
        return cell
    }
}
