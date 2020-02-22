//
//  ViewController.swift
//  Notes
//
//  Created by Илья Бочков  on 1/29/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class EditNoteViewController: UIViewController, UIGestureRecognizerDelegate, ColorPickerDelegate {
        
    var notebook: FileNotebook
    private var selectedColor: UIColorCellView?
    private var noteIndex: Int?
    
    @IBOutlet weak var datePickerContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackOfColorCell: UIStackView!
    @IBOutlet var colorCells: [UIColorCellView]!
    @IBOutlet weak var colorPickerCell: UIColorCellView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var contentView: UIStackView!
    @IBOutlet weak var datePickerSwitch: UISwitch!
        
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, notebook: FileNotebook) {
        self.notebook = notebook
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit"
        datePicker.minimumDate = Date()
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        selectedColor = colorCells[0]
        colorCells[0].isSelected = true

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboardOnSwipeDown))
        swipeDown.delegate = self
        swipeDown.direction =  UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(swipeDown)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateContentView(notification: )),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateContentView(notification: )),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(save))
        if let index = noteIndex {
            textField.text = notebook.getNoteCollection()[index].title
            textView.text = notebook.getNoteCollection()[index].content
            image.isHidden = true
            print(notebook.getNoteCollection()[index].color)
            colorPickerCell.backgroundColor = notebook.getNoteCollection()[index].color
            changeSelectColor(colorCell: colorPickerCell)
            if let date = notebook.getNoteCollection()[index].selfDestructionDate {
                datePicker.date = date
            } else {
                datePickerSwitch.isOn = false
                datePickerContainerHeightConstraint.constant = 0
            }
        }
    }
    
    func putIndexOfNote(index: Int) {
        noteIndex = index
    }
    
    @objc func save() {
        view.endEditing(true)
        guard let title = textField.text, let content = textView.text, let color = selectedColor?.backgroundColor else { return }
        guard title != "", content != "" else {
            let alert = UIAlertController(title: "Enter title and content", message: "Title and content can't be empty", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
            return
        }
        let note: Note
        if datePickerSwitch.isOn {
            if let index = noteIndex {
                note = Note(uid: notebook.getNoteCollection()[index].uid,
                            title: title,
                            content: content,
                            color: color,
                            importance: .normal,
                            selfDestructionDate: datePicker.date)
            } else {
                note = Note(title: title,
                            content: content,
                            color: color,
                            importance: .normal,
                            selfDestructionDate: datePicker.date)
            }
        } else {
           if let index = noteIndex {
                note = Note(uid: notebook.getNoteCollection()[index].uid,
                            title: title,
                            content: content,
                            color: color,
                            importance: .normal)
            } else {
                note = Note(title: title,
                            content: content,
                            color: color,
                            importance: .normal)
            }
        }
        do {
            try notebook.add(note)
        } catch {
            navigationController?.popViewController(animated: true)
            return
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func updateContentView(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any],
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else {
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification {
            let inset = UIEdgeInsets(top: 0,
                                     left: 0,
                                     bottom: keyboardFrame.height - view.safeAreaInsets.bottom - 20,
                                     right: 0)
            scrollView.contentInset = inset
            scrollView.scrollIndicatorInsets = inset
        } else {
            scrollView.contentInset = .zero
            scrollView.scrollIndicatorInsets = .zero
        }
    }
    
    @objc func hideKeyboardOnSwipeDown() {
        view.endEditing(true)
    }
    
    @IBAction func colotCellsStackTapped(_ sender: UITapGestureRecognizer) {
        let touchLocation = sender.location(in: stackOfColorCell)
        for colorCell in colorCells {
            if colorCell.frame.contains(touchLocation) {
               changeSelectColor(colorCell: colorCell)
            }
        }
    }
    
    @IBAction func destroyDatePickerChanged(_ sender: UISwitch) {
        if sender.isOn {
            UIView.animate(withDuration: 0.5, animations: {
                self.datePickerContainerHeightConstraint.constant = 200
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.datePickerContainerHeightConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func colorPickerPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .recognized {
            let colorPicker = ColorPickerViewController()
            colorPicker.delegate = self
            colorPicker.selectedColor = colorPickerCell.backgroundColor
            navigationController?.pushViewController(colorPicker, animated: true)
        }
    }
    
    func setNewColor(color: UIColor?) {
        image.isHidden = true
        colorPickerCell.backgroundColor = color
        colorPickerCell.isSelected = false
        changeSelectColor(colorCell: colorPickerCell)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func changeSelectColor(colorCell: UIColorCellView) {
        selectedColor?.isSelected = false
        selectedColor = colorCell
        selectedColor?.isSelected = true
    }
}

