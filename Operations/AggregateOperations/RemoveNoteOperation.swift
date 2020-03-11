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
    private let dbQueue: OperationQueue
    private let backendQueue: OperationQueue
    
    private(set) var result: Bool? = false
    
    init(note: Note, notebook: FileNotebook, backendQueue: OperationQueue, dbQueue: OperationQueue) {
        
        removeFromDb = RemoveNoteBDOperation(note: note, notebook: notebook)
        self.dbQueue = dbQueue
        
        self.backendQueue = backendQueue
        
        super.init()
        
        let token = Token()
        token.loadTokenFromFile()
        
        removeFromDb.completionBlock = {
            [weak self] in
            guard let token = token.token else {
                self?.finish()
                return
            }
            let saveToBackend = SaveNotesBackendOperation(notebook: notebook, token: token)
            self?.backendQueue.addOperation(saveToBackend)
            self?.finish()
        }
    }
        
    override func main() {
        guard !removeFromDb.isCancelled else {
            finish()
            return
        }
        dbQueue.addOperation(removeFromDb)
    }
}
