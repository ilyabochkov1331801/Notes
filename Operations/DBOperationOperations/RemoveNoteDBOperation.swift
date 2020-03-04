//
//  RemoveNoteDBOperation.swift
//  Notes
//
//  Created by Илья Бочков  on 3/1/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation
class RemoveNoteBDOperation: BaseDBOperation {
    
    private let note: Note
    
    init(note: Note,
         notebook: FileNotebook) {
        self.note = note
        super.init(notebook: notebook)
    }
    
    override func main() {
        guard !isCancelled else {
            finish()
            return
        }
        notebook.remove(with: note.uid)
        notebook.saveToFile()
        finish()
    }
}
