//
//  LoadNotesDBOperation.swift
//  Notes
//
//  Created by Илья Бочков  on 3/1/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class LoadNotesDBOperation: BaseDBOperation {
    override func main() {
        notebook.loadFromFile()
        finish()
    }
}
