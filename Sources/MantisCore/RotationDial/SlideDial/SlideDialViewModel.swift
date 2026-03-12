//
//  SlideDialViewModel.swift
//  Mantis
//
//  Created by Yingtao Guo on 6/19/23.
//

import Foundation

public final class SlideDialViewModel {
    public var didSetRotationAngle: (Angle) -> Void = { _ in }
    
    /// Called when the selected adjustment type changes (only used in withTypeSelector mode)
    public var didChangeAdjustmentType: ((RotationAdjustmentType) -> Void)?
    
    public var rotationAngle = Angle(degrees: 0) {
        didSet {
            didSetRotationAngle(rotationAngle)
        }
    }
    
    // MARK: - Multi-type support (withTypeSelector mode)
    
    public var currentAdjustmentType: RotationAdjustmentType = .straighten
    
    /// Stored angles for each adjustment type
    private var storedAngles: [RotationAdjustmentType: CGFloat] = [
        .straighten: 0,
        .horizontalSkew: 0,
        .verticalSkew: 0
    ]
    
    public func storedAngle(for type: RotationAdjustmentType) -> CGFloat {
        storedAngles[type] ?? 0
    }
    
    public func storeAngle(_ degrees: CGFloat, for type: RotationAdjustmentType) {
        storedAngles[type] = degrees
    }
        
    public func reset() {
        storedAngles = [
            .straighten: 0,
            .horizontalSkew: 0,
            .verticalSkew: 0
        ]
        rotationAngle = Angle(degrees: 0)
    }
    
    public func resetAll() {
        storedAngles = [
            .straighten: 0,
            .horizontalSkew: 0,
            .verticalSkew: 0
        ]
        currentAdjustmentType = .straighten
        rotationAngle = Angle(degrees: 0)
    }
}
