//
//  APIServiceProtocol.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/29/23.
//

import Foundation

protocol APIServiceProtocol {
    func getMangaDetails(source: Source, mangaId: String) async throws -> MangaDetails
    func getMangaChapters(source: Source, mangaId: String) async throws -> [Chapter]
    func getChapterDetails(source: Source, chapterId: String, mangaId: String) async throws -> ChapterDetails
    func getSearchResults(source: Source, query: String) async throws -> [MangaTile]
    func getHomepageResults(source: Source) async throws -> [MangaTile]
}
