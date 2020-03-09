//
//  TokenDelegate.swift
//  Notes
//
//  Created by Илья Бочков  on 3/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

protocol TokenDelegate {
    func handleTokenChanged(newToken: String)
}
