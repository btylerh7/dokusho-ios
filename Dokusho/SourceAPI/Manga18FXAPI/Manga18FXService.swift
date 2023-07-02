//
//  Manga18FXService.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/26/23.
//

import Foundation
import SwiftSoup

// NOTE: This is only returning raw manhwa at the moment becasue the focus is to be on learning korean.

final class Manga18FXService: APIServiceProtocol {
    
    static let shared = Manga18FXService()
    var parser = Manga18FXParser()
    
    func getMangaDetails(source: Source, mangaId: String) async throws -> MangaDetails {
        let urlSession = URLSession.shared
        let url = URL(string: source.baseUrl.appending("/manga/\(mangaId)"))
        let (data, _) = try await urlSession.data(from: url!)
        let response = String(data: data, encoding: .utf8)
        let html = try SwiftSoup.parse(response!)
        return try parser.parseMangaDetails(html: html, mangaId: mangaId, sourceId: source.sourceId)
    }
    func getMangaChapters(source: Source, mangaId: String) async throws -> [Chapter] {
        let urlSession = URLSession.shared
        let url = URL(string: source.baseUrl.appending("/manga/\(mangaId)"))
        let (data, _) = try await urlSession.data(from: url!)
        let response = String(data: data, encoding: .utf8)
        let html = try SwiftSoup.parse(response!)
        return try parser.parseMangaChapters(html: html, mangaId: mangaId, sourceId: source.sourceId)
    }
    func getChapterDetails(source: Source, chapterId: String, mangaId: String) async throws -> ChapterDetails {
        print(chapterId)
        let urlSession = URLSession.shared
        let urlString = "\(source.baseUrl)/manga/\(mangaId)/\(String(describing: chapterId))"
        print(urlString)
        let url = URL(string: urlString)
        let (data, _) = try await urlSession.data(from: url!)
        let response = String(data: data, encoding: .utf8)
        let html = try SwiftSoup.parse(response!)
        return try parser.parseChapterDetails(html: html, mangaId: mangaId, sourceId: source.sourceId, chapterId: chapterId)
    }
    
    func getSearchResults(source: Source, query: String) async throws -> [MangaTile] {
        let urlSession = URLSession.shared
        let url = URL(string: source.baseUrl.appending("/search?q=\(query.replacing(" ", with: "+"))"))
        let (data, _) = try await urlSession.data(from: url!)
        let response = String(data: data, encoding: .utf8)
        let html = try SwiftSoup.parse(response!)
        return try parser.parseSearchResults(html: html, sourceId: source.sourceId)
        
        
    }
    func getHomepageResults(source: Source) async throws -> [MangaTile] {
        let urlSession = URLSession.shared
        let url = URL(string: source.baseUrl.appending("/manga-genre/raw?orderby=views"))
        let (data, _) = try await urlSession.data(from: url!)
        print()
        let response = String(data: data, encoding: .utf8)
        let html = try SwiftSoup.parse(response!)
        return try parser.parseHomepageResults(html: html, sourceId: source.sourceId)
    }
}
