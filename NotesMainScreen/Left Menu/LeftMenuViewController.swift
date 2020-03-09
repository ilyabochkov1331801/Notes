//
//  LeftMenuViewController.swift
//  Notes
//
//  Created by Илья Бочков  on 3/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var delegate: LeftMenuDelegate?
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    
    let token: Token = Token()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(hideLeftMenu))
        swipeLeft.delegate = self
        swipeLeft.direction =  UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func hideLeftMenu() {
        delegate?.toggleMenu()
    }
    @IBAction func loginButtonTupped(_ sender: UIButton) {
        token.token = "token"
        token.saveTokenToFile()
    }
    
    @IBAction func exitButtonTupped(_ sender: Any) {
        token.deleteTokenFile()
    }
}
