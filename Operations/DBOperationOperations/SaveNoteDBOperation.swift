//
//  SaveNoteDBOperation.swift
//  Notes
//
//  Created by Илья Бочков  on 3/1/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class SaveNoteDBOperation: BaseDBOperation {
    
    private let note: Note
    
    init(note: Note, notebook: FileNotebook) {
        self.note = note
        super.init(notebook: notebook)
    }
    
    override func main() {
        do {
            try notebook.add(note)
        } catch { }
        notebook.saveToFile()
        finish()
    }
}
