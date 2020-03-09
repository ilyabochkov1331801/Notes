//
//  BaseBackendOperation.swift
//  Notes
//
//  Created by Илья Бочков  on 3/1/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class BaseBackendOperation: AsyncOperation {
    let notebook: FileNotebook
    let token: String

    init(notebook: FileNotebook, token: String) {
        self.notebook = notebook
        self.token = token
        super.init()
    }
}
