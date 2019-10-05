//
//  Book.swift
//  BookShelf
//
//  Created by Артем Мартиросян on 19/06/2019.
//  Copyright © 2019 Артем Мартиросян. All rights reserved.
//

import Foundation

struct Book: Codable {
    var title: String
    var author: String
    var pages: Int
    var isComplete: Bool
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("books").appendingPathExtension("plist")
    
    static func loadBooks() -> [Book]? {
        guard let codedBooks = try? Data(contentsOf: archiveURL) else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Book>.self, from: codedBooks)
    }
    
    static func saveBooks(_ books: [Book]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedBooks = try? propertyListEncoder.encode(books)
        try? codedBooks?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadSampleBooks() -> [Book] {
        let book1 = Book(title: "1984", author: "Дж.Оруэлл", pages: 320, isComplete: true)
        let book2 = Book(title: "О дивный новый мир", author: "О.Хаксли", pages: 400, isComplete: true)
        let book3 = Book(title: "Бегство от свободы", author: "Э.Фромм", pages: 210, isComplete: false)
        return [book1, book2, book3]
    }

}

