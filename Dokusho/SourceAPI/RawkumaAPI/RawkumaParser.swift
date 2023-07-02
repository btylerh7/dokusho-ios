//
//  RawkumaParser.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/16/23.
//
import SwiftSoup
import Foundation

final class RawkumaParser {
    func parseMangaDetails(html: Document, mangaId: String, sourceId: String) throws -> MangaDetails {
        let title = try html.body()!.select("h1.entry-title").text(trimAndNormaliseWhitespace: true)
        var image = try html.body()!.select(".thumb > img").attr("src")
        image = "https:\(image)"
        let description = try html.body()!.select("div.entry-content > p").text(trimAndNormaliseWhitespace: true)
        let authorSelector = "Author"
        var author = try html.body()!.select("div.fmed:contains(\(authorSelector)").select("span").text(trimAndNormaliseWhitespace: true)
        if author == "" {
            author = "Unknown"
        }
        let details = MangaDetails(sourceId: sourceId, mangaId: mangaId, title: title, image: image, description: description, author: author)
        return details
    }
    
    func parseMangaChapters(html: Document, mangaId: String, sourceId: String) throws -> [Chapter]{
        let mangaId = mangaId
        var chapters: [Chapter] = []
        let chapterList = try html.body()!.select("#chapterlist > ul > li")
        
        for chapter in chapterList {
            let number = try chapter.attr("data-num") as NSString
            let href = try chapter.select("a").attr("href")
            var chapterId = ""
            let stringId = href.split(separator: ".com/")[1]
            chapterId += stringId
            chapters.append(Chapter(mangaId: mangaId, chapterId: chapterId, chapNum: number.floatValue, chapNumString: number as String))
        }
        return chapters
    }
    
    func parseChapterDetails(html: Document, mangaId: String, sourceId: String, chapterId: String) throws -> ChapterDetails {
        var pages: [ChapterPage] = []
        let pagesSelector = "#readerarea"
        let images = try html.body()!.select(pagesSelector).first()!.getElementsByTag("img")
        print(images.count)
        for i in 0..<images.count  {
            var pageUrl = try images[i].attr("src")
            pageUrl.replace(/\ /, with: "%20")
            pageUrl = "https:\(pageUrl.replacing("localhost", with: ""))"
            let pageNum = String(describing: i + 1)
            pages.append(ChapterPage(link: pageUrl, page: pageNum as String))
        }
        return ChapterDetails(chapterId: chapterId, pages: pages)
    }
    
    func parseSearchResults(html: Document, sourceId: String) throws -> [MangaTile] {
        var results: [MangaTile] = []
        let resultsHtml = try html.body()!.getElementsByClass("bsx")
        for result in resultsHtml {
            let mangaIdSubstring = try result.select("a").attr("href").split(separator: "manga/")[1]
            var mangaId = ""
            mangaId += mangaIdSubstring
            let title = try result.select(".bigor > .tt").text(trimAndNormaliseWhitespace: true)
            let image = try result.select(".limit > img").attr("src")
            
            results.append(MangaTile(sourceId: sourceId ,mangaId: mangaId, title: title, image: image))
        }
        return results

    }
    func parseHomepageResults(html: Document, sourceId: String) throws -> [MangaTile] {
        var results: [MangaTile] = []
        
        let resultsHtml = try html.body()!.getElementsByClass("bsx")
        for result in resultsHtml {
            let substringMangaId = try result.select("a").attr("href").split(separator: "manga/")[1]
            var mangaId = ""
            mangaId.append(contentsOf: substringMangaId)
            let _ = mangaId.popLast()
            let title = try result.select(".bigor > .tt").text(trimAndNormaliseWhitespace: true)
            var image = try result.select(".limit > img").attr("src")
            image = "https:\(image)"
            
            results.append(MangaTile(sourceId: sourceId, mangaId: mangaId, title: title, image: image))
        }
        return results
    }
}
