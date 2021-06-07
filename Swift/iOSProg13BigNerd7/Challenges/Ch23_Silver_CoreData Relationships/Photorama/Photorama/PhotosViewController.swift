//
//  ViewController.swift
//  Photorama
//
//  Created by Chao Mei on 24/4/21.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBAction func goToTop(_ sender: UIBarButtonItem) {
        let firstItemIndex = IndexPath(item: 0, section: 0)
        self.collectionView.scrollToItem(at: firstItemIndex, at: .bottom, animated: true)
    }
    
    @IBAction func jumpToBottom(_ sender: UIBarButtonItem) {
        let item = photoDataSource.collectionView(self.collectionView, numberOfItemsInSection:  0) - 1
        let lastItemIndex = IndexPath(item: item, section: 0)
        self.collectionView.scrollToItem(at: lastItemIndex, at: .top, animated: true)
    }
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    var cell: PhotoCollectionViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // store.fetchInterestingPhotos()
        self.collectionView.layer.borderWidth = 4
        let teal = UIColor.systemTeal
        let light = UITraitCollection(userInterfaceStyle: .light)
        //let dark = UITraitCollection(userInterfaceStyle: .dark)
        let tealLight = teal.resolvedColor(with: light)
        //let tealdark = teal.resolvedColor(with: dark)
        self.collectionView.layer.borderColor = tealLight.cgColor
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        store.fetchRecentPhotos {
            (photoResult) in
            /*switch photoResult {
            case let .success(photos):
                print("Successfully found \(photos.count) photos")
                 /*let randomPhoto = photos[Int.random(in: (0..<photos.count))]
                 self.updateImageView(for: randomPhoto)*/
                self.photoDataSource.photos = photos
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
            if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }*/
            self.updateDataSource()
        }
    }
    private func updateDataSource () {
        store.fetchAllPhotosFromDisk {
            (photoResult) in
            
            switch photoResult {
            case let .success(photos):
                self.photoDataSource.photos = photos
            case .failure:
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
    // delegate method for UICollectionViewDelegate
    func collectionView (_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        
        // Download the image data, which could take some time
        store.fetchImage(for: photo) {
            (result) -> Void in // This result should be a UIImage
            // The index path for the photo imght have changed between the
            // time the request started and finished, so find the most
            // recent index path
            guard let photoIndex = self.photoDataSource.photos.firstIndex(of: photo), case let .success(image) = result else { return }
            
            if photo.hide {
                return
            }
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            // When the request finishes, find the current cell for this photo
            if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                cell.photoTimestamp.text = photo.datetaken
                cell.photoID.text = photo.photoID
                cell.update(displaying: image)
                self.cell = cell
            }
            
        }
    }
    /*func updateImageView (for photo: Photo) -> Void {
        store.fetchImage(for: photo) {
            (imageResult) in
            
            switch imageResult {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error downloading image: \(error)")
            }
        }
    }*/
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPhoto":
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                let photo = photoDataSource.photos[selectedIndexPath.row]
                let destinationVC = segue.destination as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.store = self.store
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
}

