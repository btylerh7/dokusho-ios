//
//  KomgaService.swift
//  Dokusho
//
//  Created by Tyler Baker on 5/14/23.
//

import Foundation

// TODO: Add endpoints for fetching and updating page counts

public enum KomgaEndpoints {
    case homepage
    case mangadetails
    case chapters
    case chapterDetails
    case search
}

final class KomgaService: APIServiceProtocol {
    let serverAddress = UserDefaults.standard.object(forKey: "komga-server-address") as! String
    static let shared = KomgaService()
    var parser = KomgaParser()
    
    func makeKomgaRequest(url: URL) async -> Data?  {
        print("url: \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // TODO: Add guards here
        let serverUsername = UserDefaults.standard.object(forKey: "komga-server-username") as! String
        let serverPassword = UserDefaults.standard.object(forKey: "komga-server-password") as! String
        // Set the Authorization header with the basic authentication credentials
        let credentials = "\(serverUsername):\(serverPassword)".data(using: .utf8)?.base64EncodedString() ?? ""
        let authString = "Basic \(credentials)"
        print("auth string: \(authString)")
        request.setValue(authString, forHTTPHeaderField: "Authorization")

        // Create a URLSessionDataTask to make the request
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print(NSError(domain: NSURLErrorDomain, code: NSURLErrorBadServerResponse, userInfo: nil).localizedDescription)
                return nil
            }
            return data
        }
        catch {
            print(error)
            return nil
        }
    }
    
    // TODO: Add error handling
    
    func getMangaDetails(source: Source, mangaId: String) async throws -> MangaDetails {
        let url = URL(string: "\(serverAddress)/api/v1/series/\(mangaId)")!
        let jsonData = await makeKomgaRequest(url: url)
        let json = try! JSONDecoder().decode(KomgaMangaDetailsResult.self, from: jsonData!)
        return try parser.parseMangaDetails(json: json, mangaId: mangaId, sourceId: source.sourceId, baseUrl: serverAddress)
    }
    
    func getMangaChapters(source: Source, mangaId: String) async throws -> [Chapter] {
        let url = URL(string: "\(serverAddress)/api/v1/series/\(mangaId)/books")!
        let jsonData = await makeKomgaRequest(url: url)

        let json = try! JSONDecoder().decode(KomgaChaptersResultsV2.self, from: jsonData!)
        
        return try parser.parseMangaChapters(json: json, mangaId: mangaId, sourceId: source.sourceId)
        
    }
    
    func getChapterDetails(source: Source, chapterId: String, mangaId: String) async throws -> ChapterDetails {
        let url = URL(string: "\(serverAddress)/api/v1/books/\(chapterId)/pages")!
        let jsonData = await makeKomgaRequest(url: url)
        let json = try! JSONDecoder().decode([KomgaBookPage].self, from: jsonData!)
        return try parser.parseChapterDetails(json: json, mangaId: mangaId, sourceId: source.sourceId, chapterId: chapterId, baseUrl: serverAddress )
    }
    
    func getSearchResults(source: Source, query: String) async throws -> [MangaTile] {
        let tiles: [MangaTile] = []
        
        return tiles
    }
    
    func getHomepageResults(source: Source) async throws -> [MangaTile] {
        let url = URL(string: "\(String(describing: serverAddress))/api/v1/series")!
        let jsonData = await makeKomgaRequest(url: url)
        let json = try! JSONDecoder().decode(KomgaHomepageResults.self, from: jsonData!)
        return try parser.parseHomepageResults(json: json, sourceId: source.sourceId, baseUrl: serverAddress)
    }
    
    
}
