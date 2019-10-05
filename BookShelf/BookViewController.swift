//
//  BookViewController.swift
//  BookShelf
//
//  Created by Артем Мартиросян on 19/06/2019.
//  Copyright © 2019 Артем Мартиросян. All rights reserved.
//

import UIKit

class BookViewController: UITableViewController {

    var book: Book?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var pagesTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    
    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
        isCompleteButton.isSelected = !isCompleteButton.isSelected
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let book = book {
            navigationItem.title = "Редактирование"
            titleTextField.text = book.title
            isCompleteButton.isSelected = book.isComplete
            authorTextField.text = book.author
            pagesTextField.text = String(book.pages)
        }
        updateSaveButtonState()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    
    func updateSaveButtonState() {
        let title = titleTextField.text ?? ""
        let author = authorTextField.text ?? ""
        saveButton.isEnabled = !title.isEmpty && !author.isEmpty
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else {return}
        
        let title = titleTextField.text ?? ""
        let isComplete = isCompleteButton.isSelected
        let author = authorTextField.text ?? ""
        let pages = Int(pagesTextField.text ?? "") ?? 0
        
        book = Book(title: title, author: author, pages: pages, isComplete: isComplete)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        guard let book = book else { return }
        let activityController = UIActivityViewController(activityItems: [book.title,book.author], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender
        
        present(activityController, animated: true, completion: nil)
    }

}
