// 
//  Copyright © 2020 Big Nerd Ranch
//

import UIKit

class ConversionViewController: UIViewController {
    
    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = UIColor.systemBackground
        
        let fDegree = UILabel()
        let fUnit = UILabel()
        let isReally = UILabel()
        let cDegree = UILabel()
        let cUnit = UILabel()
        let labels: [UILabel] = [fDegree, fUnit, isReally, cDegree, cUnit]
        for label in labels {
            self.view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.backgroundColor = self.view.backgroundColor
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        }
        fDegree.text = "212"
        fDegree.textColor = .systemOrange
        fDegree.font = UIFont.systemFont(ofSize: 70.0)
        fDegree.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8.0).isActive = true
        
        fUnit.text = "degrees Fahrenheit"
        fUnit.textColor = .systemOrange
        fUnit.font = UIFont.systemFont(ofSize: 35.0)
        fUnit.topAnchor.constraint(equalTo: fDegree.bottomAnchor, constant: 8.0).isActive = true
        
        isReally.text = "is really"
        isReally.font = UIFont.systemFont(ofSize: 35.0)
        isReally.topAnchor.constraint(equalTo: fUnit.bottomAnchor, constant: 8.0).isActive = true
        
        cDegree.text = "100"
        cDegree.textColor = .systemOrange
        cDegree.font = UIFont.systemFont(ofSize: 70.0)
        cDegree.topAnchor.constraint(equalTo: isReally.bottomAnchor, constant: 8.0).isActive = true
        
        cUnit.text = "degrees Celsius"
        cUnit.textColor = .systemOrange
        cUnit.font = UIFont.systemFont(ofSize: 35.0)
        cUnit.topAnchor.constraint(equalTo: cDegree.bottomAnchor, constant: 8.0).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ConversionViewController loaded its view.")
    }
}

