//
//  CropViewControllerDelegate.swift
//  MantisMacos
//
//  AppKit port of the CropViewControllerDelegate.
//

import AppKit
import MantisCore

public protocol CropViewControllerDelegate: AnyObject {
    func cropViewControllerDidCrop(_ cropViewController: CropViewController,
                                   cropped: NSImage,
                                   transformation: Transformation,
                                   cropInfo: CropInfo)
    func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController, original: NSImage)
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: NSImage)

    func cropViewControllerDidBeginResize(_ cropViewController: CropViewController)
    func cropViewControllerDidEndResize(_ cropViewController: CropViewController, original: NSImage, cropInfo: CropInfo)

    func cropViewControllerDidBeginCrop(_ cropViewController: CropViewController)
    func cropViewControllerDidEndCrop(_ cropViewController: CropViewController, original: NSImage, cropInfo: CropInfo)

    func cropViewControllerDidImageTransformed(_ cropViewController: CropViewController, transformation: Transformation)

    func cropViewControllerDidUpdateCropState(_ cropViewController: CropViewController, isResettable: Bool)
    func cropViewControllerDidUpdateUndoState(_ cropViewController: CropViewController, undoEnabled: Bool, redoEnabled: Bool)
    func cropViewControllerDidUpdateResetState(_ cropViewController: CropViewController, resetEnabled: Bool)
}

public extension CropViewControllerDelegate {
    func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController, original: NSImage) {}
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: NSImage) {}
    func cropViewControllerDidBeginResize(_ cropViewController: CropViewController) {}
    func cropViewControllerDidEndResize(_ cropViewController: CropViewController, original: NSImage, cropInfo: CropInfo) {}
    func cropViewControllerDidBeginCrop(_ cropViewController: CropViewController) {}
    func cropViewControllerDidEndCrop(_ cropViewController: CropViewController, original: NSImage, cropInfo: CropInfo) {}
    func cropViewControllerDidImageTransformed(_ cropViewController: CropViewController, transformation: Transformation) {}
    func cropViewControllerDidUpdateCropState(_ cropViewController: CropViewController, isResettable: Bool) {}
    func cropViewControllerDidUpdateUndoState(_ cropViewController: CropViewController, undoEnabled: Bool, redoEnabled: Bool) {}
    func cropViewControllerDidUpdateResetState(_ cropViewController: CropViewController, resetEnabled: Bool) {}
}
