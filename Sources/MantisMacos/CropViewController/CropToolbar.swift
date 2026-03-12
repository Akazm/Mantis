//
//  CropToolbar.swift
//  MantisMacos
//
//  AppKit port of the CropToolbar.
//

import AppKit
import MantisCore

public final class CropToolbar: NSView, CropToolbarProtocol {
    public var config = CropToolbarConfig()
    public var iconProvider: CropToolbarIconProvider?
    public weak var delegate: CropToolbarDelegate?

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func createToolbarUI(config: CropToolbarConfig) {
        self.config = config
    }

    public func handleFixedRatioSetted(ratio: Double) {}
    public func handleFixedRatioUnSetted() {}
    public func handleCropViewDidBecomeResettable() {}
    public func handleCropViewDidBecomeUnResettable() {}
}
