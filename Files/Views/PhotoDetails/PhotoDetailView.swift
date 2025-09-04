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
            .onAppear {
                viewModel.loadUIImage()
            }
            .sheet(isPresented: $viewModel.isSharePresented) {
                if let image = viewModel.image {
                    ShareSheetView(items: [image])
                }
            }
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
                
                topButtonsView()
                toastView()
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
                    MagnificationGesture()
                        .onChanged { value in
                            let delta = value / viewModel.lastScale
                            viewModel.lastScale = value
                            viewModel.scale = min(max(viewModel.scale * delta, 1), 5)
                        }
                        .onEnded { _ in
                            viewModel.lastScale = 1
                            if viewModel.scale < 1 { viewModel.resetZoom() }
                        },
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
    private func topButtonsView() -> some View {
        VStack {
            HStack {
                dismissButtonView()
                Spacer()
                saveandShareButtonView()
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private func dismissButtonView() -> some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(.white)
                .padding(.leading, 12)
                .padding(.top, 16)
        }
    }
    
    @ViewBuilder
    private func saveandShareButtonView() -> some View {
        Menu {
            Button("Save to Gallery") {
                viewModel.saveToGallery()
            }
            Button("Share") {
                viewModel.isSharePresented = true
            }
        } label: {
            Image(systemName: "ellipsis.circle.fill")
                .font(.system(size: 25))
                .foregroundColor(.white)
                .padding(.trailing, 12)
                .padding(.top, 16)
        }
    }
    
    @ViewBuilder
    private func toastView() -> some View {
        if viewModel.showToast {
            Text("Saved Successfully!")
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.horizontal, 25)
                .padding(.vertical, 10)
                .background(Color.black.opacity(0.8))
                .cornerRadius(12)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut, value: viewModel.showToast)
                .padding(.bottom, 50)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
}

#Preview {
    PhotoDetailView(
        photo: Photo(
            id: "0",
            author: "Alejandro Escamilla",
            width: 200,
            height: 300,
            url: "https://unsplash.com/photos/yC-Yzbqy7PY",
            download_url: "https://picsum.photos/id/0/5000/3333"
        )
    )
}
