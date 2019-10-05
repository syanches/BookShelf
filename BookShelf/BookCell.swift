//
//  BookCell.swift
//  BookShelf
//
//  Created by Артем Мартиросян on 19/06/2019.
//  Copyright © 2019 Артем Мартиросян. All rights reserved.
//

import UIKit

@objc protocol BookCellDelegate: class {
    func checkmarkTapped(sender: BookCell)
}

class BookCell: UITableViewCell {

    
    var delegate: BookCellDelegate?
    
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        delegate?.checkmarkTapped(sender: self)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
