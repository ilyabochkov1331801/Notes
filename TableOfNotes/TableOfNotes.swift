//
//  TableOfNotes.swift
//  Notes
//
//  Created by Илья Бочков  on 2/17/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class TableOfNotes: UITableViewController {
    
    var notebook = FileNotebook()
    
    override func viewDidLoad() {
        do {
            try notebook.add(Note(title: "title",
                                  content: "contentcontentcontentcontentcontentc",
                                  color: .red,
                                  importance: .important,
                                  selfDestructionDate: nil))
        } catch {
            return
        }
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addNote))
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notebook.getNoteCollection().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notebook.getNoteCollection()[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.imageView?.backgroundColor = note.color
        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = note.content
        cell.detailTextLabel?.numberOfLines = 5
        cell.contentView.layer.borderWidth = 1
        return cell
    }

    @objc func addNote() {
        let editNoteVC = EditNoteViewController(nibName: nil, bundle: nil, notebook: notebook)
        navigationController?.pushViewController(editNoteVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notebook.remove(with: notebook.getNoteCollection()[indexPath.row].uid)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editNoteVC = EditNoteViewController(nibName: nil, bundle: nil, notebook: notebook)
        editNoteVC.noteIndex = indexPath.row
        navigationController?.pushViewController(editNoteVC, animated: true)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
