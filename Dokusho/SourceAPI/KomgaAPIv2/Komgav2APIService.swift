//
//  Komgav2APIService.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import Foundation

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

public enum KomgaApiError: Error {
    case noBaseUrl
    case noServerUsername
    case noServerPassword
    case badUrl
    case badEndpoint(String)
    case noResponseStatus
    case badStatus(Int)
}

public enum RequestMethod: String {
    case post = "POST"
    case get = "GET"
    case delete = "DELETE"
    case patch = "PATCH"
}

public class ApiService {
    static let shared = ApiService()
    
    func getCredentials() throws -> (String, String) {
        guard let serverUsername = UserDefaults.standard.object(forKey: "komga-server-username") as? String else {
            throw KomgaApiError.noServerUsername
        }
        guard let serverPassword = UserDefaults.standard.object(forKey: "komga-server-password") as? String else {
            throw KomgaApiError.noServerPassword
        }
        return (serverUsername, serverPassword)
    }
    func makeUrl(endpoint: KomgaAPIEndpoints) throws -> URL {
        guard let baseUrl = UserDefaults.standard.object(forKey: "komga-server-address") as? String else {
            throw KomgaApiError.noBaseUrl
        }
        let urlString = "\(baseUrl)/api/v1/\(endpoint.rawValue)"
        guard let url = URL(string: urlString) else {
            throw KomgaApiError.badEndpoint(endpoint.rawValue)
        }
        return url
    }
    func getReturnType(endpoint: KomgaAPIEndpoints) async -> Codable.Type {
        switch endpoint {
        case .allSeries:
            return AllSeries.self
        case .singleSeries(_):
            return Series.self
            break
        case .seriesThumbnail(_):
            return String.self
            break
        case .seriesBooks(_):
            return Books.self
            break
        case .book(_):
            return Book.self
            break
        case .bookThumbnail(_):
            return String.self
            break
        case .bookPage(_,_):
            return String.self
        case .bookProgress(_):
            return String.self
            break // TODO: This isn't really a get
        case .collections:
            return AllCollections.self
            break
        case .collection(_):
            return Collection.self
        }
    }
    func get<T: Codable>(endpoint: KomgaAPIEndpoints, type: T.Type) async -> T? {
        return try? await makeRequest(endpoint: endpoint, requestMethod: .get, returnType: type)
    }
    func patch<T: Codable>(endpoint: KomgaAPIEndpoints, type: T.Type, id: String, page: Int? = nil, total: Int? = nil) async -> T? {
        guard case .bookProgress(_) = endpoint else {
            return nil
        }
        let completed = page == total ? true : false
        let returnType = await getReturnType(endpoint: endpoint)
        var body: [String: Any]
        if page != nil {
            body = [
                "page": page!,
                "completed": completed
            ]
            return try? await makeRequest(endpoint: endpoint, requestMethod: .patch, body: body, returnType: type)
        }
        return nil
    }
    
