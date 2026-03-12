//
//  CropDimmingView.swift
//  Mantis
//
//  Created by Echo on 10/22/18.
//  Copyright © 2018 Echo. All rights reserved.
//

#if canImport(UIKit) || canImport(AppKit)
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

final class CropDimmingView: UIView, CropMaskProtocol {
    var overLayerFillColor: UIColor = .black    
    var maskLayer: CALayer?
    var cropShapeType: CropShapeType = .rect
    var imageRatio: CGFloat = 1.0
    
    convenience init(cropShapeType: CropShapeType = .rect) {
        self.init(frame: CGRect.zero)
        self.cropShapeType = cropShapeType
    }
    
    func setMask(cropRatio: CGFloat) {
        maskLayer?.removeFromSuperlayer()
        maskLayer = createMaskLayer(opacity: 0.5, cropRatio: cropRatio)
        #if canImport(UIKit)
        layer.addSublayer(maskLayer!)
        #elseif canImport(AppKit)
        wantsLayer = true
        layer?.addSublayer(maskLayer!)
        #endif
    }
}
#endif
