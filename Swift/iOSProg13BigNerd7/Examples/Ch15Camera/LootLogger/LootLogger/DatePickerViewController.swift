//
//  DatePickerViewController.swift
//  LootLogger
//
//  Created by Chao Mei on 6/3/21.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // When the view of DatePickerViewController is popped off the navigation controller's
        // view controller stack, the next view (here the detail view) is pushed on to the stack instead.
        let detailViewController = navigationController?.topViewController as! DetailViewController
        detailViewController.newDate = datePicker.date
    }
}
