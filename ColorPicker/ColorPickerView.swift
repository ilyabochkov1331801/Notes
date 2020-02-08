//
//  ColorPickerView.swift
//  Notes
//
//  Created by Илья Бочков  on 2/8/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

@IBDesignable
class ColorPickerView: UIView {
    
    var view: UIView!
    var nibName = "ColorPickerView"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupVews()
    }

    private func setupVews() {
        view = loadViewFromXib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }

    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    @IBOutlet weak var currentColor: UIView!
    @IBOutlet weak var gradientView: GradientView!
    
//    @IBAction func chouseColor(_ sender: UIPanGestureRecognizer) {
//        if sender.state == UIGestureRecognizer.State.began {
//            weak var colorCircle: UIView!
//            colorCircle?.frame = CGRect(x: sender.location(in: gradientView).x,
//                                        y: sender.location(in: gradientView).y,
//                                        width: 5,
//                                        height: 5)
//            colorCircle?.backgroundColor = gradientView.getColorAtPoint(point: CGPoint(x: sender.location(in: gradientView).x,
//                                                                                       y: sender.location(in: gradientView).y))
//            self.addSubview(colorCircle)
//        }
//    }
}
