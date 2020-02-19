//
//  NoteTwbleCell.swift
//  Notes
//
//  Created by Илья Бочков  on 2/18/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class NoteTableCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    public func showData(note: Note) {
        titleLabel.text = note.title
        contentLabel.text = note.content
        colorView.backgroundColor = note.color
        colorView.layer.borderWidth = 1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
