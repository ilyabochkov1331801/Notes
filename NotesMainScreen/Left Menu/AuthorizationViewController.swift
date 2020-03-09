//
//  AuthorizationViewController.swift
//  Notes
//
//  Created by Илья Бочков  on 3/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit
import WebKit

struct AccessToken: Codable {
    var access_token: String
}

class AuthorizationViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var delegate: TokenDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        guard let request = tokenGetRequest else { return }
        webView.load(request)
    }
    
    private var tokenGetRequest: URLRequest? {
        guard var urlComponents = URLComponents(string: "https://github.com/login/oauth/authorize") else {
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "Iv1.3a51459ced2d9937"),
            URLQueryItem(name: "scope", value: "gist")
        ]
        guard let url = urlComponents.url else { return nil }
        return URLRequest(url: url)
    }
}

extension AuthorizationViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme == "notes" {
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let urlComponents = URLComponents(string: targetString) else { return }
            if let code = urlComponents.queryItems?.first(where: { $0.name == "code" })?.value {
                getToken(withCode: code)
            }
        }
        decisionHandler(.allow)
    }
    
    func getToken(withCode code: String) {
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
        URLSession.shared.dataTask(with: request) { [weak self]
            (data, response, error) in
            guard let accessToken = try? JSONDecoder().decode(AccessToken.self, from: data!) else { return }
            OperationQueue.main.addOperation {
                self?.delegate?.handleTokenChanged(newToken: accessToken.access_token)
                self?.dismiss(animated: true, completion: nil)
            }
        }.resume()
    }
}


