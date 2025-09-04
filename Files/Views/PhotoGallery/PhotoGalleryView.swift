//
//  PhotoGalleryView.swift
//  PhotoGallery
//
//  Created by Md Alif Hossain on 4/9/25.
//

import SwiftUI

struct PhotoGalleryView: View {
    @StateObject private var viewModel: PhotoGalleryViewModel
    
    init(
        viewModel: @autoclosure @escaping () -> PhotoGalleryViewModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        NavigationView {
            contentView()
            .sheet(item: $viewModel.selectedPhoto) { photo in
                PhotoDetailView(photo: photo)
            }
        }
        .onAppear {
            viewModel.fetchPhotos()
        }
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        VStack {
            navigationBarView()
            if viewModel.isGrid {
                gridView()
            } else {
                listView()
            }
        }
    }
    
    @ViewBuilder
    private func navigationBarView() -> some View {
        HStack {
            Text("Photo Gallery")
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
            Button(action: { viewModel.eventHandler(.toggleLayout) }) {
                Image(systemName: viewModel.isGrid ? "list.bullet" : "square.grid.2x2")
                    .font(.title2)
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    @ViewBuilder
    private func gridView() -> some View {
        ScrollView {
            LazyVGrid(columns: viewModel.gridColumns, spacing: 12) {
                ForEach(viewModel.photos) { photo in
                    GeometryReader { geometry in
                        PhotoCellView(
                            photo: photo,
                            height: geometry.size.width,
                            width: geometry.size.width
                        )
                        .onTapGesture { viewModel.selectedPhoto = photo }
                    }
                    .aspectRatio(1, contentMode: .fit)
                }
            }
            .padding(12)
        }
    }

    @ViewBuilder
    private func listView() -> some View {
        List(viewModel.photos) { photo in
            PhotoCellView(photo: photo, height: 200)
                .frame(maxWidth: .infinity)
                .onTapGesture { viewModel.selectedPhoto = photo }
        }
        .listStyle(PlainListStyle())
    }
}

#Preview {
    PhotoGalleryView(
        viewModel: PhotoGalleryViewModel()
    )
}
