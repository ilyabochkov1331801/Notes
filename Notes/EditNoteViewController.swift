//
//  ViewController.swift
//  Notes
//
//  Created by Илья Бочков  on 1/29/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class EditNoteViewControllerr: UIViewController, UIGestureRecognizerDelegate {
    
    private var datePickerHightValue: CGFloat = 200
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var datePickerHight: NSLayoutConstraint!
    @IBOutlet weak var stackOfColorCell: UIStackView!
    @IBOutlet var colorCells: [UIColorCellView]!
    @IBOutlet weak var colorPickerCell: UIColorCellView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textField: UITextField!
    
    
    private var selectedColor: colorsIndex?
    enum colorsIndex: Int {
        case white = 0
        case green = 1
        case red = 2
        case selector = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date()
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboardOnSwipeDown))
        swipeDown.delegate = self
        swipeDown.direction =  UISwipeGestureRecognizer.Direction.down
        contentView.addGestureRecognizer(swipeDown)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateContentView(notification: )),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateContentView(notification: )),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
    }
    
    @objc func updateContentView(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any],
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else {
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification {
            scrollView.contentOffset = CGPoint(x: 0, y: keyboardFrame.height)
        } else {
            scrollView.contentOffset = .zero
        }
    }
    
    @IBAction func stackWithColorCellsTupped(_ sender: UITapGestureRecognizer) {
        let touchLocation = sender.location(in: stackOfColorCell)
        for (index, colorCell) in colorCells.enumerated() {
            if colorCell.isPointInView(point: touchLocation) {
               changeSelectColor(index: index, colorCell: colorCell)
            }
        }
    }
    @IBAction func destroyDatePickerChanged(_ sender: UISwitch) {
        if sender.isOn {
            datePickerHight.constant += datePickerHightValue
        } else {
            datePickerHight.constant -= datePickerHightValue
        }
    }
    @IBAction func colorPickerPressed(_ sender: UILongPressGestureRecognizer) {
        guard sender.state != .ended else { return }
        performSegue(withIdentifier: "toColorPickerVC", sender: nil)
    }
    @IBAction func unwindToMainScreen(segue: UIStoryboardSegue) {
        switch segue.identifier {
        case "unwindSegue":
            guard let scv = segue.source as? ColorPickerViewController else { return }
            image.isHidden = true
            colorPickerCell.backgroundColor = scv.selectedColor
            colorPickerCell.isSelected = false
            changeSelectColor(index: 3, colorCell: colorPickerCell)
        default:
            return
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    @objc func hideKeyboardOnSwipeDown() {
        view.endEditing(true)
    }
    private func changeSelectColor(index: Int, colorCell: UIColorCellView) {
        if let indexOfSelectedColor = selectedColor?.rawValue,
            indexOfSelectedColor != index {
            colorCells[indexOfSelectedColor].isSelected = false
        }
        colorCell.isSelected = !colorCell.isSelected
        selectedColor = colorsIndex.init(rawValue: index)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toColorPickerVC":
            guard let dvc = segue.destination as? ColorPickerViewController else { return }
            dvc.selectedColor = colorPickerCell.backgroundColor
        default:
            return
        }
    }
}

