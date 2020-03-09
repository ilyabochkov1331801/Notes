//
//  TableOfNotes.swift
//  Notes
//
//  Created by Илья Бочков  on 2/17/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    var notebook = FileNotebook()
    var delegate: LeftMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addNote))
        
        tableView.register(UINib(nibName: "NoteTableCell", bundle: nil), forCellReuseIdentifier: "NoteTableCell")
        
        let loadNotesOperation = LoadNotesOperation(notebook: notebook,
                                                    backendQueue: OperationQueue(),
                                                    dbQueue: OperationQueue())
        loadNotesOperation.completionBlock = { [weak self] in
            self?.tableView.reloadData()
        }
        OperationQueue().addOperation(loadNotesOperation)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(showLeftMenu))
        swipeRight.delegate = self
        swipeRight.direction =  UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc func showLeftMenu() {
        delegate?.toggleMenu()
    }
    
    @objc func addNote() {
        let editNoteVC = EditNoteViewController(notebook: notebook)
        navigationController?.pushViewController(editNoteVC, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notebook.getNoteCollection().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableCell", for: indexPath) as! NoteTableCell
        cell.showData(note: notebook.getNoteCollection()[indexPath.row])
        return cell
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removeNoteOperation = RemoveNoteOperation(note: notebook.getNoteCollection()[indexPath.row],
                                                          notebook: notebook,
                                                          backendQueue: OperationQueue(), dbQueue: OperationQueue())
            OperationQueue().addOperation(removeNoteOperation)
            removeNoteOperation.completionBlock = {
                OperationQueue.main.addOperation { tableView.deleteRows(at: [indexPath], with: .fade) }
            }
        } else if editingStyle == .insert { }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editNoteVC = EditNoteViewController(notebook: notebook, noteIndex: indexPath.row)
        navigationController?.pushViewController(editNoteVC, animated: true)
    }
}


