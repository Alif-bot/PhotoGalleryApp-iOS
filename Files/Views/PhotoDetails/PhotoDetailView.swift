//
//  PhotoDetailView.swift
//  PhotoGallery
//
//  Created by Md Alif Hossain on 4/9/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct PhotoDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: PhotoDetailViewModel
    
    init(photo: Photo) {
        _viewModel = StateObject(wrappedValue: PhotoDetailViewModel(photo: photo))
    }
    
    var body: some View {
        contentView()
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                imageView()
                    .onTapGesture(count: 2) {
                        withAnimation(.easeInOut) {
                            if viewModel.scale > 1 {
                                viewModel.resetZoom()
                            } else {
                                viewModel.scale = 2.5
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                closeButtonView()
            }
        }
    }
    
    @ViewBuilder
    private func imageView() -> some View {
        WebImage(url: URL(string: viewModel.photo.download_url))
            .resizable()
            .scaledToFit()
            .scaleEffect(viewModel.scale)
            .offset(viewModel.offset)
            .gesture(
                SimultaneousGesture(
                    // Pinch-to-zoom
                    MagnificationGesture()
                        .onChanged { value in
                            let delta = value / viewModel.lastScale
                            viewModel.lastScale = value
                            viewModel.scale = min(max(viewModel.scale * delta, 1), 5)
                        }
                        .onEnded { _ in
                            viewModel.lastScale = 1
                            if viewModel.scale < 1 {
                                viewModel.resetZoom()
                            }
                        },
                    
                    // Drag when zoomed
                    DragGesture()
                        .onChanged { value in
                            guard viewModel.scale > 1 else { return }
                            viewModel.offset = CGSize(
                                width: viewModel.lastOffset.width + value.translation.width,
                                height: viewModel.lastOffset.height + value.translation.height
                            )
                        }
                        .onEnded { _ in
                            viewModel.lastOffset = viewModel.offset
                        }
                )
            )
    }
    
    @ViewBuilder
    private func closeButtonView() -> some View {
        // Close button
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.white)
                        .padding()
                }
            }
            Spacer()
        }
    }
}

#Preview {
    PhotoDetailView(
        photo: Photo(
            id: "0",
            author: "Alejandro Escamilla",
            width: 5000,
            height: 3333,
            url: "https://unsplash.com/photos/yC-Yzbqy7PY",
            download_url: "https://picsum.photos/id/0/5000/3333"
        )
    )
}
