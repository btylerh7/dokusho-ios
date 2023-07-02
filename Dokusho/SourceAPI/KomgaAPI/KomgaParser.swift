//
//  KomgaParser.swift
//  Dokusho
//
//  Created by Tyler Baker on 5/14/23.
//

import Foundation

final class KomgaParser {
    func parseMangaDetails(json: KomgaMangaDetailsResult, mangaId: String, sourceId: String, baseUrl: String) throws -> MangaDetails {
        let title = json.metadata.title
        let description = json.metadata.summary
        let author = json.booksMetadata.authors.first?.name ?? ""
        let image = "\(baseUrl)/api/v1/series/\(mangaId)/thumbnail"
        return MangaDetails(sourceId: sourceId, mangaId: mangaId, title: title, image: image, description: description, author: author)
    }
    func parseMangaChapters(json: KomgaChaptersResultsV2, mangaId: String, sourceId: String) throws -> [Chapter]{
        var chapters: [Chapter] = []
        for chapter in json.content {
            let chapterObject = Chapter(mangaId: mangaId, chapterId: chapter.id, chapNum: Float(chapter.metadata.numberSort), chapNumString: String(chapter.metadata.numberSort))
            chapters.append(chapterObject)
        }
        return chapters
    }
    func parseChapterDetails(json: [KomgaBookPage], mangaId: String, sourceId: String, chapterId: String, baseUrl: String) throws -> ChapterDetails {
        var pages:[ChapterPage] = []
        
        for i in 1...json.count {
            let pageUrl = "\(baseUrl)/api/v1/books/\(chapterId)/pages/\(i)"
            print(pageUrl)
            let chapterPage = ChapterPage(link: pageUrl, page: String(i))
            pages.append(chapterPage)
        }
        
        return ChapterDetails(chapterId: chapterId, pages: pages)
    }
    
    func parseHomepageResults(json: KomgaHomepageResults, sourceId: String, baseUrl: String) throws -> [MangaTile] {
        var tiles: [MangaTile] = []
        for tile in json.content {
            let mangaId = tile.id
            let title = tile.metadata.title
            let image = "\(baseUrl)/api/v1/series/\(mangaId)/thumbnail"
            let currentTile = MangaTile(sourceId: sourceId, mangaId: mangaId, title: title, image: image)
            tiles.append(currentTile)
        }
        return tiles
    }

}
