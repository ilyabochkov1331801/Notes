//
//  LeftMenuViewController.swift
//  Notes
//
//  Created by Илья Бочков  on 3/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit
import WebKit

struct Gist: Codable {
    var owner: Owner
}

struct Owner: Codable {
    let login: String
}

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
        loginLabel.text = "Your login"
    }
    
    func getLogin() {
        let gitUrl = "https://api.github.com/gists"
        guard let url = URL(string: gitUrl) else { return }
        var request = URLRequest(url: url)
        guard let token = token.token else { return }
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let gists: Array<Gist> = try? JSONDecoder().decode(Array<Gist>.self, from: data!) else { return }
            OperationQueue.main.addOperation {
                self?.loginLabel.text = gists.first?.owner.login
            }
        }.resume()
    }
    
    func handleTokenChanged(newToken: String) {
        token.token = newToken
        token.saveTokenToFile()
        getLogin()
        loginButton.isEnabled = !loginButton.isEnabled
        exitButton.isEnabled = !exitButton.isEnabled
    }
}
