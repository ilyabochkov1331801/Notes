//
//  PhotoNotesCollectionCell.swift
//  Notes
//
//  Created by Илья Бочков  on 2/19/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class PhotoNotesCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    func showData(image: UIImage) {
        contentView.layer.borderWidth = 1
        self.imageView.image = image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
