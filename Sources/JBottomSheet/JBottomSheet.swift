// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import LegacyScrollView

public struct JBottomSheetModifier<SheetContent: View, HeaderContent: View, BackgroundContent: View>: ViewModifier {
    @Binding var position: BottomSheetPosition
    let switchablePositions: [BottomSheetPosition]
    let isScrollable: Bool
    let showSafeAreaPadding: Bool
    let sheetContent: () -> SheetContent
    let backgroundContent: () -> BackgroundContent?
    let headerContent: (() -> HeaderContent)?
    
    @State private var canScroll = false
    
    public init(
        position: Binding<BottomSheetPosition>,
        switchablePositions: [BottomSheetPosition],
        isScrollable: Bool,
        showSafeAreaPadding: Bool,
        sheetContent: @escaping () -> SheetContent,
        backgroundContent: @escaping () -> BackgroundContent?,
        headerContent: (() -> HeaderContent)? = nil
    ) {
        self._position = position
        self.switchablePositions = switchablePositions
        self.isScrollable = isScrollable
        self.showSafeAreaPadding = showSafeAreaPadding
        self.sheetContent = sheetContent
        self.backgroundContent = backgroundContent
        self.headerContent = headerContent
    }
    
    private var safeAreaPadding: CGFloat {
        showSafeAreaPadding ? UIApplication.safeAreaInsets.bottom : 0
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
                            .padding(.bottom, safeAreaPadding)
                    }
                    .onGestureShouldBegin { pan, scrollView in
                        let isDown = scrollView.contentOffset.y - pan.translation(in: scrollView).y > 0
                        if !isDown { canScroll = false }
                        return canScroll
                    }
                } else {
                    sheetContent()
                        .padding(.bottom, safeAreaPadding)
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
            .backgroundBlurView(
                backgroundContent()
            )
            .dragEnable(isScrollable)
    }
}

public extension View {
    func jBottomSheet<SheetContent: View, HeaderContent: View, BackgroundContent: View>(
        position: Binding<BottomSheetPosition>,
        switchablePositions: [BottomSheetPosition] = [.dynamic],
        isScrollable: Bool = false,
        showSafeAreaPadding: Bool = true,
        @ViewBuilder header: @escaping () -> HeaderContent,
        @ViewBuilder backgroundContent: @escaping () -> BackgroundContent?,
        @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {
        modifier(
            JBottomSheetModifier(
                position: position,
                switchablePositions: switchablePositions,
                isScrollable: isScrollable,
                showSafeAreaPadding: showSafeAreaPadding,
                sheetContent: content,
                backgroundContent: backgroundContent,
                headerContent: header
            )
        )
    }
    
    // header yo'q variant
    func jBottomSheet<SheetContent: View>(
        position: Binding<BottomSheetPosition>,
        switchablePositions: [BottomSheetPosition] = [.dynamic],
        isScrollable: Bool = false,
        showSafeAreaPadding: Bool = true,
        @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {
        modifier(
            JBottomSheetModifier<SheetContent, EmptyView, EmptyView>(
                position: position,
                switchablePositions: switchablePositions,
                isScrollable: isScrollable,
                showSafeAreaPadding: showSafeAreaPadding,
                sheetContent: content,
                backgroundContent: { nil },
                headerContent: nil
            )
        )
    }
    
    func jBottomSheet<SheetContent: View, BackgroundContent: View>(
        position: Binding<BottomSheetPosition>,
        switchablePositions: [BottomSheetPosition] = [.dynamic],
        isScrollable: Bool = false,
        showSafeAreaPadding: Bool = true,
        @ViewBuilder backgroundContent: @escaping () -> BackgroundContent,
        @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {
        modifier(
            JBottomSheetModifier<SheetContent, EmptyView, BackgroundContent>(
                position: position,
                switchablePositions: switchablePositions,
                isScrollable: isScrollable,
                showSafeAreaPadding: showSafeAreaPadding,
                sheetContent: content,
                backgroundContent: backgroundContent,
                headerContent: nil
            )
        )
    }
}



struct ContentView: View {
    @State var pos: BottomSheetPosition = .dynamic
    
    var body: some View {
        List {
            ForEach(0...10, id: \.self) { index in
                Text("Jasco \(index)")
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .background(.red)
                    .onTapGesture {
                        pos = .dynamic
                    }
            }
        }
        .jBottomSheet(position: $pos) {
            VStack(spacing: 10) {
                ForEach(0..<10, id: \.self) {index in
                    Text("Jascoo")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
