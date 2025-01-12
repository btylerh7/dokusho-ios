//
//  NetworkManager.swift
//  Dokusho
//
//  Created by Tyler Baker on 12/19/24.
//

import Foundation
import Observation
import SwiftUI
import OSLog

@Observable
public class NetworkManager {
    enum KomgaApiError: Error {
        case noBaseUrl
        case noServerUsername
        case noServerPassword
        case badUrl
        case badEndpoint(String)
        case noResponseStatus
        case badStatus(Int)
        case couldNotDecode
    }

    enum RequestMethod: String {
        case post = "POST"
        case get = "GET"
        case delete = "DELETE"
        case patch = "PATCH"
    }
    final class ClientStorage {
        enum UserData: String {
            case username = "komga-server-username"
            case password = "komga-server-password"
            case serverAddress = "komga-server-address"
        }
        @AppStorage(UserData.username.rawValue) public var username = ""
        @AppStorage(UserData.password.rawValue) public var password = ""
        @AppStorage(UserData.serverAddress.rawValue) public var serverAddress = ""
        
    }
    let clientStorage = ClientStorage()
    
    public var username: String {
        didSet {
            clientStorage.username = username
        }
    }
    public var password: String {
        didSet {
            clientStorage.password = password
        }
    }
    public var serverAddress: String {
        didSet {
            clientStorage.serverAddress = serverAddress
        }
    }
    public var isAuth: Bool {
        !username.isEmpty && !password.isEmpty && !serverAddress.isEmpty
    }
    public static let shared = NetworkManager()
    private init() {
        username = clientStorage.username
        password = clientStorage.password
        serverAddress = clientStorage.serverAddress
    }
    
    
    func makeUrlNew(endpoint: any Endpoint) throws -> URL {
        let urlString = "\(serverAddress)/api/\(endpoint.apiVersion)\(endpoint.urlPath)"
        Logger.clientLogger.info("Url is \(urlString)")
        guard let url = URL(string: urlString) else {
            throw KomgaApiError.badEndpoint(endpoint.urlPath)
        }
        return url
    }
    func addHeadersToRequest(request: inout URLRequest, method: String?) -> URLRequest {
        request.httpMethod = method ?? RequestMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let credentials = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() ?? ""
        request.setValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")
        
        return request

    }
    func makeUrlRequestNew<T: Codable> (endpoint: any Endpoint<T>) async throws -> T? {
        guard let url = try? self.makeUrlNew(endpoint: endpoint) else {
            throw KomgaApiError.badUrl
        }
        Logger.clientLogger.info("Getting url \(url.absoluteString)")
        
        
        var request = URLRequest(url: url)
        request = addHeadersToRequest(request: &request, method: endpoint.requestMethod.rawValue)
        if let body = try? JSONSerialization.data(withJSONObject: endpoint.requestBody ?? [:]) {
            if endpoint.requestMethod != .get {
                request.httpBody = body
            }
        }
        
        
        let (data, response) = try await URLSession.shared.data(for: request)
        Logger.clientLogger.debug("Response was  \(response.debugDescription)")
        guard response is HTTPURLResponse else {
            Logger.clientLogger.error("Could not interpret status")
            throw KomgaApiError.noResponseStatus
        }
        if endpoint.requestMethod == .patch {return nil} // Not needed for this, just confirmation it patched
        
        let debugPrintObject = try? JSONSerialization.jsonObject(with: data)
        Logger.clientLogger.debug("Data was \(debugPrintObject.debugDescription)")
        var decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData = try! decoder.decode(endpoint.returnType.self, from: data)
            return decodedData
        throw KomgaApiError.couldNotDecode
    }
    func decodeData<T: Codable>(_ data: Data?, type: T.Type) -> T? {
        guard let data = data else {
            Logger.clientLogger.error("No data passed into decode function")
            return nil
        }
        let decoder = JSONDecoder()
        let debugPrintObject = try? JSONSerialization.jsonObject(with: data)
        Logger.clientLogger.debug("Data was \(debugPrintObject.debugDescription)")
        do {
            let fetchedData = try decoder.decode(T.self, from: data)
            Logger.clientLogger.debug("Data was: \(String(describing: fetchedData))")
            return fetchedData
        } catch {
            Logger.clientLogger.error("Could not decode type \(type) because \(error.localizedDescription)")
            return nil
        }

    }
}


extension NetworkManager {
    
    func getAllSeries() async -> AllSeries? {
        return try? await self.makeUrlRequestNew(endpoint: KomgaAllSeries())
    }
    func getAllCollections() async -> AllCollections? {
        return try? await self.makeUrlRequestNew(endpoint: KomgaAllCollections())
        
    }
    func getSingleSeries(seriesId: String) async -> Series? {
        return try? await self.makeUrlRequestNew(endpoint: KomgaSeries(seriesId))
    }
    func setReadingProgress(bookId: String, page: Int, total: Int) async -> Int? {
        do {
            let _ = try await self.makeUrlRequestNew(endpoint: SetReadProgress(bookId, page: page, total: total))
            return page
            
        } catch {
            return nil
        }
        
    }
    func getBooksForSeries(_ seriesId: String) async -> [Book]? {
        let allBooks = try? await self.makeUrlRequestNew(endpoint: KomgaAllBooks(seriesId: seriesId))
        return allBooks?.content ?? []
    }
    func getReadProgress(_ bookId: String) async -> ReadProgress? {
        return try? await self.makeUrlRequestNew(endpoint: GetReadProgress(bookId))
    }
    func getCollection(_ collectionId: String) async -> Collection? {
        return try? await self.makeUrlRequestNew(endpoint: KomgaCollection(collectionId))
    }
    func getGenres(seriesList: [Series]) -> [String] {
        let genreList = seriesList.map { series in
            return series.metadata.genres
        }
        return genreList.reduce([String]()) { partialResult, strings in
            var results = partialResult
            strings.forEach { string in
                if !results.contains(string) {
                    results.append(string)
                }
            }
            return results
        }
    }
    func getTags(seriesList: [Series]) -> [String] {
        let tagList = seriesList.map { series in
            return series.booksMetadata.tags
        }
        return tagList.reduce([String]()) { partialResult, strings in
            var results = partialResult
            strings.forEach { string in
                results.append(string)
            }
            return results
        }
    }
}
extension NetworkManager {
    func getSeriesThumbnail(seriesId: String) -> String {
        return "\(serverAddress)/api/v1/series/\(seriesId)/thumbnail"
    }
    func getBookThumbnail(bookId: String) -> String {
        return "\(serverAddress)/api/v1/books/\(bookId)/thumbnail"
    }
    func getBookPageUrl(bookId: String, page: Int) -> String {
        return "\(serverAddress)/api/v1/books/\(bookId)/pages/\(page)"
    }
}
