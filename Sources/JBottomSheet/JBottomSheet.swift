// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import LegacyScrollView

public struct JBottomSheetModifier<SheetContent: View, HeaderContent: View>: ViewModifier {
    @Binding var position: BottomSheetPosition
    let switchablePositions: [BottomSheetPosition]
    let isScrollable: Bool
    let sheetContent: () -> SheetContent
    let headerContent: (() -> HeaderContent)?
    
    @State private var canScroll = false
    
    public init(
        position: Binding<BottomSheetPosition>,
        switchablePositions: [BottomSheetPosition],
        isScrollable: Bool,
        sheetContent: @escaping () -> SheetContent,
        headerContent: (() -> HeaderContent)? = nil
    ) {
        self._position = position
        self.switchablePositions = switchablePositions
        self.isScrollable = isScrollable
        self.sheetContent = sheetContent
        self.headerContent = headerContent
    }
    
    public func body(content: Content) -> some View {
        content
            .onChange(of: position) { newValue in
                canScroll = (newValue == .relative(1.0))
            }
            .bottomSheet(
                bottomSheetPosition: $position,
                switchablePositions: switchablePositions,
                headerContent: headerContent ?? { nil }
            ) {
                if isScrollable {
                    LegacyScrollView {
                        sheetContent()
                            .padding(.bottom, UIApplication.safeAreaInsets.bottom)
                    }
                    .onGestureShouldBegin { pan, scrollView in
                        let isDown = scrollView.contentOffset.y - pan.translation(in: scrollView).y > 0
                        if !isDown { canScroll = false }
                        return canScroll
                    }
                } else {
                    sheetContent()
                        .padding(.bottom, UIApplication.safeAreaInsets.bottom)
                }
            }
            .enableSwipeToDismiss(!isScrollable)
            .enableTapToDismiss(!isScrollable)
            .enableContentDrag(isScrollable)
            .enableBackgroundBlur(!isScrollable)
            .customThreshold(0.1)
            .customBackground(
                Color.white
                    .cornerRadius(12, corners: [.topLeft, .topRight])
            )
            .backgroundBlurMaterial(.systemDark)
    }
}

public extension View {
    func jBottomSheet<SheetContent: View, HeaderContent: View>(
        position: Binding<BottomSheetPosition>,
        switchablePositions: [BottomSheetPosition] = [.dynamic],
        isScrollable: Bool = false,
        @ViewBuilder header: @escaping () -> HeaderContent,
        @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {
        modifier(
            JBottomSheetModifier(
                position: position,
                switchablePositions: switchablePositions,
                isScrollable: isScrollable,
                sheetContent: content,
                headerContent: header
            )
        )
    }
    
    // header yo'q variant
    func jBottomSheet<SheetContent: View>(
        position: Binding<BottomSheetPosition>,
        switchablePositions: [BottomSheetPosition] = [.dynamic],
        isScrollable: Bool = false,
        @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {
        modifier(
            JBottomSheetModifier<SheetContent, EmptyView>(
                position: position,
                switchablePositions: switchablePositions,
                isScrollable: isScrollable,
                sheetContent: content,
                headerContent: nil
            )
        )
    }
}



//struct ContentView: View {
//    @State var pos: BottomSheetPosition = .dynamic
//    
//    var body: some View {
//        Text("Test")
//            .jBottomSheet(position: $pos) {
//                VStack(spacing: 10) {
//                    ForEach(0..<10, id: \.self) {index in
//                        Text("Jascoo")
//                    }
//                }
//            }
//    }
//}
//
//#Preview {
//    ContentView()
//}