    private func makeRequest<T: Codable>(endpoint: KomgaAPIEndpoints, requestMethod: RequestMethod, body: [String: Any]? = nil, returnType: T.Type) async throws -> T? {
        let (serverUsername, serverPassword) = try getCredentials()
        let url = try makeUrl(endpoint: endpoint)
        var request = URLRequest(url: url)
        request.httpMethod = requestMethod.rawValue
        request.setValue("application/json",  forHTTPHeaderField: "Content-Type")
        let credentials = "\(serverUsername):\(serverPassword)".data(using: .utf8)?.base64EncodedString() ?? ""
        let authString = "Basic \(credentials)"
        request.setValue(authString, forHTTPHeaderField: "Authorization")
        if requestMethod == .post || requestMethod == .patch {
            if body != nil {
                if let jsonData = try? JSONSerialization.data(withJSONObject: body!, options: []) {
                    if requestMethod == .post || requestMethod == .patch {
                        request.httpBody = jsonData
                    }
                }
            }
        }
        let (data, response) = try await URLSession.shared.data(for: request)
//        let json = try? JSONSerialization.jsonObject(with: data)
//        print(json)
        guard let httpResponse = response as? HTTPURLResponse else {
            print("could not interpret status")
            throw KomgaApiError.noResponseStatus
        }
        guard httpResponse.statusCode == 200 else {
            throw KomgaApiError.badStatus(httpResponse.statusCode)
        }
        if requestMethod != .patch {
            let test = try! JSONSerialization.jsonObject(with: data, options: [])
            print("data:")
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let fetchedData = try! decoder.decode(T.self, from: data)
            
            return fetchedData
        }
        return nil
    }
    
    

}
public final class Komgav2APIService {
    static let shared = Komgav2APIService()

    
    private func makeRequest<T: Codable>(url: String, requestMethod: RequestMethod, body: [String: Any]? = nil, returnType: T.Type) async throws -> T? {
        guard let baseUrl = UserDefaults.standard.object(forKey: "komga-server-address") as? String else {
            throw KomgaApiError.noBaseUrl
        }
        guard let serverUsername = UserDefaults.standard.object(forKey: "komga-server-username") as? String else {
            throw KomgaApiError.noServerUsername
        }
        guard let serverPassword = UserDefaults.standard.object(forKey: "komga-server-password") as? String else {
            throw KomgaApiError.noServerPassword
        }
        guard let url = URL(string: "\(baseUrl)/\(url)") else {
            throw KomgaApiError.badUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = requestMethod.rawValue
        request.setValue("application/json",  forHTTPHeaderField: "Content-Type")
        let credentials = "\(serverUsername):\(serverPassword)".data(using: .utf8)?.base64EncodedString() ?? ""
        let authString = "Basic \(credentials)"
        request.setValue(authString, forHTTPHeaderField: "Authorization")
        if requestMethod == .post || requestMethod == .patch {
            if body != nil {
                if let jsonData = try? JSONSerialization.data(withJSONObject: body!, options: []) {
                    if requestMethod == .post || requestMethod == .patch {
                        request.httpBody = jsonData
                    }
                }
            }
        }
        let (data, response) = try await URLSession.shared.data(for: request)
//        let json = try? JSONSerialization.jsonObject(with: data)
//        print(json)
        guard let httpResponse = response as? HTTPURLResponse else {
            print("could not interpret status")
            throw KomgaApiError.noResponseStatus
        }
        guard httpResponse.statusCode == 200 else {
            throw KomgaApiError.badStatus(httpResponse.statusCode)
        }
        if requestMethod != .patch {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let fetchedData = try! decoder.decode(T.self, from: data)
            
            return fetchedData
        }
        return nil
    }
    
    func getBaseUrl() throws -> String {
        guard let baseUrl = UserDefaults.standard.object(forKey: "komga-server-address") as? String else {
            throw KomgaApiError.noBaseUrl
        }
        return baseUrl
    }
    func makeUrl(endpoint: KomgaAPIEndpoints) throws -> URL {
        let baseUrl = try getBaseUrl()
        let enpointString = endpoint.rawValue
        let fullUrl = "\(baseUrl)/api/v1/\(enpointString)"
        guard let url = URL(string: fullUrl) else {
            throw KomgaApiError.badEndpoint(enpointString)
        }
        return url
    }
    
    func getAllSeries() async -> AllSeries? {
        let url = "api/v1/series"
        let returnType = AllSeries.self
        do {
            let result = try await makeRequest(url: url, requestMethod: .get, returnType: returnType)
            return result
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
//    func getAllCollections() async -> AllCollections? {
//        let url = "api/v1/collections"
//    }
    func getSingleSeries(seriesId: String) async -> Series? {
        let url = "api/v1/series/\(seriesId)"
        let returnType = Series.self
        do {
            let result = try await makeRequest(url: url, requestMethod: .get, returnType: returnType)
            return result
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    func getSeriesThumbnail(seriesId: String) async -> String? {
        let url = "api/v1/series/\(seriesId)/thumbnail"
        do {
            let baseUrl = try getBaseUrl()
            return "\(baseUrl)/\(url)"
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    func getBooksForSeries(seriesId: String) async -> Books? {
        let url = "api/v1/series/\(seriesId)/books"
        let returnType = Books.self
        do {
            let result = try await makeRequest(url: url, requestMethod: .get, returnType: returnType)
            return result
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    func getBookThumbnail(bookId: String) async -> String? {
        let url = "api/v1/books/\(bookId)/thumbnail"
        do {
            let baseUrl = try getBaseUrl()
            return "\(baseUrl)/\(url)"
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    func getSingleBook(bookId: String) async -> Book? {
        let url = "api/v1/books/\(bookId)"
        let returnType = Book.self
        do {
            let result = try await makeRequest(url: url, requestMethod: .get, returnType: returnType)
            return result
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    func getBookPageUrl(bookId: String, page: Int) -> String? {
        let url = "api/v1/books/\(bookId)/pages/\(page)"
        do {
            let baseUrl = try getBaseUrl()
            return "\(baseUrl)/\(url)"
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func setReadingProgress(bookId: String, page: Int, total: Int) async -> String? {
        let url = "api/v1/books/\(bookId)/read-progress"
        let returnType = String.self
        let completed = page == total ? true : false
        let postBody: [String: Any] = [
            "page": page,
            "completed": completed
        ]
        do {
            let result = try await makeRequest(url: url, requestMethod: .patch, body: postBody, returnType: returnType)
            return nil
        } catch let KomgaApiError.badStatus(statusCode) {
            print("Error: Bad status - \(statusCode)")
            return nil
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
