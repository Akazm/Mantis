//
//  CropViewController.swift
//  MantisMacos
//
//  AppKit port of the CropViewController.
//

import AppKit
import MantisCore

open class CropViewController: NSViewController {
    public weak var delegate: CropViewControllerDelegate?
    public var config = MantisCore.Config()
    public var cropToolbar: CropToolbarProtocol?

    public required init(config: MantisCore.Config = MantisCore.Config()) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func loadView() {
        view = NSView()
    }
}
