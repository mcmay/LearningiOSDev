//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by Chao Mei on 13/5/21.
//

import UIKit

class photoCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    func update (displaying image: UIImage?) -> Void {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = UIImage(named: "Captain")
        }
    }
}
