//
//  RotationDialViewModel.swift
//  Puffer
//
//  Created by Echo on 5/22/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import Foundation

public final class RotationDialViewModel: RotationDialViewModelProtocol {
    public var didSetRotationAngle: (Angle) -> Void = { _ in }
    
    public var touchPoint: CGPoint? {
        didSet {
            guard let oldValue = oldValue,
                let newValue = self.touchPoint,
                let rotationCal = rotationCalculator else {
                return
            }
            
            let radians = rotationCal.getRotationRadians(byOldPoint: oldValue, andNewPoint: newValue)
            rotationAngle = Angle(radians: radians)
        }
    }

    public var rotationAngle = Angle(degrees: 0) {
        didSet {
            didSetRotationAngle(rotationAngle)
        }
    }

    private var rotationCalculator: RotationCalculator?
    
    public func setup(with midPoint: CGPoint) {
        rotationCalculator = RotationCalculator(midPoint: midPoint)
    }
}
