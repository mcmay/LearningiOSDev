//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by Chao Mei on 13/5/21.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var photoTimestamp: UILabel!
    @IBOutlet var photoID: UILabel!
    
    
    func update (displaying image: UIImage?) -> Void {
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor.systemGray.cgColor
    
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = UIImage(named: "captain")
        }
    }
}
