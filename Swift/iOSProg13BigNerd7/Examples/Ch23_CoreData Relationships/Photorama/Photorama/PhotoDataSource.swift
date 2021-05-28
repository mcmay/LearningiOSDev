//
//  PhotoDataSource.swift
//  Photorama
//
//  Created by Chao Mei on 13/5/21.
//

import UIKit

class PhotoDataSource: NSObject, UICollectionViewDataSource {
    var photos = [Photo]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("photos.cout: \(photos.count)")
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "PhotoCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! photoCollectionViewCell
        cell.update(displaying: nil)
        
        return cell
    }
    
    
}
