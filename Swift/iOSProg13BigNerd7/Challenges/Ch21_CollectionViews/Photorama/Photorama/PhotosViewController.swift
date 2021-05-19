//
//  ViewController.swift
//  Photorama
//
//  Created by Chao Mei on 24/4/21.
//
// “Silver Challenge: Updated Item Sizes
//Have the collection view always display four items per row, taking up as much of the screen width as possible. This should work in both portrait and landscape orientations. Consider making adjustments to the flow layout in the viewDidLayoutSubviews() method.”

//Excerpt From: Aaron Hillegass. “iOS Programming: The Big Nerd Ranch Guide, 7th Edition.” Apple Books.

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate
                            {
    @IBOutlet var collectionView: UICollectionView!
    
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    private let itemsPerRow: CGFloat = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // store.fetchInterestingPhotos()
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        store.fetchInterestingPhotos {
            (photoResult) in
            
            switch photoResult {
            case let .success(photos):
                print("Successfully found \(photos.count) photos")
                 /*let randomPhoto = photos[Int.random(in: (0..<photos.count))]
                 self.updateImageView(for: randomPhoto)*/
                self.photoDataSource.photos = photos
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
                self.photoDataSource.photos.removeAll()
            }
            /*if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }*/
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    func collectionView (_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        
        // Download the image data, which could take some time
        store.fetchImage(for: photo) {
            (result) -> Void in
            // The index path for the photo imght have changed between the
            // time the request started and finished, so find the most
            // recent index path
            guard let photoIndex = self.photoDataSource.photos.firstIndex(of: photo), case let .success(image) = result else {
                return
            }
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            
            // When the request finishes, find the current cell for this photo
            if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? photoCollectionViewCell {
                cell.update(displaying: image)
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
    override func viewDidLayoutSubviews() {
        // Need to first construct a UICollectionViewFlowLayout and then this flow object
        // can be configured and assigned to the collectionViewLayout property of the collectionView
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 1
        let lineSpacing = flowLayout.minimumLineSpacing
        flowLayout.minimumInteritemSpacing = lineSpacing
        let interItemSpace = flowLayout.minimumInteritemSpacing
        let frameWidth = collectionView.frame.width
        let availableWidth = frameWidth - interItemSpace * (itemsPerRow - 1)
        let widthPerItem = availableWidth / itemsPerRow
        flowLayout.itemSize = CGSize(width: widthPerItem, height: widthPerItem)
        collectionView.collectionViewLayout = flowLayout
    }
}

