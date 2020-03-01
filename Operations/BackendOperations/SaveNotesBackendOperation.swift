//
//  SaveNotesBackendOperation.swift
//  Notes
//
//  Created by Илья Бочков  on 3/1/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

enum SaveNotesBackendResult {
    case success
    case failure(NetworkError)
}

class SaveNotesBackendOperation: BaseBackendOperation {
    var result: SaveNotesBackendResult?
    
    init(notes: [Note]) {
        super.init()
    }
    
    override func main() {
        result = .failure(.unreachable)
        finish()
    }
}
