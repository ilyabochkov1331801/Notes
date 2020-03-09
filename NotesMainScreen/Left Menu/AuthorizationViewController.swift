//
//  AuthorizationViewController.swift
//  Notes
//
//  Created by Илья Бочков  on 3/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit
import WebKit

enum GithubScope: String {
  case user, gist
}

class AuthorizationViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var delegate: TokenDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let request = tokenGetRequest else { return }
        webView.load(request)
        webView.navigationDelegate = self

    }
    
    private var tokenGetRequest: URLRequest? {
        guard var urlComponents = URLComponents(string: "https://github.com/login/oauth/authorize") else {
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "Iv1.3a51459ced2d9937")
        ]
        guard let url = urlComponents.url else { return nil }
        return URLRequest(url: url)
    }
}

struct TokenStr: Codable {
    var access_token: String
}

extension AuthorizationViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme == "notes" {
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else { return }
            if let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                getToken(code: code)
            }
        }
        decisionHandler(.allow)
    }
    func getToken(code: String) {
        guard var urlComponents = URLComponents(string: "https://github.com/login/oauth/access_token") else {
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "Iv1.3a51459ced2d9937"),
            URLQueryItem(name: "client_secret", value: "d33fa0f93aa803bd36787df5f73d1d371dd0ce0e"),
            URLQueryItem(name: "code", value: code)
        ]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var newToken: String? = nil
        URLSession.shared.dataTask(with: request) { [weak self]
            (data, response, error) in
            guard let tokenStr = try? JSONDecoder().decode(TokenStr.self, from: data!) else { return }
            newToken = tokenStr.access_token
            self?.delegate?.handleTokenChanged(newToken: newToken!)
            OperationQueue.main.addOperation {
                self?.dismiss(animated: true, completion: nil)
            }
        }.resume()
    }
}


