//
//  BaseDBOperation.swift
//  Notes
//
//  Created by Илья Бочков  on 3/1/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class BaseDBOperation: AsyncOperation {
    let notebook: FileNotebook
    
    init(notebook: FileNotebook) {
        self.notebook = notebook
        super.init()
    }
}
