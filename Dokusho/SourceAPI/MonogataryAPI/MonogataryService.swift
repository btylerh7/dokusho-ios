//
//  MonogataryService.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/25/23.
//
import Foundation
import SwiftSoup


final class MonogataryService: APIServiceProtocol {
    
    
    
    static let shared = MonogataryService()
    var parser = MonogataryParser()
    
    func getMangaDetails(source: Source, mangaId: String) async throws -> MangaDetails {
        let urlSession = URLSession.shared
        let url = URL(string: source.baseUrl.appending("/api/story/\(mangaId)"))
        let (data, _) = try await urlSession.data(from: url!)
        let json = try! JSONDecoder().decode(MonogataryStoryDetails.self, from: data)
        return try parser.parseMangaDetails(json: json, mangaId: mangaId, sourceId: source.sourceId)
    }
    func getMangaChapters(source: Source, mangaId: String) async throws -> [Chapter] {
        let urlSession = URLSession.shared
        let url = URL(string: source.baseUrl.appending("/api/story/\(mangaId)"))
        let (data, _) = try await urlSession.data(from: url!)
        let json = try! JSONDecoder().decode(MonogataryStoryDetails.self, from: data)
        return try parser.parseMangaChapters(json: json.episodes, mangaId: mangaId, sourceId: source.sourceId)
    }
    func getChapterDetails(source: Source, chapterId: String, mangaId: String) async throws -> ChapterDetails {
        let urlSession = URLSession.shared
        let url = URL(string: source.baseUrl.appending("/api/episode/\(chapterId)"))
        let (data, _) = try await urlSession.data(from: url!)
        let json = try! JSONDecoder().decode(MonogataryChapterDetails.self, from: data)
        return try parser.parseChapterDetails(json: json, mangaId: mangaId, sourceId: source.sourceId, chapterId: chapterId)
    }
    
    func getSearchResults(source: Source, query: String) async throws -> [MangaTile] {
        let urlSession = URLSession.shared
        let url = URL(string: source.baseUrl.appending("?s=\(query)"))
        let (data, _) = try await urlSession.data(from: url!)
        print()
        let response = String(data: data, encoding: .utf8)
        let html = try SwiftSoup.parse(response!)
        return try parser.parseSearchResults(html: html, sourceId: source.sourceId)
        
        
    }
    func getHomepageResults(source: Source) async throws -> [MangaTile] {
        let urlSession = URLSession.shared
        let url = URL(string: "\(source.baseUrl)/api/stories?page=1&tab=ranking&sort=hot")
        let (data, _) = try await urlSession.data(from: url!)
        let json = try! JSONDecoder().decode(MonogataryHomepageResults.self, from: data)
        return try parser.parseHomepageResults(json: json, sourceId: source.sourceId)
    }
}
