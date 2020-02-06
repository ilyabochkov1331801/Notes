//
//  CGRectExtension.swift
//  Notes
//
//  Created by Илья Бочков  on 2/5/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

extension CGRect {
    var maxRadiusOfCircle: CGFloat {
        return min(height / 2, width / 2)
    }
}
