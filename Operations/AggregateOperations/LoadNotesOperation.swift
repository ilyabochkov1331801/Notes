//
//  LoadNotesOperation.swift
//  Notes
//
//  Created by Илья Бочков  on 3/1/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class LoadNotesOperation: AsyncOperation {
    private let loadFromDb: LoadNotesDBOperation
    private let dbQueue: OperationQueue
    private let backendQueue: OperationQueue
    private let notebook: FileNotebook
    
    private(set) var result: Bool? = false

    init(notebook: FileNotebook, backendQueue: OperationQueue, dbQueue: OperationQueue) {
        
        loadFromDb = LoadNotesDBOperation(notebook: notebook)
        self.dbQueue = dbQueue

        self.backendQueue = backendQueue
        
        self.notebook = notebook

        super.init()
        
        loadFromDb.completionBlock = { [weak self] in
            
            let loadFromBackend = LoadNotesBackendOperation()

            loadFromBackend.completionBlock = {
                switch loadFromBackend.result! {
                case .success:
                    self?.result = true
                    self?.checkData(notes: loadFromBackend.notes)
                case .failure:
                    self?.result = false
                }
                self?.finish()
            }
            backendQueue.addOperation(loadFromBackend)
        }
    }
    
    private func checkData(notes: Array<Note>?) {
        guard let notes = notes else { return }
        for note in notes {
            do {
                try notebook.add(note)
            } catch {
                
            }
        }
        notebook.saveToFile()
    }
    
    override func main() {
        dbQueue.addOperation(loadFromDb)
    }
}
