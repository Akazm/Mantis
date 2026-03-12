//
//  CropToolbarProtocol.swift
//  MantisMacos
//
//  AppKit port of the CropToolbarProtocol.
//

import AppKit
import MantisCore

public protocol CropToolbarDelegate: AnyObject {
    func didSelectCancel(_ cropToolbar: CropToolbarProtocol?)
    func didSelectCrop(_ cropToolbar: CropToolbarProtocol?)
    func didSelectCounterClockwiseRotate(_ cropToolbar: CropToolbarProtocol?)
    func didSelectClockwiseRotate(_ cropToolbar: CropToolbarProtocol?)
    func didSelectReset(_ cropToolbar: CropToolbarProtocol?)
    func didSelectSetRatio(_ cropToolbar: CropToolbarProtocol?)
    func didSelectRatio(_ cropToolbar: CropToolbarProtocol?, ratio: Double)
    func didSelectFreeRatio(_ cropToolbar: CropToolbarProtocol?)
    func didSelectAlterCropper90Degree(_ cropToolbar: CropToolbarProtocol?)
    func didSelectHorizontallyFlip(_ cropToolbar: CropToolbarProtocol?)
    func didSelectVerticallyFlip(_ cropToolbar: CropToolbarProtocol?)
    func didSelectAutoAdjust(_ cropToolbar: CropToolbarProtocol?, isActive: Bool)
    func didSelectUndo(_ cropToolbar: CropToolbarProtocol?)
    func didSelectRedo(_ cropToolbar: CropToolbarProtocol?)
    func isUndoSupported(_ cropToolbar: CropToolbarProtocol?) -> Bool
    func undoActionName(_ cropToolbar: CropToolbarProtocol?) -> String
    func redoActionName(_ cropToolbar: CropToolbarProtocol?) -> String
}

public protocol CropToolbarIconProvider: AnyObject {
    func getClockwiseRotationIcon() -> NSImage?
    func getCounterClockwiseRotationIcon() -> NSImage?
    func getResetIcon() -> NSImage?
    func getSetRatioIcon() -> NSImage?
    func getAlterCropper90DegreeIcon() -> NSImage?
    func getCancelIcon() -> NSImage?
    func getCropIcon() -> NSImage?
    func getHorizontallyFlipIcon() -> NSImage?
    func getVerticallyFlipIcon() -> NSImage?
    func getAutoAdjustIcon() -> NSImage?
    func getUndoIcon() -> NSImage?
    func getRedoIcon() -> NSImage?
}

public extension CropToolbarIconProvider {
    func getClockwiseRotationIcon() -> NSImage? { nil }
    func getCounterClockwiseRotationIcon() -> NSImage? { nil }
    func getResetIcon() -> NSImage? { nil }
    func getSetRatioIcon() -> NSImage? { nil }
    func getAlterCropper90DegreeIcon() -> NSImage? { nil }
    func getCancelIcon() -> NSImage? { nil }
    func getCropIcon() -> NSImage? { nil }
    func getHorizontallyFlipIcon() -> NSImage? { nil }
    func getVerticallyFlipIcon() -> NSImage? { nil }
    func getAutoAdjustIcon() -> NSImage? { nil }
    func getUndoIcon() -> NSImage? { nil }
    func getRedoIcon() -> NSImage? { nil }
}

public protocol CropToolbarProtocol: NSView {
    var config: CropToolbarConfig { get set }
    var iconProvider: CropToolbarIconProvider? { get set }
    var delegate: CropToolbarDelegate? { get set }

    func createToolbarUI(config: CropToolbarConfig)
    func handleFixedRatioSetted(ratio: Double)
    func handleFixedRatioUnSetted()
    func handleCropViewDidBecomeResettable()
    func handleCropViewDidBecomeUnResettable()
    func adjustLayoutWhenOrientationChange()
    func adjustIconsForRatio(shouldShowRatioButton: Bool)
    func updateUndoRedoButtons(undoEnabled: Bool, redoEnabled: Bool)
}

public extension CropToolbarProtocol {
    func adjustLayoutWhenOrientationChange() {}
    func adjustIconsForRatio(shouldShowRatioButton: Bool) {}
    func updateUndoRedoButtons(undoEnabled: Bool, redoEnabled: Bool) {}
}
