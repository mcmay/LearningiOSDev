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
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
            }
        }
        
    }


}

