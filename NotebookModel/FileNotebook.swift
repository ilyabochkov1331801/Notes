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
