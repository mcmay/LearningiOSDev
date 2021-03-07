//
//  DatePickerViewController.swift
//  LootLogger
//
//  Created by Chao Mei on 6/3/21.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    @IBOutlet var datePicker: UIDatePicker!
    
    var newDate: Date!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        newDate = datePicker.date
        print(newDate!)
    }
}
