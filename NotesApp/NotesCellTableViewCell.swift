//
//  ContentView.swift
//  new
//
//  Created by MacStudent on 2020-01-23.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit

class NotesCellTableViewCell: UITableViewCell {

    
    @IBOutlet weak var notesTitle: UILabel!
    @IBOutlet weak var notesDate: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
