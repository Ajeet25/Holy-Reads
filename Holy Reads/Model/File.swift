//
//  File.swift
//  Holy Reads
//
//  Created by mac-14 on 17/10/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let homeModel = try HomeModel(json)

import Foundation

// MARK: - HomeModel
class HomeModel: Codable {
    let categories: [Category]?
    let latest, mostPopular, curatedList: [CuratedList]?
    
    enum CodingKeys: String, CodingKey {
        case categories, latest
        case mostPopular
        case curatedList
    }
    
    init(categories: [Category]?, latest: [CuratedList]?, mostPopular: [CuratedList]?, curatedList: [CuratedList]?) {
        self.categories = categories
        self.latest = latest
        self.mostPopular = mostPopular
        self.curatedList = curatedList
    }
}

// MARK: HomeModel convenience initializers and mutators

extension HomeModel {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(HomeModel.self, from: data)
        self.init(categories: me.categories, latest: me.latest, mostPopular: me.mostPopular, curatedList: me.curatedList)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        categories: [Category]?? = nil,
        latest: [CuratedList]?? = nil,
        mostPopular: [CuratedList]?? = nil,
        curatedList: [CuratedList]?? = nil
        ) -> HomeModel {
        return HomeModel(
            categories: categories ?? self.categories,
            latest: latest ?? self.latest,
            mostPopular: mostPopular ?? self.mostPopular,
            curatedList: curatedList ?? self.curatedList
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Category
class Category: Codable {
    let categoryID: Int?
    let title: String?
    let thumbnailImage: String?
    
    enum CodingKeys: String, CodingKey {
        case categoryID
        case title
        case thumbnailImage
    }
    
    init(categoryID: Int?, title: String?, thumbnailImage: String?) {
        self.categoryID = categoryID
        self.title = title
        self.thumbnailImage = thumbnailImage
    }
}

// MARK: Category convenience initializers and mutators

extension Category {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Category.self, from: data)
        self.init(categoryID: me.categoryID, title: me.title, thumbnailImage: me.thumbnailImage)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        categoryID: Int?? = nil,
        title: String?? = nil,
        thumbnailImage: String?? = nil
        ) -> Category {
        return Category(
            categoryID: categoryID ?? self.categoryID,
            title: title ?? self.title,
            thumbnailImage: thumbnailImage ?? self.thumbnailImage
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - CuratedList
class CuratedList: Codable {
    let bookID: Int?
    let bookTitle: String?
    let coverImage: String?
    let author: Author?
    let curatedListDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case bookID
        case bookTitle
        case coverImage
        case author
        case curatedListDescription
    }
    
    init(bookID: Int?, bookTitle: String?, coverImage: String?, author: Author?, curatedListDescription: String?) {
        self.bookID = bookID
        self.bookTitle = bookTitle
        self.coverImage = coverImage
        self.author = author
        self.curatedListDescription = curatedListDescription
    }
}

// MARK: CuratedList convenience initializers and mutators

extension CuratedList {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(CuratedList.self, from: data)
        self.init(bookID: me.bookID, bookTitle: me.bookTitle, coverImage: me.coverImage, author: me.author, curatedListDescription: me.curatedListDescription)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        bookID: Int?? = nil,
        bookTitle: String?? = nil,
        coverImage: String?? = nil,
        author: Author?? = nil,
        curatedListDescription: String?? = nil
        ) -> CuratedList {
        return CuratedList(
            bookID: bookID ?? self.bookID,
            bookTitle: bookTitle ?? self.bookTitle,
            coverImage: coverImage ?? self.coverImage,
            author: author ?? self.author,
            curatedListDescription: curatedListDescription ?? self.curatedListDescription
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

enum Author: String, Codable {
    case jKRowlings = "J. K. Rowlings"
    case safa = "safa"
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

