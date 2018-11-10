//
//  FoldersTableViewCell.swift
//  LocationNotes
//
//  Created by Timur Saidov on 10/11/2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class FoldersTableViewCell: UITableViewCell {

    @IBOutlet weak var folderNameLabel: UILabel!
    @IBOutlet weak var notesCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
