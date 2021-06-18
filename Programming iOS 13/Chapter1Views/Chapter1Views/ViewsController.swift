//
//  ViewController.swift
//  Chapter1Views
//
//  Created by Chao Mei on 8/6/21.
//

import UIKit

class ViewsController: UIViewController {
    let myView = MyView()
    //var store: UIView!
    @IBAction func showStackView(_ sender: UIButton) {
        //layoutViews()
        stackViews()
    }
    
    override func loadView() {
        super.loadView()
        //store = self.view
        self.view = myView
    }
    /*override func viewDidLoad() {
        super.viewDidLoad()
        self.view = store
    }*/
    func layoutViews () { // solution from Stackoverflow
        let v1 = UIView(), v2 = UIView(), v3 = UIView(), v4 = UIView()
        let views = [v1, v2, v3, v4]
        let colors: [UIColor] = [.red, .blue, .yellow, .green]
        var guides = [UILayoutGuide]()
        
        for (v, c) in zip(views, colors) {
            v.backgroundColor = c
        }
        for v in views {
            v.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(v)
        }
        
        // one fewer guides than views
        for _ in views.dropLast() {
            let g = UILayoutGuide()
            self.view.addLayoutGuide(g)
            guides.append(g)
        }
        
        // respect safe-area
        let safeG = view.safeAreaLayoutGuide
        
        // guides leading and width are arbitrary
        let anc = safeG.leadingAnchor
        for g in guides {
            g.leadingAnchor.constraint(equalTo: anc).isActive = true
            g.widthAnchor.constraint(equalToConstant: 10).isActive = true
        }
        
        // all 4 views constrain leading and trailing
        for v in views {
            v.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 20.0).isActive = true
            v.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -20.0).isActive = true
        }
        
        // references to first and last views
        guard let firstView = views.first,
              let lastView = views.last
        else {
            fatalError("Incorrect setup!")
        }
        // Evenness in distribution of the four views in the superview
        // is achieved through pinning the first and last views to the
        // top and bottom of the superview respectively and through
        // layout guides (spacer views in disguise?) inserted between
        // the views
        // first view, constrain to top
        firstView.topAnchor.constraint(equalTo: safeG.topAnchor).isActive = true
        
        // last view, constrain to bottom
        lastView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor).isActive = true
        
        // guides top to previous view
        for (v,g) in zip(views.dropLast(), guides) {
            g.topAnchor.constraint(equalTo: v.bottomAnchor).isActive = true
        }
        
        // guides bottom to next view
        for (v,g) in zip(views.dropFirst(), guides) {
            g.bottomAnchor.constraint(equalTo: v.topAnchor).isActive = true
        }
        
        // first view, constrain height to 30
        views[0].heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        // remaining views heightAnchor equal to first view heightAnchor
        for v in views.dropFirst() {
            v.heightAnchor.constraint(equalTo: firstView.heightAnchor).isActive = true
        }
        
        let h = guides[0].heightAnchor
        for g in guides.dropFirst() {
            g.heightAnchor.constraint(equalTo: h).isActive = true
        }
    }
    func stackViews () { // solution from Stackoverflow
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.spacing = 50
        
        let colors: [UIColor] = [.red, .blue, .yellow, .green]
        
        colors.forEach { c in
            let v = UIView()
            v.backgroundColor = c
            v.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
            stackView.addArrangedSubview(v)
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // respect safe-area
        let safeG = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeG.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 20.0),
            stackView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -20.0),
            stackView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor),
        ])
    }
}
class MyView: UIView {
    var image = UIImage(named: "Harbour Bridge")
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.setNeedsLayout() // causes draw(_:) to be called
    }
    override func draw (_ rect: CGRect) {
        if var im = self.image {
            if let asset = self.image?.imageAsset {
                im = asset.image(with: self.traitCollection)
            }
            im.draw(at: .zero)
        }
    }
}
/*@IBDesignable class MyView: UIView {
    func configure () {
        self.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
        let v2 = UIView()
        v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
        let v3 = UIView()
        v3.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        v2.translatesAutoresizingMaskIntoConstraints = false
        v3.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(v2); self.addSubview(v3)
        NSLayoutConstraint.activate([
            v2.leftAnchor.constraint(equalTo: self.leftAnchor),
            v2.rightAnchor.constraint(equalTo: self.rightAnchor),
            v2.topAnchor.constraint(equalTo: self.topAnchor),
            v2.heightAnchor.constraint(equalToConstant: 20),
            v3.widthAnchor.constraint(equalToConstant: 20),
            v3.heightAnchor.constraint(equalTo: v3.widthAnchor),
            v3.rightAnchor.constraint(equalTo: self.rightAnchor),
            v3.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        self.configure()
    }
}*/
extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGRect {
    var center : CGPoint {
        return CGPoint(self.midX, self.midY)
    }
}
extension CGRect {
    func centeredRectOfSize(_ sz:CGSize) -> CGRect {
        let c = self.center
        let x = c.x - sz.width/2.0
        let y = c.y - sz.height/2.0
        
        return CGRect(x, y, sz.width, sz.height)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}

extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}

