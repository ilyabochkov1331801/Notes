//
//  ColorPickerDelegate.swift
//  Notes
//
//  Created by Илья Бочков  on 2/14/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit.UIColor

protocol ColorPickerDelegate: AnyObject {
    func setNewColor(color: UIColor?)
}
