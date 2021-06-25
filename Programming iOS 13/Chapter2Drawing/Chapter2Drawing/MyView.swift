//
//  MyView.swift
//  Chapter2Drawing
//
//  Created by Chao Mei on 16/6/21.
//

import UIKit

import UIKit

class MyView: UIView {
    
    override init(frame: CGRect) {
            super.init(frame:frame)
            self.isOpaque = false
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    let which = 7
    
    override func draw (_ rect: CGRect) {
        
        switch which {
        case 1:
            let p = UIBezierPath(ovalIn: CGRect(0, 0, 100, 100))
            UIColor.blue.setFill()
            p.fill()
            
        case 2:
            if let con = UIGraphicsGetCurrentContext() {
                con.addEllipse(in: CGRect(0, 0, 100, 100))
                con.setFillColor(UIColor.blue.cgColor)
                con.fillPath()
            } else {
                print("Error happened")
            }
          
        case 3: // Using Core Graphics
            // obtain the current graphics context
            guard let con = UIGraphicsGetCurrentContext() else {return}
            // draw a black (by default) vertical line, the shaft of the arrow
            con.move(to: CGPoint(100, 100))
            con.addLine(to: CGPoint(100, 19))
            con.setLineWidth(20)
            con.strokePath()
            // draw a red triangle, the point of the arrow
            con.setFillColor(UIColor.red.cgColor)
            con.move(to: CGPoint(80, 25))
            con.addLine(to: CGPoint(100, 0))
            con.addLine(to: CGPoint(120, 25))
            con.fillPath()
            // snap a triangle out of the shaft by drawing in Clear blend mode
            con.move(to: CGPoint(90, 101))
            con.addLine(to: CGPoint(100, 90))
            con.addLine(to: CGPoint(110, 101))
            con.setBlendMode(.clear)
            con.fillPath()
            
        case 4:
            // Using UIKit's Bezier Path
            let p = UIBezierPath()
            // shaft
            p.move(to: CGPoint(100, 100))
            p.addLine(to: CGPoint(100, 19))
            p.lineWidth = 20
            p.stroke()
            // point
            UIColor.red.set()
            p.removeAllPoints()
            p.move(to:CGPoint(80, 25))
            p.addLine(to: CGPoint(100, 0))
            p.addLine(to: CGPoint(120, 25))
            p.fill()
            // snip
            p.removeAllPoints()
            p.move(to: CGPoint(90, 101))
            p.addLine(to: CGPoint(100, 90))
            p.addLine(to: CGPoint(110, 101))
            p.fill(with: .clear, alpha: 1.0)
        
        case 5:
            let con = drawShaft(at: CGPoint(90,100))
            con.strokePath()
            drawArrowPoint(con)
            
        case 6:
            let con = drawShaft(at: CGPoint(90,100))
            // draw the vertical line, add its shape to the clipping region
            con.replacePathWithStrokedPath()
            con.clip()
            drawGradient(con)
            // draw the red triangle, the point of the arrow
            drawArrowPoint(con)
        
        case 7:
            let v = UIView(frame: CGRect(0, 0, 2,2))
            v.backgroundColor = UIColor.red
            self.addSubview(v)
            let con = drawShaft(offsetX: 80.0)
            con.replacePathWithStrokedPath()
            con.clip()
            drawGradient(con, offsetX: 80.0)
            // create the pattern image tile
            let r = UIGraphicsImageRenderer(size: CGSize(4,4))
            let stripes = r.image { ctx in
                let imcon = ctx.cgContext
                imcon.setFillColor(UIColor.red.cgColor)
                imcon.fill(CGRect(0, 0, 4,4))
                imcon.setFillColor(UIColor.blue.cgColor)
                imcon.fill(CGRect(0, 0, 4, 2))
            }
            // paint the point of the arrow with it
        let stripsPattern = UIColor(patternImage: stripes)
        stripsPattern.setFill()
        let p = UIBezierPath()
        let offsetX = CGFloat(80.0)
        p.move(to: CGPoint(80 - offsetX, 25))
        p.addLine(to: CGPoint(100 - offsetX, 0))
        p.addLine(to: CGPoint(120 - offsetX, 25))
        p.fill()
        
        case 8:
            let con = drawShaft(offsetX: 80.0)
            con.replacePathWithStrokedPath()
            con.clip()
            drawGradient(con, offsetX: 80.0)
            drawPattern(con, offsetX: 80.0)
            
        default:
            print("Invalid choice.")
        }
    }
    func drawShaft (at origin: CGPoint = CGPoint(0, 0), offsetX: CGFloat = 0) -> CGContext {
        // obtain the current graphics context
        let con = UIGraphicsGetCurrentContext()!
        // punch traingular hole in the context clipping region
        //con.saveGState()
        //con.translateBy(x: 80, y: 0)
        con.move(to: origin)
        con.addLine(to: CGPoint(100 - offsetX, 90))
        con.addLine(to: CGPoint(110 - offsetX, 100))
        con.closePath()
        con.addRect(con.boundingBoxOfClipPath)
        con.clip(using: .evenOdd)
        // draw the vertical line
        con.move(to: CGPoint(100 - offsetX, 100))
        con.addLine(to: CGPoint(100 - offsetX, 19))
        con.setLineWidth(20)
        
        return con
    }
    func drawArrowPoint (_ context: CGContext) {
        // draw the red triangle, the point of the arrow
        context.setFillColor(UIColor.red.cgColor)
        context.move(to: CGPoint(80, 25))
        context.addLine(to: CGPoint(100, 0))
        context.addLine(to: CGPoint(120, 25))
        context.fillPath()
    }
    func drawGradient (_ context: CGContext, offsetX: CGFloat = 0) {
        // draw the gradient
        let locs: [CGFloat] = [0.0, 0.5, 1.0]
        let colors: [CGFloat] = [
            0.8, 0.4, // starting color, transparent light gray
            0.1, 0.5, // intermediate color, darker less transparent gray
            0.8, 0.4, // ending color, transparent light gray
        ]
        let sp = CGColorSpaceCreateDeviceGray()
        let grad = CGGradient(colorSpace: sp, colorComponents: colors, locations: locs, count: 3)!
        context.drawLinearGradient(grad, start: CGPoint(89 - offsetX, 0), end: CGPoint(111 - offsetX, 0), options: [])
        context.resetClip() // done clipping
        //context.restoreGState()
    }
    func drawPattern (_ con: CGContext, offsetX: CGFloat = 0) {
        con.saveGState()
        let sp2 = CGColorSpace(patternBaseSpace: nil)!
        con.setFillColorSpace(sp2)
        let drawStripes: CGPatternDrawPatternCallback = { _, con in
            con.setFillColor(UIColor.red.cgColor)
            con.fill(CGRect(0,0,4,4))
            con.setFillColor(UIColor.blue.cgColor)
            con.fill(CGRect(0,0,4,2))
        }
        var callbacks = CGPatternCallbacks(version: 0, drawPattern: drawStripes, releaseInfo: nil)
        let patt = CGPattern(info: nil, bounds: CGRect(0,0,4,4),
                             matrix: .identity,
                             xStep: 4, yStep: 4,
                             tiling: .constantSpacingMinimalDistortion,
                             isColored: true, callbacks: &callbacks)!
        con.setPatternPhase(CGSize(2,2))
        var alph: CGFloat = 1.0
        con.setFillPattern(patt, colorComponents: &alph)
        
        // draw arrowhead
        con.move(to: CGPoint(80 - offsetX,25))
        con.addLine(to: CGPoint(100 - offsetX, 0))
        con.addLine(to: CGPoint(120 - offsetX,25))
        con.fillPath()
        con.restoreGState()
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

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
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



 
