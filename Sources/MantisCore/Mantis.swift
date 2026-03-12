//
//  Mantis.swift
//  MantisCore
//
//  Created by Yingtao Guo on 11/3/18.
//  Copyright © 2018 Echo Studio. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation

// MARK: - APIs
public func locateResourceBundle(by hostClass: AnyClass) {
    LocalizedHelper.setBundle(Bundle(for: hostClass))
}

public struct Language {
    var code: String
    
    public init(code: String) {
        self.code = code
    }
}

public func chooseLanguage(_ language: Language) {
    MantisCore.Config.language = language
}

public func resetLanguage() {
    MantisCore.Config.language = nil
}

// MARK: - internal section
var localizationConfig = LocalizationConfig()

// MARK: - private section
private(set) var bundle: Bundle? = {
    return MantisCore.Config.bundle
}()

public func applyAppearanceDefaults(to config: inout MantisCore.Config) {
    let mode = config.appearanceMode
    
    // Propagate appearance mode to internal configs
    config.cropViewConfig.appearanceMode = mode
    
    // For forceDark, all defaults already match — no changes needed
    guard mode != .forceDark else { return }
    
    // CropToolbarConfig
    config.cropToolbarConfig.backgroundColor = AppearanceColorPreset.toolbarBackground(for: mode)
    config.cropToolbarConfig.foregroundColor = AppearanceColorPreset.toolbarForeground(for: mode)
    
    // CropMaskVisualEffectType (only if user hasn't set a custom backgroundColor)
    if config.cropViewConfig.backgroundColor == nil {
        config.cropViewConfig.cropMaskVisualEffectType = AppearanceColorPreset.maskVisualEffectType(for: mode)
    }
    
    // SlideDialConfig / RotationDialConfig
    switch config.cropViewConfig.builtInRotationControlViewType {
    case .slideDial(var slideConfig):
        applySlideDialAppearance(to: &slideConfig, for: mode)
        config.cropViewConfig.builtInRotationControlViewType = .slideDial(config: slideConfig)
    case .rotationDial(var dialConfig):
        dialConfig.theme = AppearanceColorPreset.rotationDialTheme(for: mode)
        config.cropViewConfig.builtInRotationControlViewType = .rotationDial(config: dialConfig)
    }
}

public func applySlideDialAppearance(to config: inout SlideDialConfig, for mode: AppearanceMode) {
    config.scaleColor = AppearanceColorPreset.slideDialScaleColor(for: mode)
    config.majorScaleColor = AppearanceColorPreset.slideDialMajorScaleColor(for: mode)
    config.inactiveColor = AppearanceColorPreset.slideDialInactiveColor(for: mode)
    config.ringColor = AppearanceColorPreset.slideDialRingColor(for: mode)
    config.buttonFillColor = AppearanceColorPreset.slideDialButtonFillColor(for: mode)
    config.iconColor = AppearanceColorPreset.slideDialIconColor(for: mode)
    config.centralDotColor = AppearanceColorPreset.slideDialCentralDotColor(for: mode)
}
