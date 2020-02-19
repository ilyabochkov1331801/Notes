//
//  PhotoNotebookModel.swift
//  Notes
//
//  Created by Илья Бочков  on 2/19/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class PhotoNotebook {
    private(set) var photes: Array<UIImage>
    
    init() {
        photes = []
    }
    
    func addPhoto(photo: UIImage) {
        photes.append(photo)
    }
}
