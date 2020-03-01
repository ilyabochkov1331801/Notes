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
    private let loadFromBackend: LoadNotesBackendOperation
    private let dbQueue: OperationQueue
    private let backendQueue: OperationQueue
    
    private(set) var result: Bool? = false

    init(notebook: FileNotebook, backendQueue: OperationQueue, dbQueue: OperationQueue) {
        
        loadFromDb = LoadNotesDBOperation(notebook: notebook)
        self.dbQueue = dbQueue
        
        loadFromBackend = LoadNotesBackendOperation()
        self.backendQueue = backendQueue

        super.init()
        
        loadFromBackend.completionBlock = {
            switch self.loadFromBackend.result! {
            case .success:
                self.result = true
            case .failure:
                self.result = false
            }
            self.finish()
        }
    }
    
    override func main() {
        dbQueue.addOperation(loadFromDb)
        backendQueue.addOperation(loadFromBackend)
    }
}
