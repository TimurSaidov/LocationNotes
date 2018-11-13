//
//  FolderTableViewCell.swift
//  LocationNotes
//
//  Created by Timur Saidov on 13/11/2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class FolderTableViewCell: UITableViewCell {

    @IBOutlet weak var noteImageView: UIImageView!
    @IBOutlet weak var noteNameLabel: UILabel!
    @IBOutlet weak var noteDateUpdateLabel: UILabel!
    @IBOutlet weak var noteLocationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
