//
//  RotationDialProtocol.swift
//  MantisMacos
//
//  AppKit port of the RotationControlViewProtocol.
//

import AppKit
import MantisCore

public protocol RotationControlViewProtocol: NSView {
    var isAttachedToCropView: Bool { get set }
    var didUpdateRotationValue: (_ angle: Angle) -> Void { get set }
    var didFinishRotation: () -> Void { get set }
    func setup(with frame: CGRect)
    func updateRotationValue(by angle: Angle)
    func reset()
    func handleDeviceRotation()
}

public extension RotationControlViewProtocol {
    func setup(with frame: CGRect) {}
    func handleDeviceRotation() {}
}
