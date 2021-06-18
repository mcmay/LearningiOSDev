//
//  MyVignetteFilter.swift
//  Chapter2Drawing
//
//  Created by Chao Mei on 16/6/21.
//

import UIKit

class MyVignetteFilter: CIFilter {
    @objc var inputImage: CIImage?
    @objc var inputPercentage: NSNumber? = 1.0
    
    override var outputImage: CIImage? {
        return self.makeOutputImage()
    }
    private func makeOutputImage () -> CIImage? {
        guard let inputImage = self.inputImage else { return nil}
        guard let inputPercentage = self.inputPercentage else { return nil}
        let extent = inputImage.extent
        let smaller = min(extent.width, extent.height)
        let larger = max(extent.width, extent.height)
        let grad = CIFilter.radialGradient()
        grad.center = extent.center
        grad.radius0 = Float(smaller)/2.0 * inputPercentage.floatValue
        grad.radius1 = Float(larger)/2.0
        let gradimage = grad.outputImage!
        let blend = CIFilter.blendWithMask()
        blend.inputImage = self.inputImage
        blend.maskImage = gradimage
        
        return blend.outputImage
    }
}
