//
//  BottomSheet+BackgroundBlur.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2022 Lucas Zischka. All rights reserved.
//

import SwiftUI

public extension BottomSheet {
    
    /// Adds a fullscreen blur layer below the BottomSheet.
    ///
    /// The opacity of the layer is proportional to the height of the BottomSheet.
    /// The material can be changed using the `.backgroundBlurMaterial()` modifier.
    ///
    /// - Parameters:
    ///   - bool: A boolean whether the option is enabled.
    ///
    /// - Returns: A view that has a blur layer below the BottomSheet.
    func enableBackgroundBlur(_ bool: Bool = true) -> BottomSheet {
        self.configuration.isBackgroundBlurEnabled = bool
        return self
    }
    
    /// Changes the material of the blur layer.
    ///
    /// Changing the material does not affect whether the blur layer is shown.
    /// To toggle the blur layer please use the `.enableBackgroundBlur()` modifier.
    ///
    /// - Returns: A view with a different material of the blur layer.
    func backgroundBlurView<BackgroundBlurView>(_ view: BackgroundBlurView?) -> BottomSheet where BackgroundBlurView: View {
        if let view = view {
            self.configuration.backgroundBlurView = AnyView(view)
        }
        self.configuration.backgroundBlurViewID = UUID()
        return self
    }
    
    func backgroundBlurView<BBV>(
        @ViewBuilder content: () -> BBV?
    ) -> BottomSheet where BBV: View {
        if let content = content() {
            self.configuration.backgroundBlurView = AnyView(content)
        }
        self.configuration.backgroundBlurViewID = UUID()
        return self
    }
}
