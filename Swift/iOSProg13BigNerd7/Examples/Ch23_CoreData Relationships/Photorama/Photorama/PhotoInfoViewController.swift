//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Chao Mei on 15/5/21.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.fetchImage (for: photo) {
            (result) -> Void in
        
        switch result {
        case let .success(image):
        self.imageView.image = image
        if let title = self.photo.title, title.count > 0 {
               print("Photo title: \(title)")
        }
        case let .failure(error):
            print("Error fetching image for photo: \(error)")
            }
        }
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showTags":
            let navController = segue.destination as! UINavigationController
            let tagController = navController.topViewController as! TagsViewController
            
            tagController.store = self.store
            tagController.photo = self.photo
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
}
