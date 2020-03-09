//
//  LeftMenuViewController.swift
//  Notes
//
//  Created by Илья Бочков  on 3/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit
import WebKit

class LeftMenuViewController: UIViewController, UIGestureRecognizerDelegate, TokenDelegate {
    
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
        token.loadTokenFromFile()
        if token.token != nil {
            loginButton.isEnabled = false
        } else {
            exitButton.isEnabled = false
        }
    }
    
    @objc func hideLeftMenu() {
        delegate?.toggleMenu()
    }
    @IBAction func loginButtonTupped(_ sender: UIButton) {
        let authorizationViewController = AuthorizationViewController()
        authorizationViewController.delegate = self
        present(authorizationViewController, animated: true, completion: nil)
    }
    
    @IBAction func exitButtonTupped(_ sender: Any) {
        token.deleteTokenFile()
        loginButton.isEnabled = !loginButton.isEnabled
        exitButton.isEnabled = !exitButton.isEnabled
        loginLabel.text = ""
    }
    
    func handleTokenChanged(newToken: String) {
        token.token = newToken
        token.saveTokenToFile()
        loginLabel.text = token.token
        loginButton.isEnabled = !loginButton.isEnabled
        exitButton.isEnabled = !exitButton.isEnabled
    }
}
