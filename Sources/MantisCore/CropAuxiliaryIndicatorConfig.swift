//
//  CropAuxiliaryIndicatorConfig.swift
//  Mantis
//
//  Created by Yingtao Guo on 7/19/24.
//

import Foundation
import CoreGraphics

public struct CropAuxiliaryIndicatorConfig {
    /**
        This value is for how easy to drag crop box. The bigger, the easier.
     */
    public var cropBoxHotAreaUnit: CGFloat = 32 {
        didSet {
            assert(cropBoxHotAreaUnit > 0)
        }
    }
    
    public var disableCropBoxDeformation = false
    public var style: CropAuxiliaryIndicatorStyleType = .normal
    
    public var borderNormalColor = MantisColor.white
    
    /**
        The color of the border when showing which border is touched currently.
     */
    public var borderHintColor = MantisColor.white
    
    public var cornerHandleColor = MantisColor.white
    public var edgeLineHandleColor = MantisColor.white
    
    public var gridMainColor = MantisColor.white
    
    /**
        This property is only used when rotating the image
     */
    public var gridSecondaryColor = MantisColor.lightGray
    
    public init() {}
}
