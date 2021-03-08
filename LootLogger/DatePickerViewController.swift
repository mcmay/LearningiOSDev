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
        
        let detailViewController = navigationController?.topViewController as! DetailViewController
        detailViewController.newDate = datePicker.date
    }
}
