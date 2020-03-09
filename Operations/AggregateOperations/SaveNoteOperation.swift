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
    private let dbQueue: OperationQueue
    private let backendQueue: OperationQueue
    
    private(set) var result: Bool? = false
    
    init(note: Note, notebook: FileNotebook, backendQueue: OperationQueue, dbQueue: OperationQueue) {
        
        saveToDb = SaveNoteDBOperation(note: note, notebook: notebook)
        self.dbQueue = dbQueue
        self.backendQueue = backendQueue

        super.init()
        
        let token = Token()
        token.loadTokenFromFile()
        
        saveToDb.completionBlock = { [weak self] in
            guard let token = token.token else {
                self?.finish()
                return
            }
            let saveToBackend = SaveNotesBackendOperation(notebook: notebook, token: token)
            saveToBackend.completionBlock = {
                switch saveToBackend.result! {
                case .success:
                    self?.result = true
                case .failure:
                    self?.result = false
                }
                self?.finish()
            }
            guard !saveToBackend.isCancelled else {
                self?.finish()
                return
            }
            self?.backendQueue.addOperation(saveToBackend)
        }
    }
    
    override func main() {
        guard !saveToDb.isCancelled else {
            finish()
            return
        }
        dbQueue.addOperation(saveToDb)
    }
}
