//
//  RecentPhotosViewController.swift
//  Photorama
//
//  Created by Chao Mei on 9/5/21.
//

import UIKit

class RecentPhotosViewController: UIViewController {
    @IBOutlet private var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // store.fetchInterestingPhotos()
        store.fetchPhotos (for: PhotoType.recentPhotos) {
            (photoResult) in
            
            // photos and error are contained in photoResult
            switch photoResult {
            case let .success(photos):
                print("Successfully found \(photos.count) photos")
                 let randomPhoto = photos[Int.random(in: (0..<photos.count))]
                 self.updateImageView(for: randomPhoto)
            
            case let .failure(error):
                print("Error fetching recent photos: \(error)")
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
