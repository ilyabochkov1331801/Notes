//
//  ViewController.swift
//  Notes
//
//  Created by Илья Бочков  on 1/29/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var datePickerHightValue: CGFloat = 200
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var datePickerHight: NSLayoutConstraint!
    @IBOutlet weak var stackOfColorCell: UIStackView!
    @IBOutlet var colorCells: [ColorCellView]!
    @IBOutlet weak var colorPickerCell: ColorCellView!
    @IBOutlet var colorPicker: UILongPressGestureRecognizer!
    var selectedColor: colorsIndex?
    @IBOutlet weak var image: UIImageView!
    
    enum colorsIndex: Int {
        case white = 0
        case green = 1
        case red = 2
        case selector = 3
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateContentView(notification: )),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateContentView(notification: )),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        colorPicker.minimumPressDuration = 1
    }
    
    
    @IBAction func stackWithColorCellsTupped(_ sender: UITapGestureRecognizer) {
        let touchLocation = sender.location(in: stackOfColorCell)
        for (index, colorCell) in colorCells.enumerated() {
            if colorCell.isPointInView(point: touchLocation) {
               changeSelectColor(index: index, colorCell: colorCell)
            }
        }
    }
    
    private func changeSelectColor(index: Int, colorCell: ColorCellView) {
        if let indexOfSelectedColor = selectedColor?.rawValue,
            indexOfSelectedColor != index {
            colorCells[indexOfSelectedColor].isSelected = false
        }
        colorCell.isSelected = !colorCell.isSelected
        selectedColor = colorsIndex.init(rawValue: index)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    @IBAction func destroyDatePickerChanged(_ sender: UISwitch) {
        if sender.isOn {
            datePickerHight.constant = datePickerHightValue
        } else {
            datePickerHight.constant = 0
        }
    }
    @IBAction func colorPickerPressed(_ sender: UILongPressGestureRecognizer) {
        guard sender.state != .ended else { return }
        performSegue(withIdentifier: "toCPViewController", sender: nil)
    }
    
    @IBAction func unwindToMainScreen(segue: UIStoryboardSegue) {
        guard segue.identifier == "unwindSegue" else { return }
        guard let scv = segue.source as? ColorPickerViewController else { return }
        image.isHidden = true
        colorPickerCell.backgroundColor = scv.selectedColor
        colorPickerCell.isSelected = false
        changeSelectColor(index: 3, colorCell: colorPickerCell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dvc = segue.destination as? ColorPickerViewController else { return }
        dvc.selectedColor = colorPickerCell.backgroundColor
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
            scrollView.contentOffset = CGPoint.zero
        }
    }
}

