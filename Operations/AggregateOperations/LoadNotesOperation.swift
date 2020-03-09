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
        
        let token = Token()
        token.loadTokenFromFile()
        
        loadFromDb.completionBlock = { [weak self] in
            
            guard let token = token.token else {
                self?.finish()
                return
            }
            
            let loadFromBackend = LoadNotesBackendOperation(notebook: notebook, token: token)

            loadFromBackend.completionBlock = {
                switch loadFromBackend.result! {
                case .success:
                    self?.result = true
                    self?.checkData(newNotebook: loadFromBackend.notebook)
                case .failure:
                    self?.result = false
                }
                self?.finish()
            }
            guard !loadFromBackend.isCancelled else {
                self?.finish()
                return
            }
            backendQueue.addOperation(loadFromBackend)
        }
    }
    
    private func checkData(newNotebook: FileNotebook?) {
        guard let notes = newNotebook?.getNoteCollection() else { return }
        for note in notes {
            do {
                try notebook.add(note)
            } catch {
            }
        }
        notebook.saveToFile()
    }
    
    override func main() {
        guard !loadFromDb.isCancelled else {
            finish()
            return
        }
        dbQueue.addOperation(loadFromDb)
    }
}
