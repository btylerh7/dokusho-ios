//
//  MangaLoveService.swift
//  Dokusho
//
//  Created by Tyler Baker on 4/3/23.
//

// TODO: This source currently does not load images. Must find way to bypass restrictions.

import Foundation
import SwiftSoup

public class MangaLoveService: APIServiceProtocol {
    static let shared = MangaLoveService()
    var parser = MangaLoveParser()
    
    
    func getMangaDetails(source: Source, mangaId: String) async throws -> MangaDetails {
        let urlSession = URLSession.shared
        let url = URL(string: source.baseUrl.appending("/\(mangaId)"))
        let (data, _) = try await urlSession.data(from: url!)
        let response = String(data: data, encoding: .utf8)
        let html = try SwiftSoup.parse(response!)
        return try parser.parseMangaDetails(html: html, mangaId: mangaId, sourceId: source.sourceId)
    }
    
    func getMangaChapters(source: Source, mangaId: String) async throws -> [Chapter] {
        let urlSession = URLSession.shared
        let url = URL(string: source.baseUrl.appending("/\(mangaId)"))
        let (data, _) = try await urlSession.data(from: url!)
        let response = String(data: data, encoding: .utf8)
        let html = try SwiftSoup.parse(response!)
        return try parser.parseMangaChapters(html: html, mangaId: mangaId, sourceId: source.sourceId)
    }
    
    func getChapterDetails(source: Source, chapterId: String, mangaId: String) async throws -> ChapterDetails {
        let urlSession = URLSession.shared
        let url = URL(string: source.baseUrl.appending("/chapters/\(chapterId)"))
        let (data, _) = try await urlSession.data(from: url!)
        let response = String(data: data, encoding: .utf8)
        let html = try SwiftSoup.parse(response!)
        return try parser.parseChapterDetails(html: html, mangaId: mangaId, sourceId: source.sourceId, chapterId: chapterId)
    }
    
    func getSearchResults(source: Source, query: String) async throws -> [MangaTile] {
        let urlSession = URLSession.shared
        let url = URL(string: source.baseUrl.appending("/?s=\(query.replacing(" ", with: "+"))"))
        let (data, _) = try await urlSession.data(from: url!)
        print()
        let response = String(data: data, encoding: .utf8)
        let html = try SwiftSoup.parse(response!)
        return try parser.parseHomepageResults(html: html, sourceId: source.sourceId)
    }
    
    func getHomepageResults(source: Source) async throws -> [MangaTile] {
        let urlSession = URLSession.shared
        let url = URL(string: source.baseUrl.appending("/top"))
        print("Starting to retrieve tiles for \(String(describing: url))")
        let (data, _) = try await urlSession.data(from: url!)
        print()
        let response = String(data: data, encoding: .utf8)
        let html = try SwiftSoup.parse(response!)
        return try parser.parseHomepageResults(html: html, sourceId: source.sourceId)
    }
    
    
}

