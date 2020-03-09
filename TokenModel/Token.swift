//
//  Token.swift
//  Notes
//
//  Created by Илья Бочков  on 3/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

class Token {
    var token: String? = nil
    
    func saveTokenToFile() {
        if let directoryPath = FileManager.default.urls(for: .cachesDirectory,
                                                        in: .userDomainMask).first {
            let filePath = directoryPath.appendingPathComponent("token.txt")
            do {
                guard let token = token else { return }
                let dataToWrite = try JSONEncoder().encode(token)
                FileManager.default.createFile(atPath: filePath.path,
                                               contents: dataToWrite,
                                               attributes: nil)
            } catch {
                return
            }
        }
    }
    
    func loadTokenFromFile() {
        if let directoryPath = FileManager.default.urls(for: .cachesDirectory,
                                                        in: .userDomainMask).first {
            let filePath = directoryPath.appendingPathComponent("token.txt")
            guard (FileManager.default.fileExists(atPath: filePath.path)) else { return }
            do {
                let readData = try Data(contentsOf: filePath,
                                        options: [])
                if let token = try? JSONDecoder().decode(String.self, from: readData) {
                    self.token = token
                }
            } catch {
                return
            }
        }
    }
    
    func deleteTokenFile() {
        if let directoryPath = FileManager.default.urls(for: .cachesDirectory,
                                                    in: .userDomainMask).first {
        let filePath = directoryPath.appendingPathComponent("token.txt")
        guard (FileManager.default.fileExists(atPath: filePath.path)) else { return }
            do {
            try FileManager.default.removeItem(atPath: filePath.path)
            } catch {
                return
            }
        }
    }
}
