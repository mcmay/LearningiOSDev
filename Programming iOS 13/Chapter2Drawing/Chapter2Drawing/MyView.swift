//
//  MyView.swift
//  Chapter2Drawing
//
//  Created by Chao Mei on 16/6/21.
//

import UIKit

class MyView: UIView {
    /*override func draw(_ rect: CGRect) {
        let p = UIBezierPath(ovalIn: CGRect(0, 0, 100, 100))
        UIColor.blue.setFill()
        p.fill()
    }*/
    
    override func draw (_ rect: CGRect) {
        if let con = UIGraphicsGetCurrentContext() {
            con.addEllipse(in: CGRect(0, 0, 100, 100))
            con.setFillColor(UIColor.blue.cgColor)
            con.fillPath()
        } else {
            print("Error happened")
        }
    }
}
