//
//  MantisAPI.swift
//  MantisIOS
//
//  UIKit-specific public API for creating and configuring crop view controllers.
//

import UIKit
import MantisCore

// MARK: - APIs
public func cropViewController(image: UIImage,
                               config: MantisCore.Config = MantisCore.Config(),
                               cropToolbar: CropToolbarProtocol = CropToolbar(frame: .zero),
                               rotationControlView: RotationControlViewProtocol? = nil) -> CropViewController {
    var resolvedConfig = config
    MantisCore.applyAppearanceDefaults(to: &resolvedConfig)
    let cropViewController = CropViewController(config: resolvedConfig)
    cropViewController.cropView = buildCropView(withImage: image,
                                                config: resolvedConfig.cropViewConfig,
                                                rotationControlView: rotationControlView)
    cropViewController.cropToolbar = cropToolbar
    return cropViewController
}

public func cropViewController<T: CropViewController>(image: UIImage,
                                                      config: MantisCore.Config = MantisCore.Config(),
                                                      cropToolbar: CropToolbarProtocol = CropToolbar(frame: .zero),
                                                      rotationControlView: RotationControlViewProtocol? = nil) -> T {
    var resolvedConfig = config
    MantisCore.applyAppearanceDefaults(to: &resolvedConfig)
    let cropViewController = T(config: resolvedConfig)
    cropViewController.cropView = buildCropView(withImage: image,
                                                config: resolvedConfig.cropViewConfig,
                                                rotationControlView: rotationControlView)
    cropViewController.cropToolbar = cropToolbar
    return cropViewController
}

public func setupCropViewController(_ cropViewController: CropViewController,
                                    with image: UIImage,
                                    and config: MantisCore.Config = MantisCore.Config(),
                                    cropToolbar: CropToolbarProtocol = CropToolbar(frame: .zero),
                                    rotationControlView: RotationControlViewProtocol? = nil) {
    var resolvedConfig = config
    MantisCore.applyAppearanceDefaults(to: &resolvedConfig)
    cropViewController.config = resolvedConfig
    cropViewController.cropView = buildCropView(withImage: image,
                                                config: resolvedConfig.cropViewConfig,
                                                rotationControlView: rotationControlView)
    cropViewController.cropToolbar = cropToolbar
}

public func crop(image: UIImage, by cropInfo: CropInfo) -> UIImage? {
    return image.crop(by: cropInfo)
}

// MARK: - private section
private func buildCropView(withImage image: UIImage,
                           config cropViewConfig: CropViewConfig,
                           rotationControlView: RotationControlViewProtocol?) -> CropViewProtocol {
    let cropAuxiliaryIndicatorView = CropAuxiliaryIndicatorView(frame: .zero,
                                                                config: cropViewConfig.cropAuxiliaryIndicatorConfig)
    let imageContainer = ImageContainer(image: image)
    let cropView = CropView(image: image,
                            cropViewConfig: cropViewConfig,
                            viewModel: buildCropViewModel(with: cropViewConfig),
                            cropAuxiliaryIndicatorView: cropAuxiliaryIndicatorView,
                            imageContainer: imageContainer,
                            cropWorkbenchView: buildCropWorkbenchView(with: cropViewConfig, and: imageContainer),
                            cropMaskViewManager: buildCropMaskViewManager(with: cropViewConfig))
    
    setupRotationControlViewIfNeeded(withConfig: cropViewConfig, cropView: cropView, rotationControlView: rotationControlView)
    return cropView
}

private func buildCropViewModel(with cropViewConfig: CropViewConfig) -> CropViewModelProtocol {
    CropViewModel(
        cropViewPadding: cropViewConfig.padding,
        hotAreaUnit: cropViewConfig.cropAuxiliaryIndicatorConfig.cropBoxHotAreaUnit
    )
}

private func buildCropWorkbenchView(with cropViewConfig: CropViewConfig, and imageContainer: ImageContainerProtocol) -> CropWorkbenchViewProtocol {
    CropWorkbenchView(frame: .zero,
                   minimumZoomScale: cropViewConfig.minimumZoomScale,
                   maximumZoomScale: cropViewConfig.maximumZoomScale,
                   imageContainer: imageContainer)
}

private func buildCropMaskViewManager(with cropViewConfig: CropViewConfig) -> CropMaskViewManagerProtocol {
    
    let dimmingView = CropDimmingView(cropShapeType: cropViewConfig.cropShapeType)
    
    let visualEffectView = CropMaskVisualEffectView(cropShapeType: cropViewConfig.cropShapeType,
                                                    effectType: cropViewConfig.cropMaskVisualEffectType)
    
    if let color = cropViewConfig.backgroundColor {
        dimmingView.overLayerFillColor = color
        visualEffectView.overLayerFillColor = color
    } else {
        let overlayColor = AppearanceColorPreset.dimmingOverlayColor(for: cropViewConfig.appearanceMode)
        dimmingView.overLayerFillColor = overlayColor
        visualEffectView.overLayerFillColor = overlayColor
    }
    
    return CropMaskViewManager(dimmingView: dimmingView, visualEffectView: visualEffectView)
}

private func setupRotationControlViewIfNeeded(withConfig cropViewConfig: CropViewConfig,
                                              cropView: CropView,
                                              rotationControlView: RotationControlViewProtocol?) {
    if let rotationControlView = rotationControlView {
        if rotationControlView.isAttachedToCropView == false ||
            rotationControlView.isAttachedToCropView && cropViewConfig.showAttachedRotationControlView {
            cropView.rotationControlView = rotationControlView
        }
    } else {
        if cropViewConfig.showAttachedRotationControlView {
            let controlViewType: CropViewConfig.BuiltInRotationControlViewType
            if cropViewConfig.enablePerspectiveCorrection {
                switch cropViewConfig.builtInRotationControlViewType {
                case .rotationDial:
                    controlViewType = .slideDial()
                case .slideDial:
                    controlViewType = cropViewConfig.builtInRotationControlViewType
                }
            } else {
                controlViewType = cropViewConfig.builtInRotationControlViewType
            }
            
            switch controlViewType {
            case .rotationDial(let config):
                let viewModel = RotationDialViewModel()
                let dialPlate = RotationDialPlate(frame: .zero, config: config)
                cropView.rotationControlView = RotationDial(frame: .zero,
                                                            config: config,
                                                            viewModel: viewModel,
                                                            dialPlate: dialPlate)
            case .slideDial(var config):
                if cropViewConfig.enablePerspectiveCorrection {
                    config.mode = .withTypeSelector
                }
                let mode = cropViewConfig.appearanceMode
                if mode != .forceDark {
                    MantisCore.applySlideDialAppearance(to: &config, for: mode)
                }
                let viewModel = SlideDialViewModel()
                let slideRuler = SlideRuler(frame: .zero, config: config)
                let slideDial = SlideDial(frame: .zero,
                                          config: config,
                                          viewModel: viewModel,
                                          slideRuler: slideRuler)
                cropView.rotationControlView = slideDial
            }
        }
    }
}
