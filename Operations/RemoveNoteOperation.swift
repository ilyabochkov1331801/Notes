//
//  RemoveNoteOperation.swift
//  Notes
//
//  Created by Илья Бочков  on 3/1/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class RemoveNoteOperation: AsyncOperation {
    private let removeFromDb: RemoveNoteBDOperation
    private let removeFromBackend: RemoveNoteBackendperation
    private let dbQueue: OperationQueue
    private let backendQueue: OperationQueue
    
    private(set) var result: Bool? = false
    
    init(note: Note, notebook: FileNotebook, backendQueue: OperationQueue, dbQueue: OperationQueue) {
        
        removeFromDb = RemoveNoteBDOperation(note: note, notebook: notebook)
        self.dbQueue = dbQueue
        
        removeFromBackend = RemoveNoteBackendperation()
        self.backendQueue = backendQueue
        
        super.init()
            
        removeFromBackend.completionBlock = {
            switch self.removeFromBackend.result! {
            case .success:
                self.result = true
            case .failure:
                self.result = false
            }
            self.finish()
        }
    }
        
    override func main() {
        dbQueue.addOperation(removeFromDb)
        backendQueue.addOperation(removeFromBackend)
    }
}
