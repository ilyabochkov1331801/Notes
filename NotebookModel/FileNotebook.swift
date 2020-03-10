import CocoaLumberjack
import Foundation

class FileNotebook {
    
    private var noteCollection: [Note]
    
    public init() {
        noteCollection = Array<Note>()
    }
    
    public func getNoteCollection() -> [Note] {
        return noteCollection
    }
    
    public func add(_ note: Note) throws {
        for (index, element) in noteCollection.enumerated() {
            if element.uid == note.uid {
                noteCollection[index] = note
                DDLogInfo("Note with id \(note.uid) is overwritten")
                throw FileNotebookErrors.addExistingNoteException
            }
        }
        noteCollection.append(note)
        DDLogInfo("Note with id \(note.uid) is added")
    }
    
    public func remove(with uid: String) {
        noteCollection.removeAll(where: { $0.uid == uid })
        DDLogInfo("Note with id \(uid) is removed")
    }
    
    func saveToBackend(token: String) -> Bool {
        
        let semaphote = DispatchSemaphore(value: 1)
        guard let url = URL(string: "https://api.github.com/gists") else {
            return false
        }
        var request = URLRequest(url: url)
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        var flag = true
        let dataTask = URLSession.shared.dataTask(with: request) {
            [weak self] (data, response, error) in
            guard let gists = try? JSONDecoder().decode(Array<Gist>.self, from: data!) else {
                flag = false
                semaphote.signal()
                return
            }
            for gist in gists {
                if gist.files["ios-course-notes-db"] != nil {
                    guard let url = URL(string: "https://api.github.com/gists/\(gist.id)") else {
                        flag = false
                        semaphote.signal()
                        return
                    }
                    var request = URLRequest(url: url)
                    request.httpMethod = "PATCH"
                    request.addValue("token \(token)", forHTTPHeaderField: "Authorization")
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    guard let data = try? JSONSerialization.data(withJSONObject: self!.noteCollection.map { $0.json }, options: []) else {
                        flag = false
                        semaphote.signal()
                        return
                    }
                    let dataString = String(data: data, encoding: .utf8)
                    guard let dataToWrite = try? JSONSerialization.data(withJSONObject: ["files" : ["ios-course-notes-db": ["filename" : "ios-course-notes-db", "content" : dataString]]], options: []) else {
                        semaphote.signal()
                        flag = false
                        return
                    }
                    request.httpBody = dataToWrite
                    let urlSessionSemaphore = DispatchSemaphore(value: 1)
                    let rewriteDataTask = URLSession.shared.dataTask(with: request) {
                        (data, response, error) in
                        guard error == nil else {
                            flag = false
                            urlSessionSemaphore.signal()
                            return
                        }
                        guard let response = response as? HTTPURLResponse else {
                            flag = false
                            urlSessionSemaphore.signal()
                            return
                        }
                        switch response.statusCode {
                        case 200...300:
                            flag = true
                            urlSessionSemaphore.signal()
                            return
                        default:
                            flag = false
                            urlSessionSemaphore.signal()
                            return
                        }
                    }
                    urlSessionSemaphore.wait()
                    rewriteDataTask.resume()
                    urlSessionSemaphore.wait()
                    semaphote.signal()
                }
            }
        }
        
        semaphote.wait()
        dataTask.resume()
        semaphote.wait()
        
        if !flag {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("token \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            guard let data = try? JSONSerialization.data(withJSONObject: self.noteCollection.map { $0.json }, options: []) else {
                return false
            }
            let dataString = String(data: data, encoding: .utf8)
            guard let dataToWrite = try? JSONSerialization.data(withJSONObject: ["files": ["ios-course-notes-db": ["content": dataString ]]], options: []) else {
                return false
            }
            request.httpBody = dataToWrite
            let urlSessionSemaphore = DispatchSemaphore(value: 1)
            urlSessionSemaphore.wait()
            URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                guard error == nil else {
                    flag = false
                    urlSessionSemaphore.signal()
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    flag = false
                    urlSessionSemaphore.signal()
                    return
                }
                switch response.statusCode {
                case 200...300:
                    flag = true
                default:
                    flag = false
                }
            }.resume()
            urlSessionSemaphore.wait()
            semaphote.signal()
        } else {
            semaphote.signal()
        }
        
