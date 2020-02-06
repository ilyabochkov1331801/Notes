//
//  NotesTests.swift
//  NotesTests
//
//  Created by Илья Бочков  on 2/1/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import XCTest
@testable import Notes

class NotesTests: XCTestCase {
    
    var json: [String: Any] = [:]
    override func setUp() {
        json = [
            "uid" : "UID",
            "title" : "title",
            "content" : "content",
            "color" : [100, 100, 100, 100],
            "importance" : "Normal",
            "selfDestructionDate": 1234.1234
        ]
    }

    func testCorrectParsing() {
        let note = Note.parse(json: json)
        XCTAssert(note != nil)
    }
    
    func testCorrectParsingWithoutColor() {
        let note = Note.parse(json: json.filter({ $0.key != "color" }))
        XCTAssert(note!.color == UIColor.white)
    }
    
    func testCorrectParsingWithoutSelfDestructionDate() {
        let note = Note.parse(json: json.filter({ $0.key != "selfDestructionDate" }))
        XCTAssert(note!.selfDestructionDate == nil)
    }
    
    func testIncorrectParsingWithoutTitle() {
        let note = Note.parse(json: json.filter({ $0.key != "title" }))
        XCTAssert(note == nil)
    }
    
    func testIncorrectParsingWithoutContent() {
        let note = Note.parse(json: json.filter({ $0.key != "content" }))
        XCTAssert(note == nil)
    }
    
    func testIncorrectParsingWithoutUID() {
        let note = Note.parse(json: json.filter({ $0.key != "uid" }))
        XCTAssert(note == nil)
    }
    
    func testIncorrectParsingWithBadTitleKey() {
        var newJson = json
        newJson["Title"] = newJson["title"]
        newJson["title"] = nil
        let note = Note.parse(json: newJson)
        XCTAssert(note == nil)
    }
    
    func testIncorrectParsingWithBadContentKey() {
        var newJson = json
        newJson["Content"] = newJson["content"]
        newJson["content"] = nil
        let note = Note.parse(json: newJson)
        XCTAssert(note == nil)
    }
    
    func testIncorrectParsingWithBadUIDKey() {
        var newJson = json
        newJson["Uid"] = newJson["uid"]
        newJson["uid"] = nil
        let note = Note.parse(json: newJson)
        XCTAssert(note == nil)
    }
    
    func testIncorrectParsingWithBadTitleValueType() {
        var newJson = json
        newJson["title"] = 0
        let note = Note.parse(json: newJson)
        XCTAssert(note == nil)
    }
    
    func testIncorrectParsingWithBadContentValueType() {
        var newJson = json
        newJson["content"] = 0
        let note = Note.parse(json: newJson)
        XCTAssert(note == nil)
    }
    
    func testIncorrectParsingWithBadUIDValueType() {
        var newJson = json
        newJson["uid"] = 0
        let note = Note.parse(json: newJson)
        XCTAssert(note == nil)
    }
}
