//
//  SourceAPIManager.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/29/23.
//

import Foundation
import JavaScriptCore
import WebKit


final public class SourceAPIManager {
    let sourceId: String
    var source: Source
    var sourceAPI: APIServiceProtocol
    init(sourceId: String) {
        self.sourceId = sourceId
        self.source = SourceManager.shared.getSourceFromId(sourceId: sourceId)
        switch sourceId {
        case "rawkuma":
            self.sourceAPI = RawkumaService()
            break
        case "monogatary":
            self.sourceAPI = MonogataryService()
            break
        case "manga18fx":
            self.sourceAPI = Manga18FXService()
            break
        case "manga1000":
            self.sourceAPI = Manga1000Service()
            break
        case "komga":
            self.sourceAPI = KomgaService()
            break
        default:
            self.sourceAPI = RawkumaService()
            break
        }
    }
    
    func getTitle() {
        
        
        
        
//
//        let result = getDetailsFunc?.call(withArguments: [])
//        print("result:")
//        print(result)
    }

    func callAsyncJSFunction() async -> String {
        let context = JSContext()
        let bundlePath = Bundle.main.path(forResource: "bundle", ofType: "js")!
        let bundleSource = try! String(contentsOfFile: bundlePath)
        context!.evaluateScript(bundleSource)
        
        let getDetailsFunc = context?.objectForKeyedSubscript("getMangaDetails")
        let webView = await WKWebView()
        let result = try? await webView.callAsyncJavaScript(getDetailsFunc!.toString()!, contentWorld: .defaultClient)
        return result as? String ?? ""
    }
}
