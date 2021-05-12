//
//  ViewController.swift
//  Photorama
//
//  Created by Chao Mei on 24/4/21.
//

import UIKit

class InterestingPhotosViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        // store.fetchInterestingPhotos()
        store.fetchPhotos (for: PhotoType.interestingPhotos) {
            (photoResult) in
            
            // photos and error are contained in photoResult
            switch photoResult {
            case let .success(photos):
                if photos.count == 0 {
                    //let scale2x = UITraitCollection(displayScale: 2.0)
                    let defaultImage = UIImage(named: "Octonauts.jpg")
                    if let defaultPhoto = defaultImage {
                        //defaultPhoto.imageAsset?.register(UIImage(named: "Octonauts@2x.jpg")!, with: scale2x)
                        self.updateImageView(for: defaultPhoto)
                    }
                } else {
                    print("Successfully found \(photos.count) interesting photos")
                    let randomPhoto = photos[Int.random(in: (0..<photos.count))]
                    self.updateImageView(for: randomPhoto)
                }
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
    func updateImageView (for image: UIImage) {
        self.imageView.image = image
    }
}

