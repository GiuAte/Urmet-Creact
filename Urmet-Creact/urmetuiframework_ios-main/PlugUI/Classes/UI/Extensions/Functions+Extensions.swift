//
//  Functions.swift
//  CallMe
//
//  Created by Luca Lancellotti on 12/09/22.
//

import Foundation
import UIKit

public enum Functions {
    static let ciContext = CIContext(mtlDevice: MTLCreateSystemDefaultDevice()!)

    public static func blurredImage(_ image: UIImage, radius: CGFloat) -> UIImage? {
        if let source = image.cgImage {
            let inputImage = CIImage(cgImage: source)

            let clampFilter = CIFilter(name: "CIAffineClamp")
            clampFilter?.setDefaults()
            clampFilter?.setValue(inputImage, forKey: kCIInputImageKey)

            if let clampedImage = clampFilter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let explosureFilter = CIFilter(name: "CIExposureAdjust")
                explosureFilter?.setValue(clampedImage, forKey: kCIInputImageKey)
                explosureFilter?.setValue(-1.0, forKey: kCIInputEVKey)

                if let explosureImage = explosureFilter?.value(forKey: kCIOutputImageKey) as? CIImage {
                    let filter = CIFilter(name: "CIGaussianBlur")
                    filter?.setValue(explosureImage, forKey: kCIInputImageKey)
                    filter?.setValue(radius, forKey: kCIInputRadiusKey)

                    if let result = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
                        let cgImage = ciContext.createCGImage(result, from: CGRect(origin: .zero, size: CGSize(width: source.width, height: source.height)))
                        let returnImage = UIImage(cgImage: cgImage!)
                        return returnImage
                    }
                }
            }
        }
        return UIImage()
    }
}
