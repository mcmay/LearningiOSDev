//
//  FavoritePhotosViewController.swift
//  Photorama
//
//  Created by Chao Mei on 1/6/21.
//

import UIKit

class FavoritePhotosViewController: UIViewController, UICollectionViewDelegate {
    @IBOutlet var collectionView: UICollectionView!
    
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    var cell: PhotoCollectionViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.layer.borderWidth = 4
        let teal = UIColor.systemTeal
        //let light = UITraitCollection(userInterfaceStyle: .light)
        let dark = UITraitCollection(userInterfaceStyle: .dark)
        //let tealLight = teal.resolvedColor(with: light)
        let tealDark = teal.resolvedColor(with: dark)
        self.collectionView.layer.borderColor = tealDark.cgColor
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        self.updateDataSource()
    }
    private func updateDataSource () {
        store.fetchFavoritePhotosFromDisk {
            (photoResult) -> Void in
            
            switch photoResult {
            case let .success(photos):
                self.photoDataSource.photos = photos
            case let .failure(error):
                print("Error fetching favorite photos: \(error)")
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
