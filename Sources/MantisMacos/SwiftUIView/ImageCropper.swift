//
//  ImageCropper.swift
//  MantisMacos
//
//  AppKit/SwiftUI port of the ImageCropper view.
//

#if canImport(SwiftUI)
import SwiftUI
#endif
import AppKit
import MantisCore

@available(macOS 10.15, *)
public struct ImageCropperView: NSViewControllerRepresentable {
    public typealias NSViewControllerType = CropViewController

    private let image: NSImage
    private let config: MantisCore.Config
    @Binding var cropAction: CropAction

    public init(image: NSImage,
                config: MantisCore.Config = MantisCore.Config(),
                cropAction: Binding<CropAction>) {
        self.image = image
        self.config = config
        self._cropAction = cropAction
    }

    public func makeNSViewController(context: Context) -> CropViewController {
        let vc = MantisMacos.cropViewController(image: image, config: config)
        return vc
    }

    public func updateNSViewController(_ nsViewController: CropViewController, context: Context) {
    }
}

@available(macOS 10.15, *)
public enum CropAction {
    case reset
    case rotateLeft
    case rotateRight
    case none
}
