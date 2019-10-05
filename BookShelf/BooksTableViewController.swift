//
//  BooksTableViewController.swift
//  BookShelf
//
//  Created by Артем Мартиросян on 19/06/2019.
//  Copyright © 2019 Артем Мартиросян. All rights reserved.
//

import UIKit

class BooksTableViewController: UITableViewController, BookCellDelegate {
    func checkmarkTapped(sender: BookCell) {
        if let indexPath = tableView.indexPath(for: sender){
            var book = books[indexPath.row]
            book.isComplete = !book.isComplete
            books[indexPath.row] = book
            tableView.reloadRows(at: [indexPath], with: .automatic)
            Book.saveBooks(books)
        }
    }
    
    var books = [Book]() {
        didSet{
            Book.saveBooks(books)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.rowHeight = 60.0
        if let savedBooks = Book.loadBooks() {
            books = savedBooks
        } else {
            books = Book.loadSampleBooks()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return books.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookCellIdentifier") as? BookCell else {fatalError("Could not dequeu a cell")}
        cell.delegate = self
        let book = books[indexPath.row]
        cell.titleLabel.text = book.title
        cell.isCompleteButton.isSelected = book.isComplete
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            books.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            Book.saveBooks(books)
    }
    }
    
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedBook = books.remove(at: fromIndexPath.row)
        books.insert(movedBook, at: to.row)
        tableView.reloadData()
    }

    @IBAction func unwindToBooksList(_ unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.identifier == "saveUnwind" else {return}
        let sourceViewController = unwindSegue.source as! BookViewController
    
        if let book = sourceViewController.book {
            if let selectedindexPath = tableView.indexPathForSelectedRow {
                books[selectedindexPath.row] = book
                tableView.reloadRows(at: [selectedindexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: books.count, section: 0)
                books.append(book)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        Book.saveBooks(books)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let bookViewController = segue.destination as! BookViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedBook = books[indexPath.row]
            bookViewController.book = selectedBook
        }
    }
        

        
    
}
