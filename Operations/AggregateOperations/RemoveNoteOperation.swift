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
        
        removeFromDb.completionBlock = { [weak self] in
            let saveToBackend = SaveNotesBackendOperation(notes: notebook.getNoteCollection())
            saveToBackend.completionBlock = {
                switch saveToBackend.result! {
                case .success:
                    self?.result = true
                case .failure:
                    self?.result = false
                }
                self?.finish()
            }
            self?.backendQueue.addOperation(saveToBackend)
        }
    }
        
    override func main() {
        guard !isCancelled else {
            finish()
            return
        }
        dbQueue.addOperation(removeFromDb)
    }
}
