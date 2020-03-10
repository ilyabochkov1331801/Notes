//
//  Gists.swift
//  Notes
//
//  Created by Илья Бочков  on 3/10/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import Foundation

struct GistFile: Codable {
    let filename: String
    let raw_url: String
}

struct Owner: Codable {
    let login: String
}

struct Gist: Codable {
    let files: [String: GistFile]
    let id: String
    let owner: Owner
}
