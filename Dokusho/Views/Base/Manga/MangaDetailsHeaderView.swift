//
//  MangaDetailsHeaderView.swift
//  Dokusho
//
//  Created by Tyler Baker on 5/19/23.
//

import SwiftUI
import NukeUI

struct MangaDetailsHeaderViewWrapper: UIViewRepresentable {
    
    
    var mangaTile: MangaTile
    var viewModel: MangaChapterTableViewModel
    
    func makeUIView(context: Context) -> UIView {
        let headerView = UIHostingController(rootView: MangaDetailsHeaderView(mangaTile: mangaTile, viewModel: viewModel))
        return headerView.view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

struct MangaDetailsHeaderView: View {
    @State var isBookmarked = false
    @State var isPresentingCategoryModal = false
    @State var details: MangaDetails? = nil

    let mangaTile: MangaTile
    @State var viewModel: MangaChapterTableViewModel
    @State var source: Source? = nil
    
    
    var body: some View {
        VStack {
            HStack {
                LazyImage(url: URL(string: details?.image ?? "")) { state in
                    if state.isLoading {
                        ProgressView()
                    }
                    if state.image != nil {
                        state.image!
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                            .clipped()
                            .frame(width:150)
                            
                            
                    }
                }
                Spacer()
                VStack {
                    Text(details?.title ?? "")
                        .font(.headline)
                        .bold()
                    Text(details?.author ?? "")
                        .font(.subheadline)
                        .bold()
                    HStack {
                        Text(details?.sourceId ?? "")
                            
                            .font(.caption)
                            .padding(5)
                            .background(Color(.systemBlue))
                            .cornerRadius(10)
                            
                        Button {
                          didTapBookmarkButton()
                        } label: {
                            Image(systemName: isBookmarked == true ? "bookmark.fill" : "bookmark")
                                .foregroundColor(Color(.systemBlue))
                        }
                        Button {
                          isPresentingCategoryModal = true
                        } label: {
                            Image(systemName: "plus.app")
                                .foregroundColor(Color(.systemBlue))
                        }
                    }
                    

                }

            }
            .navigationTitle(details?.title ?? "")
            .navigationBarTitleDisplayMode(.inline)
            Text(details?.description ?? "")
                .font(.body)
                
        }
        .padding(.bottom)
        .frame(maxWidth: .infinity)
        .foregroundColor(Color(.label))
        .textCase(.none)
        .onAppear {
            source = SourceManager.shared.getSourceFromId(sourceId: mangaTile.sourceId)
            Task {
                await viewModel.getMangaDetailsV1(sourceId: mangaTile.sourceId, mangaId: mangaTile.mangaId)
            }
            viewModel.mangaDetailsObservable.bind { newDetails in
                print("Details gotten")
                details = newDetails
            }
            checkIsBookmarked(id: mangaTile.mangaId)
        }
        .sheet(isPresented: $isPresentingCategoryModal) {
            AddToCategoryView(mangaId: mangaTile.mangaId, sourceId: source!.sourceId)
        }
    }
}

extension MangaDetailsHeaderView {
    func didTapBookmarkButton() {
            if isBookmarked == true {
                viewModel.context.perform {
                    if let libraryEntry = CoreDataManager.shared.getLibraryEntryFromId(id: self.mangaTile.mangaId, context: self.viewModel.context) {
                        CoreDataManager.shared.removeLibraryEntry(libraryEntry: libraryEntry, context: self.viewModel.context)
                    }
                    self.checkIsBookmarked(id: self.mangaTile.mangaId)
                }
            }
            else {
                // TODO: Add error handling
                viewModel.context.perform {
                    CoreDataManager.shared.addToLibrary(mangaDetails: self.viewModel.mangaDetailsObservable.value!, source: self.viewModel.source!, context: self.viewModel.context)
                    self.checkIsBookmarked(id: self.mangaTile.mangaId)
                }
            }
    }
    
    
    private func checkIsBookmarked(id: String) {
        guard let source = source else {return}
        viewModel.context.perform {
            let result = CoreDataManager.shared.hasLibraryObject(id: id, sourceId: source.sourceId, context: self.viewModel.context)
            print("check is bookmarked result is: \(result)")
            self.isBookmarked = result
        }
    }
}

