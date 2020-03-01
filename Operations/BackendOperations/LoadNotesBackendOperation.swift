//
//  LoadNotesBackendOperation.swift
//  Notes
//
//  Created by Илья Бочков  on 3/1/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

enum LoadNotesBackendResult {
    case success
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
    var result: SaveNotesBackendResult?
    
    override func main() {
        result = .failure(.unreachable)
        finish()
    }
}
