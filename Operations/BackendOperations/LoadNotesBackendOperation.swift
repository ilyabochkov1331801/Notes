//
//  LoadNotesBackendOperation.swift
//  Notes
//
//  Created by Илья Бочков  on 3/1/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation
import CocoaLumberjack

enum LoadNotesBackendResult {
    case success
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
    var result: SaveNotesBackendResult?
        
    override func main() {
        guard !isCancelled else {
            finish()
            return
        }
        print(token)
        result = .failure(.unreachable)
        DDLogInfo("LoadNotesBackendOperation failured (\(NetworkError.unreachable))")
        finish()
    }
}
