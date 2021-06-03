//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Chao Mei on 15/5/21.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var viewCount: UILabel!
    
    @IBAction func favorThisPhoto(_ sender: UIBarButtonItem) {
        if photo.favorite == false {
            photo.favorite = true
            saveChanges()
        }
    }
    @IBAction func removeFromFavorite(_ sender: UIBarButtonItem) {
        if photo.favorite == true {
            photo.favorite = false
            saveChanges()
        }
    }
    @IBAction func doNotShowAgain(_ sender: UIBarButtonItem) {
        photo.hide = true
        store.imageStore.deleteImage(forKey: photo.photoID!)
        saveChanges()
    }
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    var store: PhotoStore!
    func saveChanges () {
        do {
            try store.persistentContainer.viewContext.save()
        } catch {
            print("Cannot save photo store context.")
        }
    }
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
            if let url = self.photo.urlZ {
                print("\(url)")
            }
            self.photo.viewCount += 1
            self.saveChanges()
            self.viewCount.text = "Viewed: \(self.photo.viewCount) times"
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
