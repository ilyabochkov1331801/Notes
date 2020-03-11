//
//  SaveNotesBackendOperation.swift
//  Notes
//
//  Created by Илья Бочков  on 3/1/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation
import CocoaLumberjack

enum SaveNotesBackendResult {
    case success
    case failure(NetworkError)
}

class SaveNotesBackendOperation: BaseBackendOperation {
    var result: SaveNotesBackendResult?
    
    override func main() {
        guard !isCancelled, let token = token else {
            result = .failure(.unreachable)
            finish()
            return
        }
        if let gistId = gistId(token: token) {
            patch(token: token, gistId: gistId)
        } else {
            post(token: token)
        }
        finish()
    }
    
    func gistId(token: String) -> String? {
        guard let url = URL(string: "https://api.github.com/gists") else {
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        var gistId: String? = nil
        let semaphote = DispatchSemaphore(value: 1)
        let dataTask = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let data = data else {
                semaphote.signal()
                return
            }
            guard let gists = try? JSONDecoder().decode(Array<Gist>.self, from: data) else {
                semaphote.signal()
                return
            }
            for gist in gists {
                if gist.files["ios-course-notes-db"] != nil {
                    gistId = gist.id
                    break
                }
            }
            semaphote.signal()
        }
        semaphote.wait()
        dataTask.resume()
        semaphote.wait()
        semaphote.signal()
        return gistId
    }
    
    func patch(token: String, gistId: String) {
        guard let url = URL(string: "https://api.github.com/gists/\(gistId)") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let data = try? JSONSerialization.data(withJSONObject: notebook.getNoteCollection().map { $0.json }, options: []) else {
            return
        }
        let dataString = String(data: data, encoding: .utf8)
        guard let dataToWrite = try? JSONSerialization.data(withJSONObject: ["files" : ["ios-course-notes-db": ["filename" : "ios-course-notes-db", "content" : dataString]]], options: []) else {
            return
        }
        request.httpBody = dataToWrite
        URLSession.shared.dataTask(with: request).resume()
    }
    
    func post(token: String) {
        guard let url = URL(string: "https://api.github.com/gists") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let data = try? JSONSerialization.data(withJSONObject: notebook.getNoteCollection().map { $0.json }, options: []) else {
            return
        }
        let dataString = String(data: data, encoding: .utf8)
        guard let dataToWrite = try? JSONSerialization.data(withJSONObject: ["files": ["ios-course-notes-db": ["content": dataString ]]], options: []) else {
            return
        }
        request.httpBody = dataToWrite
        URLSession.shared.dataTask(with: request).resume()
    }
}
