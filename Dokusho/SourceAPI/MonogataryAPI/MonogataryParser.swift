//
//  MonogataryParser.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/25/23.
//

import Foundation
import SwiftSoup

final class MonogataryParser {
    func parseMangaDetails(json: MonogataryStoryDetails, mangaId: String, sourceId: String) throws -> MangaDetails {
        let title = json.storyTitle
        let image = json.backgroundImage
        let description = json.storySummary
        var author = json.nickname
        if author == "" || author == nil {
            author = "Unknown"
        }
        let details = MangaDetails(sourceId: sourceId, mangaId: mangaId, title: title, image: image, description: description, author: author!)
        return details
    }
    
    func parseMangaChapters(json: [MonogataryEpisode], mangaId: String, sourceId: String) throws -> [Chapter]{
        var chapters: [Chapter] = []
        
        for index in 0..<json.count {
            print(index)
            let number = index + 1
            let chapterId = json[index].episodeId
            chapters.append(Chapter(mangaId: mangaId, chapterId: chapterId, chapNum: Float(number), chapNumString:String(describing: number)))
        }
//        print("Chapters: \(chapters.count)")
        return chapters
    }
    
    func parseChapterDetails(json: MonogataryChapterDetails, mangaId: String, sourceId: String, chapterId: String) throws -> ChapterDetails {
        let pages: [ChapterPage] = []
        let text = json.episodeContents.episode
        return ChapterDetails(chapterId: chapterId, pages: pages, text: text)
    }
    
    func parseSearchResults(html: Document, sourceId: String) throws -> [MangaTile] {
        var results: [MangaTile] = []
        let resultsHtml = try html.body()!.getElementsByClass("bsx")
        for result in resultsHtml {
            let mangaId = try String(from: result.select("a").attr("href").split(separator: "manga/")[1] as! Decoder)
            let title = try result.select(".bigor > .tt").text(trimAndNormaliseWhitespace: true)
            let image = try result.select(".limit > img").attr("src")
            
            results.append(MangaTile(sourceId: sourceId ,mangaId: mangaId, title: title, image: image))
        }
        return results

    }
    func parseHomepageResults(json: MonogataryHomepageResults, sourceId: String) throws -> [MangaTile] {
        var results: [MangaTile] = []
        
        for result in json.storiesList {
            let mangaId = result.storyId
            let title = result.storyTitle
            let image = result.backgroundImage
            
            results.append(MangaTile(sourceId: sourceId, mangaId: mangaId, title: title, image: image))
        }
        return results
    }
}
