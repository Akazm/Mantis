//
//  Definition.swift
//  Mantis
//
//  Created by Echo on 8/8/21.
//

import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

typealias OverlayEdgeType = (xDelta: CGFloat, yDelta: CGFloat)
typealias TappedEdgeCropFrameUpdateRule = [CropViewAuxiliaryIndicatorHandleType: OverlayEdgeType]
