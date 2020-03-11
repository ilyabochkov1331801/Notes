//
//  LoadNotesOperation.swift
//  Notes
//
//  Created by Илья Бочков  on 3/1/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class LoadNotesOperation: AsyncOperation {
    private let loadNotesBackendOperation: LoadNotesBackendOperation
    private let dbQueue: OperationQueue
    private let backendQueue: OperationQueue
    private var notebook: FileNotebook
    
    private(set) var result: Bool? = false

    init(notebook: FileNotebook, backendQueue: OperationQueue, dbQueue: OperationQueue) {
        
        let token = Token()
        token.loadTokenFromFile()
        
        loadNotesBackendOperation = LoadNotesBackendOperation(notebook: notebook, token: token.token)
        self.dbQueue = dbQueue
        self.backendQueue = backendQueue
        self.notebook = notebook

        super.init()
        
        loadNotesBackendOperation.completionBlock = {
            [weak self] in
            guard let _self = self else { return }
            switch _self.loadNotesBackendOperation.result! {
                case .success:
                    self?.result = true
                    dbQueue.addOperation( self!.loadNotesBackendOperation.notebook.saveToFile )
                case .failure:
                   self?.result = false
                   dbQueue.addOperation(LoadNotesDBOperation(notebook: notebook))
            }
            self?.finish()
        }
    }
    
    override func main() {
        guard !loadNotesBackendOperation.isCancelled else {
            finish()
            return
        }
        backendQueue.addOperation(loadNotesBackendOperation)
    }
}
