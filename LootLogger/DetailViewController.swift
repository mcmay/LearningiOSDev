//
//  DetailViewController.swift
//  LootLogger
//
//  Created by Chao Mei on 11/2/21.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate,
                            UINavigationControllerDelegate,
                            UIImagePickerControllerDelegate {
    // It is through the following outlets that the Detail View Controller
    // in the Main.storyboard grabs possession of this
    // DetailViewController object
    @IBOutlet var nameField: UITextField!
    @IBOutlet var serialNumberField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter
    }()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        return formatter
    }()
    var item: Item! { // Property observer
        didSet {
            navigationItem.title = item.name
        }
    }
    var imageStore: ImageStore!
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    @IBAction func choosePhotoSource(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.modalPresentationStyle = .popover
        // show pointer of altercontroller's view
        alertController.popoverPresentationController?.barButtonItem = sender
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let camerAction = UIAlertAction(title: "Camera", style: .default) {
                _ in
                let imagePicker = self.imagePicker(for: .camera)
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(camerAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) {
            _ in
            let imagePicker = self.imagePicker(for: .photoLibrary)
            imagePicker.modalPresentationStyle = .popover
            imagePicker.popoverPresentationController?.barButtonItem = sender
            self.present(imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(photoLibraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteImage(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.modalPresentationStyle = .popover
        // show pointer of altercontroller's view
        alertController.popoverPresentationController?.barButtonItem = sender
        
        let deleteImageAction = UIAlertAction(title: "Delete image", style: .default) {
            _ in
            
            self.imageView.image = nil
            self.imageStore.deleteImage(forKey: self.item.itemKey)
        }
        alertController.addAction(deleteImageAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    func imagePicker (for sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        return imagePicker
    }
    /*The delegate receives notifications when the user picks an image or movie, or exits the picker interface.
     The delegate also decides when to dismiss the picker interface, so you must provide a delegate to use a picker.
     If this property is nil, the picker is dismissed immediately if you try to show it.
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Get picked image from info dictionary
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        // Store the image in the ImageStore for the item's key
        imageStore.setImage(image, forKey: item.itemKey)
        
        // Put that image on the screen in the image view
        imageView.image = image
        
        // Take image picker off the screen - you must call this dismiss method
        dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        //valueField.text = "\(item.valueInDollars)"
        //dateLabel.text = "\(item.dateCreated)"
        valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
        
        // Get the item key
        let key = item.itemKey
        
        // If there is an associated image with the item, display it on the image view
        let imageToDisplay = imageStore.image(forKey: key)
        imageView.image = imageToDisplay
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clear first responder
        view.endEditing(true)
        
        // "Save" changes to item
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        if let valueText = valueField.text,
           let value = numberFormatter.number(from: valueText) {
            item.valueInDollars = value.intValue
        } else {
            item.valueInDollars = 0
        }
    }
}
