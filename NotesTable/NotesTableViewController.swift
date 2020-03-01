//
//  TableOfNotes.swift
//  Notes
//
//  Created by Илья Бочков  on 2/17/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {
    
    var notebook = FileNotebook()
    
    override func viewDidLoad() {
        title = "Notes"
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addNote))
        tableView.register(UINib(nibName: "NoteTableCell", bundle: nil), forCellReuseIdentifier: "NoteTableCell")
        let loadNotesOperation = LoadNotesOperation(notebook: notebook,
                                                    backendQueue: OperationQueue(),
                                                    dbQueue: OperationQueue())
        loadNotesOperation.main()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notebook.getNoteCollection().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notebook.getNoteCollection()[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableCell", for: indexPath) as! NoteTableCell
        cell.showData(note: note)
        return cell
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
    }
    
    @objc func addNote() {
        let editNoteVC = EditNoteViewController(nibName: nil, bundle: nil, notebook: notebook)
        navigationController?.pushViewController(editNoteVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removeNoteOperation = RemoveNoteOperation(note: notebook.getNoteCollection()[indexPath.row],
                                notebook: notebook,
                                backendQueue: OperationQueue(), dbQueue: OperationQueue())
            removeNoteOperation.main()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editNoteVC = EditNoteViewController(nibName: nil, bundle: nil, notebook: notebook)
        editNoteVC.putIndexOfNote(index: indexPath.row)
        navigationController?.pushViewController(editNoteVC, animated: true)
    }
}
