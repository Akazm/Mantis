//
//  RotationDialConfig.swift
//  Mantis
//
//  Created by Echo on 5/22/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import Foundation
import CoreGraphics

public struct RotationDialConfig {
    public init() {}

    public var margin: Double = 0 {
        didSet {
            assert(margin >= 0)
        }
    }
    
    public var lengthRatio: CGFloat = 0.6
            
    public var rotationCenterType: RotationCenterType = .useDefault
    
    public var numberShowSpan = 1 {
        didSet {
            assert(numberShowSpan > 0)
        }
    }
    
    public var orientation: Orientation = .normal

    public var backgroundColor: MantisColor = .clear
    public var bigScaleColor: MantisColor = .lightGray
    public var smallScaleColor: MantisColor = .lightGray
    public var indicatorColor: MantisColor = .lightGray
    public var numberColor: MantisColor = .lightGray
    public var centerAxisColor: MantisColor = .lightGray

    public var theme: Theme = .dark {
        didSet {
            switch theme {
            case .dark:
                backgroundColor = .clear
                bigScaleColor = .lightGray
                smallScaleColor = .lightGray
                indicatorColor = .lightGray
                numberColor = .lightGray
                centerAxisColor = .lightGray
            case .light:
                backgroundColor = .clear
                bigScaleColor = .darkGray
                smallScaleColor = .darkGray
                indicatorColor = .darkGray
                numberColor = .darkGray
                centerAxisColor = .darkGray
            }
        }
    }

    public enum RotationCenterType {
        case useDefault
        case custom(center: CGPoint)
    }

    public enum Orientation {
        case normal
        case right
        case left
        case upsideDown
    }

    public enum Theme {
        case dark
        case light
    }
}