        semaphote.wait()
        return flag
    }
    
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    public func loadFromBackend(token: String) -> Bool {
        guard let url = URL(string: "https://api.github.com/gists") else {
            return false
        }
        let semaphore = DispatchSemaphore(value: 1) // первый семафор для отслеживания операции получения всех гистов (1)
        var request = URLRequest(url: url)
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        var flag = false
        let dataTask = URLSession.shared.dataTask(with: request) { // операция получения всех гистов
            [weak self] (data, response, error) in
            guard let gists = try? JSONDecoder().decode(Array<Gist>.self, from: data!) else {
                flag = false
                semaphore.signal() // 1 ++
                return
            }
            for gist in gists { // поиск необходимого гиста
                if let file = gist.files["ios-course-notes-db"] {
                    guard let url = URL(string: file.raw_url) else {
                        flag = false
                        semaphore.signal() // 1 ++
                        return
                    }
                    var request = URLRequest(url: url)
                    request.addValue("token \(token)", forHTTPHeaderField: "Authorization")
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    let urlSessoinSemaphore = DispatchSemaphore(value: 1) // семафор для отслеживания операции загрузки заметок из гиста (2)
                    let loadNotesDataTask = URLSession.shared.dataTask(with: request) { // операция загрузки заметок
                        [weak self] (data, response, error) in // в этот хэндлер не заходит (
                        guard error == nil else {
                            flag = false
                            urlSessoinSemaphore.signal() // 2 ++
                            return
                        }
                        guard let response = response as? HTTPURLResponse else {
                            flag = false
                            urlSessoinSemaphore.signal() // 2 ++
                            return
                        }
                        switch response.statusCode {
                        case 200...300:
                            flag = true
                        default:
                            flag = false
                            urlSessoinSemaphore.signal() // 2 ++
                            return
                        }
                        if let arrayOfJsons = try? JSONSerialization.jsonObject(with: data!, options: []) as? [[String: Any]] {
                            arrayOfJsons.forEach {
                                guard let note = Note.parse(json: $0) else {
                                    flag = false
                                    urlSessoinSemaphore.signal() // 2 ++
                                    return
                                }
                                do {
                                    try self?.add(note)
                                } catch { }
                            }
                        }
                        urlSessoinSemaphore.signal() // 2 ++
                    }
                    urlSessoinSemaphore.wait() // 2 --
                    loadNotesDataTask.resume() // делаем загрузку заметок
                    urlSessoinSemaphore.wait() // ждем загрузку
                    break // выходим из цикла
                }
            }
            semaphore.signal() // 1 ++
        }
        semaphore.wait() // 1 --
        dataTask.resume() // получаем все гисты
        semaphore.wait() // ждем окончания всего
        return flag
    }
    
    public func saveToFile() {
        if let directoryPath = FileManager.default.urls(for: .cachesDirectory,
                                                        in: .userDomainMask).first {
            let filePath = directoryPath.appendingPathComponent("file.txt")
            do {
                let dataToWrite = try JSONSerialization.data(withJSONObject: noteCollection.map { $0.json },
                                                             options: [])
                FileManager.default.createFile(atPath: filePath.path,
                                               contents: dataToWrite,
                                               attributes: nil)
                DDLogInfo("Notes are saved to file")
            } catch {
                DDLogError(error.localizedDescription)
            }
        }
    }
    
    public func loadFromFile() {
        if let directoryPath = FileManager.default.urls(for: .cachesDirectory,
                                                        in: .userDomainMask).first {
            let filePath = directoryPath.appendingPathComponent("file.txt")
            guard (FileManager.default.fileExists(atPath: filePath.path)) else { return }
            noteCollection.removeAll()
            do {
                let readData = try Data(contentsOf: filePath,
                                        options: [])
                if let arrayOfJsons = try JSONSerialization.jsonObject(with: readData,options: []) as? [[String: Any]] {
                    arrayOfJsons.forEach {
                        guard let note = Note.parse(json: $0) else {
                            DDLogInfo("nil at parsing")
                            return
                        }
                        do {
                            try add(note)
                        } catch {
                            switch error {
                            case FileNotebookErrors.addExistingNoteException:
                                DDLogError(error.localizedDescription)
                            default:
                                DDLogError(error.localizedDescription)
                                return
                            }
                        }
                    }
                }
                DDLogInfo("Notes are loaded from file")
            } catch {
                DDLogError(error.localizedDescription)
            }
        }
    }
}
