// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import LegacyScrollView

public struct JBottomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var position: BottomSheetPosition
    let switchablePositions: [BottomSheetPosition]
    let isScrollable: Bool
    let sheetContent: () -> SheetContent
    
    @State private var canScroll = false
    
    public init(
        position: Binding<BottomSheetPosition>,
        switchablePositions: [BottomSheetPosition],
        isScrollable: Bool,
        sheetContent: @escaping () -> SheetContent
    ) {
        self._position = position
        self.switchablePositions = switchablePositions
        self.isScrollable = isScrollable
        self.sheetContent = sheetContent
    }
    
    public func body(content: Content) -> some View {
        if isScrollable {
            content
                .onChange(of: position) { newValue in
                    canScroll = (newValue == .relative(1.0))
                }
                .bottomSheet(
                    bottomSheetPosition: $position,
                    switchablePositions: switchablePositions
                ) {
                    LegacyScrollView {
                        sheetContent()
                    }
                    .onGestureShouldBegin { pan, scrollView in
                        let isDown = scrollView.contentOffset.y - pan.translation(in: scrollView).y > 0
                        if !isDown { canScroll = false }
                        return canScroll
                    }
                }
                .enableContentDrag()
        } else {
            content
                .bottomSheet(
                    bottomSheetPosition: $position,
                    switchablePositions: switchablePositions
                ) {
                    sheetContent()
                }
        }
    }
}

public extension View {
    func jBottomSheet<SheetContent: View>(
        position: Binding<BottomSheetPosition>,
        switchablePositions: [BottomSheetPosition] = [.relative(0.2), .relative(0.5), .relative(1.0)],
        isScrollable: Bool = false,
        @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {
        modifier(
            JBottomSheetModifier(
                position: position,
                switchablePositions: switchablePositions,
                isScrollable: isScrollable,
                sheetContent: content
            )
        )
    }
}
