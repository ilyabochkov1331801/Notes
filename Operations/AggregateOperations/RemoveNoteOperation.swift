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
    private let saveToBackend: SaveNotesBackendOperation
    private let dbQueue: OperationQueue
    private let backendQueue: OperationQueue
    
    private(set) var result: Bool? = false
    
    init(note: Note, notebook: FileNotebook, backendQueue: OperationQueue, dbQueue: OperationQueue) {
        
        removeFromDb = RemoveNoteBDOperation(note: note, notebook: notebook)
        self.dbQueue = dbQueue
        
        saveToBackend = SaveNotesBackendOperation(notes: notebook.getNoteCollection())
        self.backendQueue = backendQueue
        
        super.init()
        
        removeFromDb.completionBlock = {
            backendQueue.addOperation(self.saveToBackend)
        }
    }
        
    override func main() {
        dbQueue.addOperation(removeFromDb)
        finish()
    }
}
