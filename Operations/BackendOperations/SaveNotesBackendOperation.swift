//
//  SaveNotesBackendOperation.swift
//  Notes
//
//  Created by Илья Бочков  on 3/1/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation
import CocoaLumberjack

enum SaveNotesBackendResult {
    case success
    case failure(NetworkError)
}

class SaveNotesBackendOperation: BaseBackendOperation {
    var result: SaveNotesBackendResult?
    
    override func main() {
        guard !isCancelled, let token = token else {
            result = .failure(.unreachable)
            finish()
            return
        }
        switch notebook.saveToBackend(token: token) {
        case true:
            result = .success
        case false:
            result = .failure(.unreachable)
        }
        finish()
    }
}
