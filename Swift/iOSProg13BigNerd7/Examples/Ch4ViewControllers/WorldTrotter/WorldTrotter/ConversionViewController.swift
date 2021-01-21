// 
//  Copyright © 2020 Big Nerd Ranch
//

import UIKit

class ConversionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ConversionViewController loaded its view.")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let r = CGFloat(integerLiteral: Int.random(in: 0...1))
        let g = CGFloat(integerLiteral: Int.random(in: 0...1))
        let b = CGFloat(integerLiteral: Int.random(in: 0...1))

        self.view.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}

