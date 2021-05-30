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
    @IBOutlet var photoTimestamp: UILabel!
    @IBOutlet var photoID: UILabel!
    
    var photoDescription: String?
    override var accessibilityLabel: String? {
        get {
            return photoDescription
        }
        set {
            // Ignore attempts to set
        }
    }
    override var isAccessibilityElement: Bool {
        get {
            return true
        }
        set {
            // Ignore attempts to set
        }
    }
    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return super.accessibilityTraits.union([.image, .button])
        }
        set {
            // Ignore attempts to set
        }
    }
    func update (displaying image: UIImage?) -> Void {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
}
