//
//  Manga1000Service.swift
//  Dokusho
//
//  Created by Tyler Baker on 4/7/23.
//

import Foundation
import SwiftSoup

final public class Manga1000Service: APIServiceProtocol {
    
    static let shared = Manga1000Service()
    let parser = Manga1000Parser()
    
    func getMangaDetails(source: Source, mangaId: String) async throws -> MangaDetails {
        let urlSession = URLSession.shared
        let url = URL(string: source.baseUrl.appending("/\(mangaId)/"))
        let (data, _) = try await urlSession.data(from: url!)
        let response = String(data: data, encoding: .utf8)
        let html = try SwiftSoup.parse(response!)
        return try parser.parseMangaDetails(html: html, mangaId: mangaId, sourceId: source.sourceId)
    }
    
    func getMangaChapters(source: Source, mangaId: String) async throws -> [Chapter] {
        let urlSession = URLSession.shared
        let url = URL(string: source.baseUrl.appending("/\(mangaId)/"))
        let (data, _) = try await urlSession.data(from: url!)
        let response = String(data: data, encoding: .utf8)
        let html = try SwiftSoup.parse(response!)
        return try parser.parseMangaChapters(html: html, mangaId: mangaId, sourceId: source.sourceId)
    }
    
    func getChapterDetails(source: Source, chapterId: String, mangaId: String) async throws -> ChapterDetails {
        let urlSession = URLSession.shared
        let url = URL(string: source.baseUrl.appending("/\(chapterId)"))
        let (data, _) = try await urlSession.data(from: url!)
        let response = String(data: data, encoding: .utf8)
        let html = try SwiftSoup.parse(response!)
        return try parser.parseChapterDetails(html: html, mangaId: mangaId, sourceId: source.sourceId, chapterId: chapterId)
    }
    
    func getSearchResults(source: Source, query: String) async throws -> [MangaTile] {
        let urlSession = URLSession.shared
        let url = URL(string: source.baseUrl.appending("/manga-list.html?name=\(query.replacing(" ", with: "+"))"))
        let (data, _) = try await urlSession.data(from: url!)
        print()
        let response = String(data: data, encoding: .utf8)
        let html = try SwiftSoup.parse(response!)
        return try parser.parseSearchResults(html: html, sourceId: source.sourceId)
    }
    
    func getHomepageResults(source: Source) async throws -> [MangaTile] {
        let urlSession = URLSession.shared
        let url = URL(string: source.baseUrl)
        let (data, _) = try await urlSession.data(from: url!)
        let response = String(data: data, encoding: .utf8)
        let html = try SwiftSoup.parse(response!)
        return try parser.parseHomepageResults(html: html, sourceId: source.sourceId)
    }
    
    
}