/* my now solutions that do not really achieve the desired effects, unsatisfactory
 func stackViews () {
    let v1 = UIView()
    let v2 = UIView()
    let v3 = UIView()
    let v4 = UIView()
    let colors: [UIColor] = [.red, .blue, .yellow, .green]
    let views = [v1, v2, v3, v4]
    
    for (v, c) in zip(views, colors) {
        v.backgroundColor = c
        v.translatesAutoresizingMaskIntoConstraints = false
        v.widthAnchor.constraint(equalToConstant: 200).isActive = true
        v.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    let stackedViews = UIStackView(arrangedSubviews: views)
    stackedViews.axis = .vertical
    stackedViews.alignment = .fill
    stackedViews.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(stackedViews)
    stackedViews.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
    stackedViews.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor).isActive = true
}
 func layoutViews () {
    let v1 = UIView()
    let v2 = UIView()
    let v3 = UIView()
    let v4 = UIView()
    let views = [v1, v2, v3, v4]
    let colors: [UIColor] = [.red, .blue, .yellow, .green]
    var guides = [UILayoutGuide]()
    for v in views {
        self.view.addSubview(v)
    }
    for (v, c) in zip(views, colors) {
        v.backgroundColor = c
        v.widthAnchor.constraint(equalToConstant: 200).isActive = true
        v.heightAnchor.constraint(equalToConstant: 30).isActive = true
        v.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor).isActive = true
        v.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // needs to pin the first view in place so that the following view will follow
    v1.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
    
    // one fewer guides than views
    for _ in views.dropLast() {
       let g = UILayoutGuide()
        self.view.addLayoutGuide(g)
        guides.append(g)
    }
    
    // guides leading and width are arbitrary
    let anc = self.view.leadingAnchor
    for g in guides {
        g.leadingAnchor.constraint(equalTo: anc).isActive = true
        g.widthAnchor.constraint(equalToConstant: 10).isActive = true
    }
   
    // guides top to previous view
    for (v,g) in zip(views.dropLast(), guides) {
        v.bottomAnchor.constraint(equalTo: g.topAnchor).isActive = true
    }
    // guides bottom to next view
    for (v,g) in zip(views.dropFirst(), guides) {
        v.topAnchor.constraint(equalTo: g.bottomAnchor).isActive = true
    }
    let h = guides[0].heightAnchor
    for g in guides.dropFirst() {
        g.heightAnchor.constraint(equalTo: h).isActive = true
        
    }
}*/

/*let view = UIView()
view.backgroundColor = .white
self.view = view
let rect1 = CGRect(113, 111, 132, 194 )
let v1 = UIView(frame:rect1)
v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
let shift = CGAffineTransform(translationX: -rect1.midX, y: -rect1.midY)
let rotate = v1.transform
let transform = shift.concatenating(rotate).concatenating(shift.inverted())
let rect2 = rect1.applying(transform)
let v2 = UIView(frame:rect2)
v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
self.view.addSubview(v1)
v1.addSubview(v2)
print(rect1)
print(rect2)
let view = UIView()
view.backgroundColor = .white
let helloLabel = UILabel(frame: CGRect(150, 150, 100, 50))
helloLabel.text = "Hello world!"
helloLabel.transform3D = CATransform3DMakeRotation(.pi, 0, 1, 0)
self.view = view
view.addSubview(helloLabel)*/

/*
 var v2: UIView!
 var constraintsWith = [NSLayoutConstraint]()
 var constraintsWithout = [NSLayoutConstraint]()
 override viewDidLoad {
     let v1 = UIView();
     v1.backgroundColor = .red
     v1.translatesAutoresizingMaskIntoConstraints = false
     let v2 = UIView()
     v2.backgroundColor = .yellow
     v2.translatesAutoresizingMaskIntoConstraints = false
     let v3 = UIView()
     v3.backgroundColor = .blue
     v3.translatesAutoresizingMaskIntoConstraints = false
     self.view.addSubview(v1)
     self.view.addSubview(v2)
     self.view.addSubview(v3)
     self.v2 = v2 // retain
     
     let c1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[v(100)]", metrics: nil, views: ["v":v1])
     let c2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[v(100)]", metrics: nil, views: ["v":v2])
     let c3 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[v(100)]", metrics: nil, views: ["v":v3])
     let c4 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(100)-[v(20)]", metrics: nil, views: ["v":v1])
     let c5with = NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-(20)-[v2(20)]-20-[v3(20)]", metrics: nil, views: ["v1":v1, "v2":v2, "v3":v3])
     let c5without = NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-(20)-[v3(20)]", metrics: nil, views: ["v1":v1, "v3":v3])
     
     // apply common constraints
     NSLayoutConstraint.activate([c1, c3, c4].flatMap{$0})
     self.constraintsWith.append(contentsOf:c2)
     self.constraintsWith.append(contentsOf:c5with) // first set of constraints (for when v2 is present)
     self.constraintsWithout.append(contentsOf: c5without) // second set of constraints (for when v2 is absent)
     
     NSLayoutConstraint.activate(self.constraintsWith) // apply first set
     doSwap()
 }
 
 */
/*
 func doSwap () {
     if self.v2.superview != nil {
         self.v2.removeFromSuperview()
         NSLayoutConstraint.deactivate(self.constraintsWith)
         NSLayoutConstraint.activate(self.constraintsWithout)
     } else {
         self.view.addSubview(v2)
         NSLayoutConstraint.deactivate(self.constraintsWithout)
         NSLayoutConstraint.activate(self.constraintsWith)
     }
 }
 */
