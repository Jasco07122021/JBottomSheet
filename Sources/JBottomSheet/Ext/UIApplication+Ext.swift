//
//  UIApplication+Ext.swift
//  JBottomSheet
//
//  Created by mackbool on 08/05/26.
//
import SwiftUI

extension UIApplication {
    static var safeAreaInsets: UIEdgeInsets {
        keyWindow?.safeAreaInsets ?? .zero
    }
    
    private static var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
