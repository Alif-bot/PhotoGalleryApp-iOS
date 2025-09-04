//
//  ShareSheetView.swift
//  PhotoGallery
//
//  Created by Md Alif Hossain on 4/9/25.
//

import SwiftUI

public struct ShareSheetView: UIViewControllerRepresentable {

    public let items: [Any]
    var onComplete: (() -> Void)?

    public init(
        items: [Any],
        onComplete: (() -> Void)? = nil
    ) {
        self.items = items
        self.onComplete = onComplete
    }

    public func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        controller.completionWithItemsHandler = { _, _, _, _ in
            onComplete?()
        }
        return controller
    }

    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}
