//
//  ViewController.swift
//  Photorama
//
//  Created by Chao Mei on 24/4/21.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // store.fetchInterestingPhotos()
        store.fetchInterestingPhotos {
            (photoResult) in
            
            switch photoResult {
            case let .success(photos):
                print("Successfully found \(photos.count) photos")
                 let randomPhoto = photos[Int.random(in: (0..<photos.count))]
                 self.updateImageView(for: randomPhoto)
            
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
            }
        }
        
    }

    func updateImageView (for photo: Photo) -> Void {
        store.fetchImage(for: photo) {
            (imageResult) in
            
            switch imageResult {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error downloading image: \(error)")
            }
        }
    }
}

