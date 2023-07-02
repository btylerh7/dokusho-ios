//
//  Manga18FXParser.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/26/23.
//

import Foundation
import SwiftSoup

final class Manga18FXParser {
    func parseMangaDetails(html: Document, mangaId: String, sourceId: String) throws -> MangaDetails {
        let title = try html.body()!.select("div.post-title > h1").text(trimAndNormaliseWhitespace: true)
        let image = try html.body()!.select("div.summary_image > a > img").attr("data-src")
        let description = try html.body()!.select("div.dsct > p").text(trimAndNormaliseWhitespace: true)
        var author = try html.body()!.select("div.author-content > a").text(trimAndNormaliseWhitespace: true)
        if author == "" {
            author = "Unknown"
        }
        let details = MangaDetails(sourceId: sourceId, mangaId: mangaId, title: title, image: image, description: description, author: author)
        return details
    }
    
    func parseMangaChapters(html: Document, mangaId: String, sourceId: String) throws -> [Chapter]{
        let mangaId = mangaId
        var chapters: [Chapter] = []
        let chapterList = try html.body()!.getElementsByClass("a-h")
        
        for chapter in chapterList {
            let number = try chapter.select(".chapter-name.text-nowrap").text(trimAndNormaliseWhitespace: true).split(separator: " ")[1]
            var href = try chapter.select("a").attr("href").split(separator: "/")
            let chapterId = href.popLast()
            chapters.append(Chapter(mangaId: mangaId, chapterId: String(describing: chapterId!), chapNum: Float(number) ?? 0.0, chapNumString: String(number)))
        }
        return chapters
    }
    
    func parseChapterDetails(html: Document, mangaId: String, sourceId: String, chapterId: String) throws -> ChapterDetails {
        var pages: [ChapterPage] = []
        let images = try html.body()!.getElementsByClass("page-break")
        for i in 0..<images.count  {
            let pageUrl = try images[i].select("img").attr("data-src")
            print("page: \(pageUrl)")
            let pageNum = String(describing: i + 1)
            pages.append(ChapterPage(link: pageUrl, page: pageNum as String))
        }
        return ChapterDetails(chapterId: chapterId, pages: pages)
    }
    
    func parseSearchResults(html: Document, sourceId: String) throws -> [MangaTile] {
        var results: [MangaTile] = []
        
        let resultsHtml = try html.body()!.getElementsByClass("page-item")
        for result in resultsHtml {
            let substringMangaId = try result.select("div > div> a").attr("href").split(separator: "manga/")[1]
            var mangaId = ""
            mangaId.append(contentsOf: substringMangaId)
            let title = try result.select("div > div> a").attr("title")
            let image = try result.select("div > div > a > img").attr("data-src")
            
            results.append(MangaTile(sourceId: sourceId, mangaId: mangaId, title: title, image: image))
        }
        return results

    }
    func parseHomepageResults(html: Document, sourceId: String) throws -> [MangaTile] {
        var results: [MangaTile] = []
        
        let resultsHtml = try html.body()!.getElementsByClass("page-item")
        for result in resultsHtml {
            let substringMangaId = try result.select("div > div> a").attr("href").split(separator: "manga/")[1]
            var mangaId = ""
            mangaId.append(contentsOf: substringMangaId)
            let title = try result.select("div > div> a").attr("title")
            let image = try result.select("div > div > a > img").attr("data-src")
            
            results.append(MangaTile(sourceId: sourceId, mangaId: mangaId, title: title, image: image))
        }
        return results
    }
}
