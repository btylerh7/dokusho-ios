//
//  MangaLoveParser.swift
//  Dokusho
//
//  Created by Tyler Baker on 4/3/23.
//

import Foundation
import SwiftSoup

public class MangaLoveParser {
    func parseMangaDetails(html: Document, mangaId: String, sourceId: String) throws -> MangaDetails {
        let body = html.body()!
        let title = try body.select("div#post-data > h1").first()?.text(trimAndNormaliseWhitespace: true).replacing("(Raw – Free)", with: "")
        let image = try body.select("div#post-data img").attr("src")
        let description = try body.select("div#post-content > p").last()?.text(trimAndNormaliseWhitespace: true)
        let author = "Unknown"
        
        return MangaDetails(sourceId: sourceId, mangaId: mangaId, title: title ?? "", image: image, description: description ?? "", author: author)
    }
    
    func parseMangaChapters(html: Document, mangaId: String, sourceId: String) throws -> [Chapter]{
        let chapters: [Chapter] = []
        let body = html.body()!
        
        let chapterList = try body.select("table.table > tbody")
        
        for chapter in chapterList {
            let substring = try chapter.select("a").attr("title").split(separator: "【").last?.replacing("】", with: "")
            let title = (String(describing: substring))
            let chapterId = try chapter.select("a").attr("href").split(separator: "chapters/").last?.replacing("/", with: "")
            let chapNum = Float(title.replacing(/第|話/, with: ""))
            let chapNumString = String(describing: chapNum)
            
            let chapter = Chapter(mangaId: mangaId, chapterId: String(describing: chapterId), chapNum: chapNum ?? 0, chapNumString: chapNumString)
        }
        
        return chapters
    }
    
    func parseChapterDetails(html: Document, mangaId: String, sourceId: String, chapterId: String) throws -> ChapterDetails {
        let body = html.body()!
        var pages: [ChapterPage] = []
        let pagesList = try body.select("div.container-chapter-reader").first()!.getElementsByTag("img")
        
        for page in 0..<pagesList.count {
            let link = try pagesList[page].attr("data-src")
            let pageNum = String(describing: page + 1)
            let chapterPage = ChapterPage(link: link, page: pageNum)
            pages.append(chapterPage)
        }
        return ChapterDetails(chapterId: chapterId, pages: pages)
    }
    
    func parseSearchResults(html: Document, sourceId: String) throws -> [MangaTile] {
        var results: [MangaTile] = []
        let body = html.body()!
        let homepageResults = try body.select(".post-list .item")
        for result in homepageResults {
            let image = try result.getElementsByTag("img").first()!.attr("data-src")
            let mangaId = try result.select("a").attr("href").replacing(/https:\/\/mangalove.top\//, with: "").replacing("/", with: "")
            let title = try result.select("a > h3").text(trimAndNormaliseWhitespace: true).replacing("(Raw – Free)", with: "")
            let mangaTile = MangaTile(sourceId: sourceId, mangaId: mangaId, title: title, image: image)
            results.append(mangaTile)
        }
        return results
    }
    
    func parseHomepageResults(html: Document, sourceId: String) throws -> [MangaTile] {
        var results: [MangaTile] = []
        let body = html.body()!
        let homepageResults = try body.select(".post-list .item")
        print("homepage results found: \(homepageResults.count)")
        for result in homepageResults {
            let image = try result.getElementsByTag("img").first()!.attr("data-src")
            let mangaId = try result.select("a").attr("href").replacing(/https:\/\/mangalove.top\//, with: "").replacing("/", with: "")
            let title = try result.select("a > h3").text(trimAndNormaliseWhitespace: true).replacing("(Raw – Free)", with: "")
            let mangaTile = MangaTile(sourceId: sourceId, mangaId: mangaId, title: title, image: image)
            results.append(mangaTile)
        }
        print("Results: \(String(describing: results))")
        return results
    }
}
