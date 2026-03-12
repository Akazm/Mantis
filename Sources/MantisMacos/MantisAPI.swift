//
//  MantisAPI.swift
//  MantisMacos
//
//  AppKit-specific public API for creating and configuring crop view controllers.
//

import AppKit
import MantisCore

// MARK: - APIs
public func cropViewController(image: NSImage,
                               config: MantisCore.Config = MantisCore.Config(),
                               cropToolbar: CropToolbarProtocol = CropToolbar(frame: .zero),
                               rotationControlView: RotationControlViewProtocol? = nil) -> CropViewController {
    var resolvedConfig = config
    MantisCore.applyAppearanceDefaults(to: &resolvedConfig)
    let cropViewController = CropViewController(config: resolvedConfig)
    cropViewController.cropToolbar = cropToolbar
    return cropViewController
}

public func setupCropViewController(_ cropViewController: CropViewController,
                                    with image: NSImage,
                                    and config: MantisCore.Config = MantisCore.Config(),
                                    cropToolbar: CropToolbarProtocol = CropToolbar(frame: .zero),
                                    rotationControlView: RotationControlViewProtocol? = nil) {
    var resolvedConfig = config
    MantisCore.applyAppearanceDefaults(to: &resolvedConfig)
    cropViewController.config = resolvedConfig
    cropViewController.cropToolbar = cropToolbar
}

public func crop(image: NSImage, by cropInfo: CropInfo) -> NSImage? {
    // TODO: Implement macOS image cropping
    return nil
}
