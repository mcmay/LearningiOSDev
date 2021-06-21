//
//  ViewController.swift
//  Chapter2Drawing
//
//  Created by Chao Mei on 13/6/21.
//

import UIKit
import CoreImage.CIFilterBuiltins

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //catlogAndTraitCollection()
        //presentImage()
        //tinting()
        //drawing ()
        //drawingUIImage()
        //UIImageDrawing()
        //CGImageDrawing()
        //drawingCIImageGradient()
        //drawCIImageWithGradientUsingCIFiler()
        //drawBlurAndVibrancyImage()
        drawArrow()
    }
    func drawArrow () {
        let x = view.center.x
        let y = view.center.y
        let width = CGFloat(200), height = CGFloat(200)
        let rect = CGRect(x - width/2.0, y - height/2.0, width, height)
        let myView = MyView(frame: rect)
        self.view.addSubview(myView)
    }
    func drawBlurAndVibrancyImage () {
        showPic()
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial) // using .dark to visualize
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurView)
        let vibEffect = UIVibrancyEffect(blurEffect: blurEffect, style: .label)
        let vibView = UIVisualEffectView(effect: vibEffect)
        let lab = UILabel()
        lab.text = "Hello, world!"
        lab.sizeToFit()
        vibView.bounds = lab.bounds
        vibView.center = self.view.bounds.center
        vibView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin,
                                    .flexibleLeftMargin, .flexibleRightMargin]
        blurView.contentView.addSubview(vibView)
        vibView.contentView.addSubview(lab)
    }
    func drawingCIImageGradient () {
        let moi = UIImage(named: "pix/Mars")!
        let moici = CIImage(image: moi)!
        let moiextent = moici.extent
        let smaller = min(moiextent.width, moiextent.height)
        let larger = max(moiextent.width, moiextent.height)
        // first filter
        let grad = CIFilter.radialGradient()
        grad.center = moiextent.center
        grad.radius0 = Float(smaller)/2.0 * 0.7
        grad.radius1 = Float(larger)/2.0
        let gradimage = grad.outputImage!
        // second filter
        let blend = CIFilter.blendWithMask()
        blend.inputImage = moici
        blend.maskImage = gradimage
        let blendimage = blend.outputImage!
        /*let context = CIContext()
        let moicg = context.createCGImage(blendimage, from: moiextent)!
        let image = UIImage(cgImage: moicg)*/
        let r = UIGraphicsImageRenderer(size: moiextent.size)
        let image = r.image{ _ in
            UIImage(ciImage: blendimage).draw(in: moiextent)
        }
        setImageView(image)
    }
    func drawCIImageWithGradientUsingCIFiler () {
        let vig = MyVignetteFilter()
        let moici = CIImage(image: UIImage(named: "pix/Mars")!)!
        vig.setValuesForKeys([
            "inputImage":moici,
            "inputPercentage":0.7
        ])
        let outim = vig.outputImage!
        let context = CIContext()
        let outimage = context.createCGImage(outim, from: outim.extent)!
        setImageView(UIImage(cgImage:outimage))
    }
    func drawing () {
        let myView = UIView()
        myView.frame = CGRect(self.view.center.x - 50, self.view.center.y - 50, 100, 100)
        self.view.addSubview(myView)
        myView.draw(myView.frame)
    }
    func drawingUIImage () {
        let r = UIGraphicsImageRenderer(size: CGSize(100, 100))
        let im = r.image { _ in
            //let p = UIBezierPath(ovalIn: CGRect(0, 0, 100, 100))
            //UIColor.blue.setFill()
            //p.fill()
            let con = UIGraphicsGetCurrentContext()!
            con.addEllipse(in: CGRect(0, 0, 100, 100))
            con.setFillColor(UIColor.blue.cgColor)
            con.fillPath()
        }
        setImageView(im)
    }
    func UIImageDrawing () {
        let symbol = UIImage(systemName: "rhombus")!
        let sz = CGSize(200, 200)
        let r = UIGraphicsImageRenderer(size: sz)
        let im = r.image { _ in
            symbol.withTintColor(.purple).draw(in: CGRect(origin: .zero, size: sz))
        }
        setImageView(im)
    }
    func CGImageDrawing () {
        let mars = UIImage(named: "pix/Mars")!
        // extract each half as CGImage
        let marsCG = mars.cgImage!
        let sz = mars.size
        let szCG = CGSize(CGFloat(marsCG.width), CGFloat(marsCG.height))
        let marsLeft = marsCG.cropping(to: CGRect(0, 0, szCG.width/2.0, szCG.height))
        let marsRight = marsCG.cropping(to: CGRect(szCG.width/2.0, 0, szCG.width/2.0, szCG.height))
        let r = UIGraphicsImageRenderer(size: CGSize(sz.width*1.5, sz.height), format: mars.imageRendererFormat)
        let im = r.image { _ in
            UIImage(cgImage: marsLeft!, scale: mars.scale, orientation: mars.imageOrientation).draw(at: CGPoint(0, 0))
            UIImage(cgImage: marsRight!, scale: mars.scale, orientation: mars.imageOrientation).draw(at: CGPoint(sz.width, 0))
        }
        setImageView(im)
    }
    func tinting () {
        //let im = UIImage(systemName: "circle.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        let im = UIImage(named: "pix/Mars")!
        im.withHorizontallyFlippedOrientation()
        setImageView(im)
    }
    func setImageView (_ im: UIImage) {
        let iv = UIImageView(image: im)
        self.view.addSubview(iv)
        centerImageView(iv)
    }
    func presentImage () {
        let mars = UIImage(named: "pix/Mars")
        //let marsTiled = mars?.resizableImage(withCapInsets: .zero, resizingMode: .tile)
        // uncomment the statement below to see a build error: trap 6 -- reported to swift.org
        //guard let mars = mars else { return }
        if let mars = mars {
            /*let insets = UIEdgeInsets(top: mars.size.height / 4.0,
                                      left: mars.size.width / 4.0,
                                      bottom: mars.size.height / 4.0,
                                      right: mars.size.width / 4.0)*/
            let insets = UIEdgeInsets(top: mars.size.height / 2.0 - 1,
                                      left: mars.size.width / 2.0 - 1,
                                      bottom: mars.size.height / 2.0 - 1,
                                      right: mars.size.width / 2.0 - 1)
            //let marsTiled = mars.resizableImage(withCapInsets: insets, resizingMode: .tile)
            let marsStretched = mars.resizableImage(withCapInsets: insets, resizingMode: .stretch)
            let iv = UIImageView()
            
            iv.heightAnchor.constraint(equalToConstant: 200).isActive = true
            iv.widthAnchor.constraint(equalToConstant: 450).isActive = true
            iv.contentMode = .scaleToFill
            iv.clipsToBounds = true
            iv.frame = iv.frame.integral
            //iv.image = marsTiled
            iv.image = marsStretched
            
            self.view.addSubview(iv)
            centerImageView(iv)
        }
    }
    func catlogAndTraitCollection () {
        let tcreg = UITraitCollection(verticalSizeClass: .regular)
        let tccom = UITraitCollection(verticalSizeClass: .compact)
        let moods = UIImageAsset()
        let frowney = UIImage(named: "pix/frowney")!
        let smiley = UIImage(named: "pix/smiley")!
        moods.register(frowney, with: tcreg)
        moods.register(smiley, with: tccom)
        let imageView = UIImageView(image: frowney)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0))
    }
    func centerImageView (_ imageView: UIImageView) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: imageView.superview!.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: imageView.superview!.centerYAnchor).isActive = true
    }
    func showPic () {
        guard let image = UIImage(named: "pix/Harbour Bridge") else { return }
        setImageView(image)
    }
}


