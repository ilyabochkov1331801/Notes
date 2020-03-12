//
//  LoadNotesBackendOperation.swift
//  Notes
//
//  Created by Илья Бочков  on 3/1/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation
import CocoaLumberjack

enum LoadNotesBackendResult {
    case success
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
    var result: SaveNotesBackendResult?
        
    override func main() {
        guard !isCancelled, let token = token else {
            result = .failure(.unreachable)
            finish()
            return
        }
        guard let newNotes = getNotes(token: token) else {
            result = .failure(.unreachable)
            DDLogInfo("Data not downloaded")
            finish()
            return
        }
        notebook.removeAll()
        for note in newNotes.getNoteCollection() {
            do {
                try notebook.add(note)
            } catch { }
        }
        result = .success
        DDLogInfo("Data downloaded successfully")
        finish()
    }
    
    func fileRawUrl(token: String) -> String? {
        guard let url = URL(string: "https://api.github.com/gists") else {
            return nil
        }
        var request = URLRequest(url: url)
        var fileRawUrl: String? = nil
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        let semaphore = DispatchSemaphore(value: 1)
        let dataTask = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard error == nil else {
                semaphore.signal()
                return
            }
            guard let data = data else {
                semaphore.signal()
                return
            }
            guard let gists = try? JSONDecoder().decode(Array<Gist>.self, from: data) else {
                semaphore.signal()
                return
            }
            for gist in gists {
                if let file = gist.files["ios-course-notes-db"] {
                    fileRawUrl = file.raw_url
                    break
                }
            }
            semaphore.signal()
        }
        semaphore.wait()
        dataTask.resume()
        semaphore.wait()
        semaphore.signal()
        return fileRawUrl
    }
    
    func getNotes(token: String) -> FileNotebook? {
        guard let fileRawUrl = fileRawUrl(token: token) else {
            return nil
        }
        guard let url = URL(string: fileRawUrl) else {
            return nil
        }
        var notes: FileNotebook? = nil
        var request = URLRequest(url: url)
        request.addValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let semaphore = DispatchSemaphore(value: 1)
        let urlSession = URLSession(configuration: .ephemeral)
        let loadNotesDataTask = urlSession.dataTask(with: request) {
            (data, response, error) in
            guard error == nil else {
                semaphore.signal()
                return
            }
            guard let response = response as? HTTPURLResponse else {
                semaphore.signal()
                return
            }
            switch response.statusCode {
            case 200...300:
                if let arrayOfJsons = try? JSONSerialization.jsonObject(with: data!, options: []) as? [[String: Any]] {
                    notes = FileNotebook()
                    arrayOfJsons.forEach {
                        guard let note = Note.parse(json: $0) else {
                            semaphore.signal()
                            return
                        }
                        do {
                            try notes!.add(note)
                        } catch { }
                    }
                }
                semaphore.signal()
            default:
                semaphore.signal()
                return
            }
        }
        semaphore.wait()
        loadNotesDataTask.resume()
        semaphore.wait()
        semaphore.signal()
        return notes
    }
}
