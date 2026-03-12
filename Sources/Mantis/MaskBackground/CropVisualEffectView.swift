//
//  CropVisualEffectView.swift
//  Mantis
//
//  Created by Echo on 10/22/18.
//  Copyright © 2018 Echo. All rights reserved.
//

#if canImport(UIKit)
import UIKit

final class CropMaskVisualEffectView: UIVisualEffectView, CropMaskProtocol {
    var overLayerFillColor: UIColor = .black
    var maskLayer: CALayer?
    var cropShapeType: CropShapeType = .rect
    var imageRatio: CGFloat = 1.0
    
    private var translucencyEffect: UIVisualEffect?
    private var effectType: CropMaskVisualEffectType = .blurDark
    
    convenience init(cropShapeType: CropShapeType = .rect,
                     effectType: CropMaskVisualEffectType = .blurDark) {
        
        let (translucencyEffect, backgroundColor) = CropMaskVisualEffectView.getEffect(byType: effectType)
        
        self.init(effect: translucencyEffect)
        self.cropShapeType = cropShapeType
        self.effectType = effectType
        self.translucencyEffect = translucencyEffect
        self.backgroundColor = backgroundColor
    }
        
    func setMask(cropRatio: CGFloat) {
        maskLayer?.removeFromSuperlayer()        
        maskLayer = createMaskLayer(opacity: 0.98, cropRatio: cropRatio)
        
        let maskView = UIView(frame: self.bounds)
        maskView.clipsToBounds = true
        maskView.layer.addSublayer(maskLayer!)
        
        self.mask = maskView
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if case .blurSystem = effectType {
            if #available(iOS 13.0, *),
               traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                applyBlurSystemEffect()
            }
        }
    }
    
    private func applyBlurSystemEffect() {
        if #available(iOS 13.0, *) {
            let isDark = traitCollection.userInterfaceStyle == .dark
            if isDark {
                self.effect = UIBlurEffect(style: .dark)
                self.backgroundColor = .clear
            } else {
                // Blur effects sample underlying content, so they can appear
                // dark over colorful images. Use a solid light background
                // instead to guarantee a light appearance in light mode.
                self.effect = nil
                self.backgroundColor = UIColor(white: 0.95, alpha: 0.98)
            }
        }
    }
    
    static func getEffect(byType type: CropMaskVisualEffectType) -> (UIVisualEffect?, UIColor) {
        switch type {
        case .blurDark:
            return (UIBlurEffect(style: .dark), .clear)
        case .dark:
            return (nil, UIColor.black.withAlphaComponent(0.75))
        case .light:
            return (nil, UIColor.black.withAlphaComponent(0.35))
        case .custom(let color):
            return(nil, color)
        case .blurSystem:
            // Initial value; will be corrected by applyBlurSystemEffect() once
            // the view is in the hierarchy and traitCollection is available.
            return (UIBlurEffect(style: .dark), .clear)
        case .default:
            return (nil, .black)
        }
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if case .blurSystem = effectType, window != nil {
            applyBlurSystemEffect()
        }
    }
}
#elseif canImport(AppKit)
import AppKit

final class CropMaskVisualEffectView: NSVisualEffectView, CropMaskProtocol {
    var overLayerFillColor: NSColor = .black
    var maskLayer: CALayer?
    var cropShapeType: CropShapeType = .rect
    var imageRatio: CGFloat = 1.0
    
    private var effectType: CropMaskVisualEffectType = .blurDark
    
    convenience init(cropShapeType: CropShapeType = .rect,
                     effectType: CropMaskVisualEffectType = .blurDark) {
        self.init(frame: .zero)
        self.cropShapeType = cropShapeType
        self.effectType = effectType
        
        wantsLayer = true
        blendingMode = .behindWindow
        state = .active
        
        applyEffect(for: effectType)
    }
    
    func setMask(cropRatio: CGFloat) {
        maskLayer?.removeFromSuperlayer()
        maskLayer = createMaskLayer(opacity: 0.98, cropRatio: cropRatio)
        
        wantsLayer = true
        let containerLayer = CALayer()
        containerLayer.frame = self.bounds
        containerLayer.masksToBounds = true
        containerLayer.addSublayer(maskLayer!)
        
        self.layer?.mask = containerLayer
    }
    
    private func applyEffect(for effectType: CropMaskVisualEffectType) {
        switch effectType {
        case .blurDark:
            material = .dark
            state = .active
            backgroundColor = .clear
        case .dark:
            state = .inactive
            backgroundColor = NSColor.black.withAlphaComponent(0.75)
        case .light:
            state = .inactive
            backgroundColor = NSColor.black.withAlphaComponent(0.35)
        case .custom(let color):
            state = .inactive
            backgroundColor = color
        case .blurSystem:
            let isDark = NSApp?.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
            if isDark {
                material = .dark
                state = .active
                backgroundColor = .clear
            } else {
                state = .inactive
                backgroundColor = NSColor(white: 0.95, alpha: 0.98)
            }
        case .default:
            state = .inactive
            backgroundColor = .black
        }
    }
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        if case .blurSystem = effectType, window != nil {
            applyEffect(for: effectType)
        }
    }
}
#endif
