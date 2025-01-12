//
//  Client.swift
//  Dokusho
//
//  Created by Tyler Baker on 5/29/24.
//

import Foundation
import SwiftUI
import Observation
import OSLog

@Observable
public final class Client {
    public enum KomgaAPIEndpoints {
        case allSeries
        case singleSeries(id: String)
        case seriesThumbnail(id: String)
        case seriesBooks(id: String)
        case book(id: String)
        case bookThumbnail(id: String)
        case bookPage(id: String, page: Int)
        case bookProgress(id: String)
        case collections
        case collection(id: String)
        
        
        
    //    case latestSeries
    //    case newSeries
    //    case genres
    //    case genre
    //    case tags
    //    case book
        
        var rawValue: String {
            switch self {
            case .allSeries:
                return "series"
            case .singleSeries(let id):
                return "series/\(id)"
            case .seriesThumbnail(let id):
                return "series/\(id)/thumbnail"
            case .seriesBooks(let id):
                return "series/\(id)/books"
            case .book(let id):
                return "books/\(id)"
            case .bookThumbnail(let id):
                return "books/\(id)/thumbnail"
            case .bookPage(let id, let page):
                return "books/\(id)/pages/\(page)"
            case .bookProgress(let id):
                return "books/\(id)/read-progress"
            case .collections:
                return "collections"
            case .collection(let id):
                return "collections/\(id)"
                
                
            }
        }
    }

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
    private init() {
        username = clientStorage.username
        password = clientStorage.password
        serverAddress = clientStorage.serverAddress
    }
    public static let shared = Client()
    func makeUrl(endpoint: KomgaAPIEndpoints) throws -> URL {
        let urlString = "\(serverAddress)/api/v1/\(endpoint.rawValue)"
        Logger.clientLogger.info("Url is \(urlString)")
        guard let url = URL(string: urlString) else {
            throw KomgaApiError.badEndpoint(endpoint.rawValue)
        }
        return url
    }
    func makeUrlNew(endpoint: any Endpoint) throws -> URL {
        let urlString = "\(serverAddress)/api/\(endpoint.apiVersion)/\(endpoint.urlPath)"
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
    func getReturnType(endpoint: KomgaAPIEndpoints) async -> Codable.Type {
        switch endpoint {
        case .allSeries:
            return AllSeries.self
        case .singleSeries(_):
            return Series.self
        case .seriesThumbnail(_):
            return String.self
        case .seriesBooks(_):
            return Books.self
        case .book(_):
            return Book.self
        case .bookThumbnail(_):
            return String.self
        case .bookPage(_,_):
            return String.self
        case .bookProgress(_):
            return String.self // TODO: This isn't really a get
        case .collections:
            return AllCollections.self
        case .collection(_):
            return Collection.self
        }
    }
    func get<T: Codable>(endpoint: KomgaAPIEndpoints, type: T.Type) async -> T? {
        return try? await makeUrlRequest(endpoint: endpoint, requestMethod: .get, returnType: type)
    }
    func patch<T: Codable>(endpoint: KomgaAPIEndpoints, type: T.Type, id: String, page: Int? = nil, total: Int? = nil) async -> T? {
        guard case .bookProgress(_) = endpoint else {
            return nil
        }
        let completed = page == total ? true : false
        var body: [String: Any]
        print("Page is \(String.init(describing: page))")
        if let page = page {
            body = [
                "page": page,
                "completed": completed
            ]
            let result = try? await makeUrlRequest(endpoint: endpoint, requestMethod: .patch, body: body, returnType: type)
            print(result ?? "no result")
            return result
        }
        
        return nil
    }
    func makeUrlRequestNew<T: Codable> (endpoint: any Endpoint<T>) async throws -> T? {
        
        guard let url = try? self.makeUrlNew(endpoint: endpoint) else {
            throw KomgaApiError.badUrl
        }
        Logger.clientLogger.info("Getting url \(url.absoluteString)")
        
        
        var request = URLRequest(url: url)
        request = addHeadersToRequest(request: &request, method: endpoint.requestMethod.rawValue)
        if let body = try? JSONSerialization.data(withJSONObject: endpoint.requestBody ?? [:]) {
            request.httpBody = body
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard response is HTTPURLResponse else {
            Logger.clientLogger.error("Could not interpret status")
            throw KomgaApiError.noResponseStatus
        }
        if endpoint.requestMethod == .patch {return nil} // Not needed for this, just confirmation it patched
        
        let debugPrintObject = try? JSONSerialization.jsonObject(with: data)
        Logger.clientLogger.debug("Data was \(debugPrintObject.debugDescription)")
        let decoder = JSONDecoder()
        if let decodedData = self.decodeData(data, type: endpoint.returnType.self) {
            return decodedData
        }
        throw KomgaApiError.couldNotDecode
    }
    func decodeData<T: Codable>(_ data: Data, type: T.Type) -> T? {
        let decoder = JSONDecoder()
        let debugPrintObject = try? JSONSerialization.jsonObject(with: data)
        Logger.clientLogger.debug("Data was \(debugPrintObject.debugDescription)")
        if let fetchedData = try? decoder.decode(T.self, from: data) {
            Logger.clientLogger.debug("Data was: \(String(describing: fetchedData))")
            return fetchedData
        }
        return nil

    }
    func makeUrlRequest<T: Codable>(endpoint: KomgaAPIEndpoints, requestMethod: RequestMethod, body: [String: Any]? = nil, returnType: T.Type) async throws -> T? {
        guard let url = URL(string: "\(serverAddress)/api/v1/\(endpoint.rawValue)") else {
            throw KomgaApiError.badUrl
        }
        Logger.clientLogger.info("Getting url \(url.absoluteString)")
        var request = URLRequest(url: url)
        request = addHeadersToRequest(request: &request, method: requestMethod.rawValue)
        
        if requestMethod == .post || requestMethod == .patch {
            if body != nil {
                if let jsonData = try? JSONSerialization.data(withJSONObject: body!, options: []) {
                    request.httpBody = jsonData
                }
            }
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard response is HTTPURLResponse else {
            print("Could not interpret status")
            throw KomgaApiError.noResponseStatus
        }
        if requestMethod != .patch {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let debugPrintObject = try? JSONSerialization.jsonObject(with: data)
            Logger.clientLogger.debug("Data was \(debugPrintObject.debugDescription)")
            if let fetchedData = try? decoder.decode(T.self, from: data) {
                Logger.clientLogger.debug("Data was: \(String(describing: fetchedData))")
                return fetchedData
            }
            throw KomgaApiError.couldNotDecode
        }
        return nil
    }
    func getAllSeries() async -> AllSeries? {
        return await get(endpoint: .allSeries, type: AllSeries.self)
        
    }
    func getAllCollections() async -> AllCollections? {
        return await get(endpoint: .collections, type: AllCollections.self)
        
    }
        func getSingleSeries(seriesId: String) async -> Series? {
            return await get(endpoint: .singleSeries(id: seriesId), type: Series.self)
        }
    //    func getSeriesThumbnail(seriesId: String) async -> String? {
    //        let url = "api/v1/series/\(seriesId)/thumbnail"
    //        do {
    //            let baseUrl = try getBaseUrl()
    //            return "\(baseUrl)/\(url)"
    //        } catch {
    //            print(error.localizedDescription)
    //        }
    //        return nil
    //    }
    //    func getBooksForSeries(seriesId: String) async -> Books? {
    //        let url = "api/v1/series/\(seriesId)/books"
    //        let returnType = Books.self
    //        do {
    //            let result = try await makeRequest(url: url, requestMethod: .get, returnType: returnType)
    //            return result
    //        } catch {
    //            print(error.localizedDescription)
    //            return nil
    //        }
    //    }
    //    func getBookThumbnail(bookId: String) async -> String? {
    //        let url = "api/v1/books/\(bookId)/thumbnail"
    //        do {
    //            let baseUrl = try getBaseUrl()
    //            return "\(baseUrl)/\(url)"
    //        } catch {
    //            print(error.localizedDescription)
    //        }
    //        return nil
    //    }
    //    func getSingleBook(bookId: String) async -> Book? {
    //        let url = "api/v1/books/\(bookId)"
    //        let returnType = Book.self
    //        do {
    //            let result = try await makeRequest(url: url, requestMethod: .get, returnType: returnType)
    //            return result
    //        } catch {
    //            print(error.localizedDescription)
    //            return nil
    //        }
    //    }
    //    func getBookPageUrl(bookId: String, page: Int) -> String? {
    //        let url = "api/v1/books/\(bookId)/pages/\(page)"
    //        do {
    //            let baseUrl = try getBaseUrl()
    //            return "\(baseUrl)/\(url)"
    //        } catch {
    //            print(error.localizedDescription)
    //        }
    //        return nil
    //    }
    //
    func setReadingProgress(bookId: String, page: Int, total: Int) async -> Int? {
        let result = await patch(endpoint: .bookProgress(id: bookId), type: String.self, id: bookId, page: page, total: total)
        let progress = await get(endpoint: .book(id: bookId), type: Book.self)
        return progress?.readProgress?.page
    }
    func getSeriesThumbnail(seriesId: String) -> String {
        return "\(serverAddress)/api/v1/series/\(seriesId)/thumbnail"
    }
    func getBookThumbnail(bookId: String) -> String {
        return "\(serverAddress)/api/v1/books/\(bookId)/thumbnail"
    }
    func getBookPageUrl(bookId: String, page: Int) -> String {
        return "\(serverAddress)/api/v1/books/\(bookId)/pages/\(page)"
    }
    func getTags(seriesList: [Series]) -> [String] {
        let tagList = seriesList.map { series in
            return series.metadata.tags
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
