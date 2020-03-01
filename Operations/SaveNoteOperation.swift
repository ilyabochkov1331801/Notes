//
//  SaveNoteOperation.swift
//  Notes
//
//  Created by Илья Бочков  on 3/1/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class SaveNoteOperation: AsyncOperation {
    private let saveToDb: SaveNoteDBOperation
    private let saveToBackend: SaveNotesBackendOperation
    private let dbQueue: OperationQueue
    private let backendQueue: OperationQueue
    
    private(set) var result: Bool? = false
    
    init(note: Note, notebook: FileNotebook, backendQueue: OperationQueue, dbQueue: OperationQueue) {
        
        saveToDb = SaveNoteDBOperation(note: note, notebook: notebook)
        self.dbQueue = dbQueue
        
        saveToBackend = SaveNotesBackendOperation(notes: notebook.getNoteCollection())
        self.backendQueue = backendQueue

        super.init()
        
        saveToBackend.completionBlock = {
            switch self.saveToBackend.result! {
            case .success:
                self.result = true
            case .failure:
                self.result = false
            }
            self.finish()
        }
    }
    
    override func main() {
        dbQueue.addOperation(saveToDb)
        backendQueue.addOperation(saveToBackend)
    }
}
