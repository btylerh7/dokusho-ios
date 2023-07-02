//
//  OCRManager.swift
//  Dokusho
//
//  Created by Tyler Baker on 4/8/23.
//

import Foundation
import UIKit


class OcrWord: Codable {
    let boundingBox: String
    let text: String
    
}

class OcrResult: Codable {
    let language: String
    let textAngle: Float?
    let orientation: String?
    let regions: [OcrRegion]
}

class OcrRegion: Codable {
    let boundingBox: String
    let lines: [OcrLine]
}

class OcrLine: Codable {
    let boundingBox: String
    let words: [OcrWord]
}

final public class OCRManager {
    
    static let shared = OCRManager()
//    func extractTextFromUrl(image: String) throws {
//        let ocr = Tesseract(language: .custom("jpn_vert"))
//        guard let url = URL(string: image) else {return}
//        Task {
//            let imageData = try Data(contentsOf: url)
//            let result: Result<String, Tesseract.Error> = ocr.performOCR(on: imageData)
//            switch result {
//            case .success(let text):
//                print(text)
//            case .failure(let error):
//                print(String(describing: error))
//            }
//        }
//    }
//    func extractTextFromImage(image: UIImage) -> String {
//        let ocr = Tesseract(language: RecognitionLanguage.custom("jpn_vert2"))
//
//        var finalResult: String = ""
//        let result: Result<String, Tesseract.Error> = ocr.performOCR(on: image)
//        switch result {
//        case .success(let text):
//            finalResult = cleanOutput(text)
//            print("tesseract text is \(finalResult)")
//        case .failure(let error):
//            print(String(describing: error))
//            finalResult = String(describing: error)
//        }
//        return finalResult
//    }
    
    //https://github.com/juanj/KantanManga/blob/development/MangaReader/OCR/TesseractOCR.swift
    func cleanOutput(_ output: String) -> String {
        var notAllowed = CharacterSet.decimalDigits // Remove numbers
        notAllowed.formUnion(CharacterSet("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ".unicodeScalars)) // And latin characters
        notAllowed.formUnion(CharacterSet(#"-_/\()|〔〕[]{}%:<>·"#.unicodeScalars)) // Some symbols
        let cleanUnicodeScalars = output.replacingOccurrences(of: "\n", with: "") // Make text one line
            .trimmingCharacters(in: .whitespacesAndNewlines) // Remove extra padding
            .unicodeScalars
            .filter { !notAllowed.contains($0) }
        return String(cleanUnicodeScalars)
    }
    
    func sendToApi(image: UIImage) async -> String?{
            var stringResult = ""
            let endpoint = "https://dokushou.cognitiveservices.azure.com/vision/v3.2/ocr"
            let subscriptionKey = "1e4b066eecfa41fb8be0a843da5fd66c"

            var request = URLRequest(url: URL(string: endpoint)!)
            request.httpMethod = "POST"
            request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
            request.addValue(subscriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")

            // Add image data to the request body
            let imageData = image.jpegData(compressionQuality: 1.0) ?? image.pngData()!
            request.httpBody = imageData
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                
                guard let responseJson = try? JSONSerialization.jsonObject(with: data, options: []) else {
                    print("Error: Could not decode JSON")
                    return nil
                }
                guard let json = try? JSONDecoder().decode(OcrResult.self, from: data) else {
                    print("Error: Could not decode JSON")
                    return nil
                }
                for region in json.regions {
                    for line in region.lines.reversed() {
                        for word in line.words {
                            stringResult += word.text
                        }
                    }
                }
                return stringResult
            } catch {
                print("Error: \(error.localizedDescription)")
                return nil
            }
        }
    
    
}
