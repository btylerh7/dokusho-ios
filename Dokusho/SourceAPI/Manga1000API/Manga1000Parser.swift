//
//  Manga1000Parser.swift
//  Dokusho
//
//  Created by Tyler Baker on 4/7/23.
//

import Foundation
import SwiftSoup

final public class Manga1000Parser {
    func parseMangaDetails(html: Document, mangaId: String, sourceId: String) throws -> MangaDetails {
        let body = html.body()!
        let title = try body.select("ul.manga-info > h3").text(trimAndNormaliseWhitespace: true)
//        print(try? body.select("ul.manga-info > h3"))
        let image = try body.select(".info-cover > img.thumbnail").attr("src")
        let description = try body.select("div.summary-content > p").text(trimAndNormaliseWhitespace: true)
        let author = "Unknown" // TODO: Add this
        let details = MangaDetails(sourceId: sourceId, mangaId: mangaId, title: title, image: image, description: description, author: author)
//        print("manga 1000 details: \(details)")
        return details
    }
    
    func parseMangaChapters(html: Document, mangaId: String, sourceId: String) throws -> [Chapter]{
        let mangaId = mangaId
        var chapters: [Chapter] = []
        let body = html.body()!
        let chapterList = try body.select("ul.list-chapters > a")

        for chapter in chapterList {
            let number = try chapter.attr("title").replacing("Chapter ", with: "") as NSString
            var href = try chapter.attr("href")
            let _ = href.removeFirst()
            chapters.append(Chapter(mangaId: mangaId, chapterId: href, chapNum: number.floatValue, chapNumString: number as String))
        }
        return chapters
    }
    
    func parseChapterDetails(html: Document, mangaId: String, sourceId: String, chapterId: String) throws -> ChapterDetails {
        var pages: [ChapterPage] = []
        let body = html.body()!
        let images = try body.select(".chapter-img")
        for i in 0..<images.count  {
            let pageUrl = try images[i].attr("data-src").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
            let pageNum = String(describing: i + 1)
            pages.append(ChapterPage(link: pageUrl, page: pageNum as String))
        }
        return ChapterDetails(chapterId: chapterId, pages: pages)
    }
    
    func parseSearchResults(html: Document, sourceId: String) throws -> [MangaTile] {
        
        //
        var results: [MangaTile] = []
        let body = html.body()!
        
        let resultsHtml = try body.select("div.thumb-item-flow.col-6.col-md-3")
        for result in resultsHtml {
            let mangaId = try result.select("div.thumb-wrapper").attr("data-id")
            
            let title = try result.select("div.thumb_attr > a").attr("title")
            let image = try result.select("div.thumb-wrapper > a > div > div.content").attr("data-bg")
            
            results.append(MangaTile(sourceId: sourceId, mangaId: String(mangaId), title: title, image: String(image)))
        }
        return results

    }
    func parseHomepageResults(html: Document, sourceId: String) throws -> [MangaTile] {
        var results: [MangaTile] = []
        let body = html.body()!
        
        let resultsHtml = try body.select("div.thumb-wrapper")
        for result in resultsHtml {
            let substringMangaId = try result.select("a").attr("href").replacing("/", with: "")
            var mangaId = ""
            mangaId.append(contentsOf: substringMangaId)
            
            // No titles for this source
            let title = ""
            let image = try result.select("a > div > div.content").attr("style")
                .replacing(/background-image: url\("/, with: "")
                .replacing(/"\);/, with: "")
            results.append(MangaTile(sourceId: sourceId, mangaId: mangaId, title: title, image: String(image)))
        }
        return results
    }
}
