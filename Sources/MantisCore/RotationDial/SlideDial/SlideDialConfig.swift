//
//  SlideDialConfig.swift
//  Mantis
//
//  Created by Yingtao Guo on 6/19/23.
//

import Foundation
import CoreGraphics

public enum SlideDialMode {
    /// Simple mode: a text label above the ruler showing the current angle
    case simple
    /// Apple Photos style: three circular icon buttons (Straighten / Vertical Skew / Horizontal Skew)
    /// above the ruler, with the selected button showing the numeric value
    case withTypeSelector
}

public struct SlideDialConfig {
    public init() {}
    
    public var mode: SlideDialMode = .simple
    
    public var lengthRatio: CGFloat = 0.8
    
    /// Backward-compatible limitation property (used in simple mode)
    public var limitation: CGFloat {
        get { straightenLimitation }
        set { straightenLimitation = newValue }
    }
    
    public var straightenLimitation: CGFloat = Constants.rotationDegreeLimit
    public var skewLimitation: CGFloat = PerspectiveTransformHelper.maxSkewDegrees
    
    /// Returns the limitation for the given adjustment type
    func limitation(for type: RotationAdjustmentType) -> CGFloat {
        switch type {
        case .straighten:
            return straightenLimitation
        case .horizontalSkew, .verticalSkew:
            return skewLimitation
        }
    }
    
    public var scaleBarNumber = 41
    public var majorScaleBarNumber = 5
    
    public var scaleColor = MantisColor.gray
    public var majorScaleColor = MantisColor.white
    
    public var activeColor = MantisColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0) // golden yellow
    public var inactiveColor = MantisColor.white
    public var ringColor = MantisColor(white: 0.45, alpha: 1.0) // medium gray ring
    public var buttonFillColor = MantisColor(white: 0.2, alpha: 1.0) // dark button background
    public var iconColor = MantisColor.white
    
    public var pointerColor = MantisColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0) // golden yellow center pointer
    public var centralDotColor = MantisColor.white
    
    public var indicatorSize = CGSize(width: 40, height: 40)
    public var typeButtonSize: CGFloat = 56
    public var typeButtonSpacing: CGFloat = 16
    public var slideRulerHeight: CGFloat = 45
}
