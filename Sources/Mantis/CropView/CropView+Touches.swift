//
//  CropView+Touches.swift
//  Mantis
//
//  Created by Echo on 5/24/19.
//

import Foundation
#if canImport(UIKit) || canImport(AppKit)
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension CropView {
    private func isHitGridOverlayView(by touchPoint: CGPoint) -> Bool {
        let hotAreaUnit = cropViewConfig.cropAuxiliaryIndicatorConfig.cropBoxHotAreaUnit
        
        return cropAuxiliaryIndicatorView.frame.insetBy(dx: -hotAreaUnit/2, dy: -hotAreaUnit/2).contains(touchPoint)
        && !cropAuxiliaryIndicatorView.frame.insetBy(dx: hotAreaUnit/2, dy: hotAreaUnit/2).contains(touchPoint)
    }

#if canImport(UIKit)
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let newPoint = convert(point, to: self)
        
        // Check rotation type selector first (it's on top)
        if cropViewConfig.enablePerspectiveCorrection && rotationTypeSelector.frame.contains(newPoint) {
            let pointInSelector = rotationTypeSelector.convert(newPoint, from: self)
            return rotationTypeSelector.hitTest(pointInSelector, with: event)
        }
        
        if let rotationControlView = rotationControlView {
            // In landscape the rotation control is rotated 90° and becomes a narrow
            // strip. Expand the hit area so touches slightly outside still register
            // on the slider rather than panning the image.
            let hotPadding: CGFloat = Orientation.isLandscape ? 20 : 0
            let expandedFrame = rotationControlView.frame.insetBy(dx: -hotPadding, dy: -hotPadding)
            if expandedFrame.contains(newPoint) {
                let pointInRotationControlView = rotationControlView.convert(newPoint, from: self)
                return rotationControlView.getTouchTarget(with: pointInRotationControlView)
            }
        }
        
        if !cropViewConfig.cropAuxiliaryIndicatorConfig.disableCropBoxDeformation && isHitGridOverlayView(by: newPoint) {
            return self
        }
        
        if bounds.contains(newPoint) {
            return cropWorkbenchView
        }
        
        return nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard touches.count == 1, let touch = touches.first else {
            return
        }
        
        // A resize event has begun by grabbing the crop UI, so notify delegate
        delegate?.cropViewDidBeginResize(self)
        
        if touch.view is RotationControlViewProtocol {
            return
        }
        
        let point = touch.location(in: self)
        viewModel.prepareForCrop(byTouchPoint: point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard touches.count == 1, let touch = touches.first else {
            return
        }
        
        if touch.view is RotationControlViewProtocol {
            return
        }
        
        let touchPoint = touch.location(in: self)
        
        if touchPoint != viewModel.panOriginPoint {
            updateCropBoxFrame(withTouchPoint: touchPoint)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard touches.count == 1, let touch = touches.first else {
            return
        }
        
        if touch.view is RotationControlViewProtocol {
            return
        }
        
        if viewModel.needCrop() {
            hasManuallyAdjustedCropBox = true
            cropAuxiliaryIndicatorView.handleEdgeUntouched()
            let contentRect = getContentBounds()
            adjustUIForNewCrop(contentRect: contentRect) {[weak self] in
                guard let self = self else { return }
                self.delegate?.cropViewDidEndResize(self)
                self.viewModel.setBetweenOperationStatus()
                self.cropWorkbenchView.updateMinZoomScale()
            }
        } else {
            delegate?.cropViewDidEndResize(self)
            viewModel.setBetweenOperationStatus()
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer {
            return false
        }
        
        return true
    }
#elseif canImport(AppKit)
    override func hitTest(_ point: CGPoint) -> NSView? {
        let newPoint = convert(point, from: superview)
        
        // Check rotation type selector first (it's on top)
        if cropViewConfig.enablePerspectiveCorrection && rotationTypeSelector.frame.contains(newPoint) {
            let pointInSelector = rotationTypeSelector.convert(newPoint, from: self)
            return rotationTypeSelector.hitTest(pointInSelector)
        }
        
        if let rotationControlView = rotationControlView {
            let hotPadding: CGFloat = Orientation.isLandscape ? 20 : 0
            let expandedFrame = rotationControlView.frame.insetBy(dx: -hotPadding, dy: -hotPadding)
            if expandedFrame.contains(newPoint) {
                let pointInRotationControlView = rotationControlView.convert(newPoint, from: self)
                return rotationControlView.getTouchTarget(with: pointInRotationControlView)
            }
        }
        
        if !cropViewConfig.cropAuxiliaryIndicatorConfig.disableCropBoxDeformation && isHitGridOverlayView(by: newPoint) {
            return self
        }
        
        if bounds.contains(newPoint) {
            return cropWorkbenchView
        }
        
        return nil
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        // A resize event has begun by grabbing the crop UI, so notify delegate
        delegate?.cropViewDidBeginResize(self)
        
        let point = convert(event.locationInWindow, from: nil)
        viewModel.prepareForCrop(byTouchPoint: point)
    }
    
    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        
        let touchPoint = convert(event.locationInWindow, from: nil)
        
        if touchPoint != viewModel.panOriginPoint {
            updateCropBoxFrame(withTouchPoint: touchPoint)
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        
        if viewModel.needCrop() {
            hasManuallyAdjustedCropBox = true
            cropAuxiliaryIndicatorView.handleEdgeUntouched()
            let contentRect = getContentBounds()
            adjustUIForNewCrop(contentRect: contentRect) {[weak self] in
                guard let self = self else { return }
                self.delegate?.cropViewDidEndResize(self)
                self.viewModel.setBetweenOperationStatus()
                self.cropWorkbenchView.updateMinZoomScale()
            }
        } else {
            delegate?.cropViewDidEndResize(self)
            viewModel.setBetweenOperationStatus()
        }
    }
#endif
}
#endif // canImport(UIKit) || canImport(AppKit)
