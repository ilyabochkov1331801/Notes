//
//  ColorPickerViewController.swift
//  Notes
//
//  Created by Илья Бочков  on 2/8/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var gradientView: UIGradientView!
    @IBOutlet weak var colorIndicator: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var selectedColor: UIColor?
    let colorIndicatorSize: CGFloat = 20
    
    @IBAction func colorSelecting(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            colorIndicator.isHidden = false
        }
        if sender.state == .changed {
            colorIndicator.frame = colorIndecatorLocation(fingerLocation: sender.location(in: gradientView))
            selectedColor = gradientView.getColorAtPoint(point: sender.location(in: gradientView))
            selectedColorView.backgroundColor = selectedColor
            colorIndicator.backgroundColor = selectedColor
        }
    }
    @IBAction func goBack(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindSegue", sender: nil)
    }
    
    private func colorIndecatorLocation(fingerLocation: CGPoint) -> CGRect {
        return CGRect(x: fingerLocation.x - colorIndicatorSize / 2,
                      y: fingerLocation.y - colorIndicatorSize / 2,
                      width: colorIndicatorSize,
                      height: colorIndicatorSize)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorIndicator.isHidden = true
        colorIndicator.layer.borderWidth = 1
        colorIndicator.layer.cornerRadius = colorIndicatorSize
        selectedColorView.layer.cornerRadius = 10
        selectedColorView.backgroundColor = selectedColor
        gradientView.layer.borderWidth = 2
        selectedColorView.layer.borderWidth = 1
    }
}
