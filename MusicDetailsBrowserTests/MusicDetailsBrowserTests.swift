//
//  MusicDetailsBrowserTests.swift
//  MusicDetailsBrowser
//
//  Created by Matthew Certain on 4/15/19.
//  Copyright © 2019 M. Certain. All rights reserved.
//

import XCTest

@testable import MusicDetailsBrowser

class LRUCacheTests: XCTestCase {

    var musicDetailsCache: LRUCache?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        musicDetailsCache = LRUCache(sizeLimit: 5)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        musicDetailsCache = nil
    }

    func testIsCacheEmptyWhenTrue() {
        
        // Verify that true is returned when values have been added to the cache

        let empty = musicDetailsCache?.isEmpty()
        
        XCTAssertEqual(empty, true, "Determining whether cache is empty failed.")
    }
    
    func testIsCacheEmptyWhenFalse() {
        var empty: Bool?
        
        // Verify that isEmpty continues to indicate that the Cache is not empty while
        // the number of entries added is less than and greater than the max Cache Size 
        
        _ = musicDetailsCache?.add(value: "123456")
        empty = musicDetailsCache?.isEmpty()
        XCTAssertEqual(empty, false, "Determining whether cache is empty failed.")
        
        _ = musicDetailsCache?.add(value: "234567")
        empty = musicDetailsCache?.isEmpty()
        XCTAssertEqual(empty, false, "Determining whether cache is empty failed.")
        
        _ = musicDetailsCache?.add(value: "345678")
        empty = musicDetailsCache?.isEmpty()
        XCTAssertEqual(empty, false, "Determining whether cache is empty failed.")
        
        _ = musicDetailsCache?.add(value: "456789")
        empty = musicDetailsCache?.isEmpty()
        XCTAssertEqual(empty, false, "Determining whether cache is empty failed.")
        
        _ = musicDetailsCache?.add(value: "567890")
        empty = musicDetailsCache?.isEmpty()
        XCTAssertEqual(empty, false, "Determining whether cache is empty failed.")
        
        _ = musicDetailsCache?.add(value: "678901")
        empty = musicDetailsCache?.isEmpty()
        XCTAssertEqual(empty, false, "Determining whether cache is empty failed.")
    }
    
    func testIsCacheEmptyWhenCacheIsNil() {
        
        // Verify that an unallocated cache object cases isEmpty to return nil and
        // NOT a true or false value
        
        let unallocatedMusicDetailsCache: LRUCache? = nil
        
        let empty = unallocatedMusicDetailsCache?.isEmpty()
        
        XCTAssertEqual((empty == nil), true, "Determining whether cache is empty failed.")
    }
    
    func testCacheEntryObjectReferences() {
        var newCacheEntry: String
        var cacheEntry: Node?
        var newNode: Node?
        
        let stringObject: String? = "ABCDEF"
        let dictionaryObject: [String:Int]? = ["A":1, "B":2, "C":3]
        let urlObject: URL? = URL(string: "https://www.google.com/")
        let musicDetailsObject: MusicDetails? = MusicDetails(title: "Fred: The Music",
                                                             image: "http://images.adrise.tv/lKsDShnaRNa1karinuKUMk0woKc=/214x306/smart/img.adrise.tv/90115436-a94c-4536-8ff8-906a4a193fd8.jpg",
                                                             id: "321861",
                                                             index: 26)
        
        // Verify attaching string object references
        newCacheEntry = "123456"
        newNode = musicDetailsCache?.add(value: newCacheEntry)
        newNode?.setObjectData(object: stringObject as AnyObject)
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry)
        let stringObj: String? = cacheEntry?.getObjectData() as! String?
        XCTAssertEqual(stringObject == stringObj, true, "Determining whether stored object references is stored without getting mutated.")
        
        // Verify attaching Dictionary object references
        newCacheEntry = "123457"
        newNode = musicDetailsCache?.add(value: newCacheEntry)
        newNode?.setObjectData(object: dictionaryObject as AnyObject)
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry)
        let dictionaryObj: [String:Int]? = cacheEntry?.getObjectData() as! [String:Int]?
        XCTAssertEqual(dictionaryObject == dictionaryObj, true, "Determining whether stored object references is stored without getting mutated.")
        
        // Verify attaching URL object references
        newCacheEntry = "123458"
        newNode = musicDetailsCache?.add(value: newCacheEntry)
        newNode?.setObjectData(object: urlObject as AnyObject)
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry)
        let urlObj: URL? = cacheEntry?.getObjectData() as! URL?
        XCTAssertEqual(urlObject == urlObj, true, "Determining whether stored object references is stored without getting mutated.")
        
        // Verify attaching MusicDetails object references
        newCacheEntry = "123459"
        newNode = musicDetailsCache?.add(value: newCacheEntry)
        newNode?.setObjectData(object: musicDetailsObject as AnyObject)
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry)
        let musicDetailsObj: MusicDetails? = cacheEntry?.getObjectData() as! MusicDetails?
        XCTAssertEqual(musicDetailsObject == musicDetailsObj, true, "Determining whether stored object references is stored without getting mutated.")
        
    }
    
    func testCacheEntryWithOutMisses() {
        var newCacheEntry: String
        var cacheEntry: Node?
        
        newCacheEntry = "123456"
        _ = musicDetailsCache?.add(value: newCacheEntry)
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry)
        XCTAssertEqual( (cacheEntry != nil), true, "Determining whether returned cache node is valid.")
        XCTAssertEqual( (cacheEntry?.getValue() == newCacheEntry), true, "Determining whether returned cache node matches added value.")
        XCTAssertEqual(musicDetailsCache?.isValid(value: newCacheEntry) == true, true, "Determining whether valid entry shows up in cache.")
        
        newCacheEntry = "123457"
        _ = musicDetailsCache?.add(value: newCacheEntry)
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry)
        XCTAssertEqual( (cacheEntry != nil), true, "Determining whether returned cache node is valid.")
        XCTAssertEqual( (cacheEntry?.getValue() == newCacheEntry), true, "Determining whether returned cache node matches added value.")
        XCTAssertEqual(musicDetailsCache?.isValid(value: newCacheEntry) == true, true, "Determining whether valid entry shows up in cache.")

        newCacheEntry = "123458"
        _ = musicDetailsCache?.add(value: newCacheEntry)
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry)
        XCTAssertEqual( (cacheEntry != nil), true, "Determining whether returned cache node is valid.")
        XCTAssertEqual( (cacheEntry?.getValue() == newCacheEntry), true, "Determining whether returned cache node matches added value.")
        XCTAssertEqual(musicDetailsCache?.isValid(value: newCacheEntry) == true, true, "Determining whether valid entry shows up in cache.")

        newCacheEntry = "123459"
        _ = musicDetailsCache?.add(value: newCacheEntry)
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry)
        XCTAssertEqual( (cacheEntry != nil), true, "Determining whether returned cache node is valid.")
        XCTAssertEqual( (cacheEntry?.getValue() == newCacheEntry), true, "Determining whether returned cache node matches added value.")
        XCTAssertEqual(musicDetailsCache?.isValid(value: newCacheEntry) == true, true, "Determining whether valid entry shows up in cache.")

        newCacheEntry = "123450"
        _ = musicDetailsCache?.add(value: newCacheEntry)
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry)
        XCTAssertEqual( (cacheEntry != nil), true, "Determining whether returned cache node is valid.")
        XCTAssertEqual( (cacheEntry?.getValue() == newCacheEntry), true, "Determining whether returned cache node matches added value.")
        XCTAssertEqual(musicDetailsCache?.isValid(value: newCacheEntry) == true, true, "Determining whether valid entry shows up in cache.")
    }
    
    func testCacheEntryWithMisses() {
        var cacheEntry: Node?
        
        let newCacheEntry1 = "123456"
        _ = musicDetailsCache?.add(value: newCacheEntry1)
        let newCacheEntry2 = "123457"
        _ = musicDetailsCache?.add(value: newCacheEntry2)
        let newCacheEntry3 = "123458"
        _ = musicDetailsCache?.add(value: newCacheEntry3)
        let newCacheEntry4 = "123459"
        _ = musicDetailsCache?.add(value: newCacheEntry4)
        let newCacheEntry5 = "123450"
        _ = musicDetailsCache?.add(value: newCacheEntry5)
        let newCacheEntry6 = "123451"
        _ = musicDetailsCache?.add(value: newCacheEntry6)
        
        // The oldest entry should be a miss and invalid since it's not in cache anymore
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry1)
        XCTAssertEqual( (cacheEntry == nil), true, "Determining whether returned cache node is invalid.")
        XCTAssertEqual( (cacheEntry?.getValue() == nil), true, "Determining whether returned cache node value is nil.")
        XCTAssertEqual(musicDetailsCache?.isValid(value: newCacheEntry1) == false, true, "Determining whether old but valid entry still shows up in cache.")
        
        // The 5 most recent should be hits and still in the cache
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry2)
        XCTAssertEqual( (cacheEntry != nil), true, "Determining whether returned cache node is valid.")
        XCTAssertEqual( (cacheEntry?.getValue() == newCacheEntry2), true, "Determining whether returned cache node matches added value.")
        XCTAssertEqual(musicDetailsCache?.isValid(value: newCacheEntry2) == true, true, "Determining whether current and valid entry shows up in cache.")
        
        
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry3)
        XCTAssertEqual( (cacheEntry != nil), true, "Determining whether returned cache node is valid.")
        XCTAssertEqual( (cacheEntry?.getValue() == newCacheEntry3), true, "Determining whether returned cache node matches added value.")
        XCTAssertEqual(musicDetailsCache?.isValid(value: newCacheEntry3) == true, true, "Determining whether current and valid entry shows up in cache.")
        
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry4)
        XCTAssertEqual( (cacheEntry != nil), true, "Determining whether returned cache node is valid.")
        XCTAssertEqual( (cacheEntry?.getValue() == newCacheEntry4), true, "Determining whether returned cache node matches added value.")
        XCTAssertEqual(musicDetailsCache?.isValid(value: newCacheEntry4) == true, true, "Determining whether current and valid entry shows up in cache.")
        
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry5)
        XCTAssertEqual( (cacheEntry != nil), true, "Determining whether returned cache node is valid.")
        XCTAssertEqual( (cacheEntry?.getValue() == newCacheEntry5), true, "Determining whether returned cache node matches added value.")
        XCTAssertEqual(musicDetailsCache?.isValid(value: newCacheEntry5) == true, true, "Determining whether current and valid entry shows up in cache.")
        
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry6)
        XCTAssertEqual( (cacheEntry != nil), true, "Determining whether returned cache node is valid.")
        XCTAssertEqual( (cacheEntry?.getValue() == newCacheEntry6), true, "Determining whether returned cache node matches added value.")
        XCTAssertEqual(musicDetailsCache?.isValid(value: newCacheEntry6) == true, true, "Determining whether current and valid entry shows up in cache.")
        
        // The oldest entries should be misses and invalid since they are not in cache anymore
        let newCacheEntry7 = "123452"
        _ = musicDetailsCache?.add(value: newCacheEntry7)
        
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry2)
        XCTAssertEqual( (cacheEntry == nil), true, "Determining whether returned cache node is invalid.")
        XCTAssertEqual( (cacheEntry?.getValue() == nil), true, "Determining whether returned cache node value is nil.")
        XCTAssertEqual(musicDetailsCache?.isValid(value: newCacheEntry2) == false, true, "Determining whether old but valid entry still shows up in cache.")
        
        let newCacheEntry8 = "123453"
        _ = musicDetailsCache?.add(value: newCacheEntry8)
        
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry3)
        XCTAssertEqual( (cacheEntry == nil), true, "Determining whether returned cache node is invalid.")
        XCTAssertEqual( (cacheEntry?.getValue() == nil), true, "Determining whether returned cache node value is nil.")
        XCTAssertEqual(musicDetailsCache?.isValid(value: newCacheEntry3) == false, true, "Determining whether old but valid entry still shows up in cache.")
        
        let newCacheEntry9 = "123454"
        _ = musicDetailsCache?.add(value: newCacheEntry9)
        
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry4)
        XCTAssertEqual( (cacheEntry == nil), true, "Determining whether returned cache node is invalid.")
        XCTAssertEqual( (cacheEntry?.getValue() == nil), true, "Determining whether returned cache node value is nil.")
        XCTAssertEqual(musicDetailsCache?.isValid(value: newCacheEntry4) == false, true, "Determining whether old but valid entry still shows up in cache.")
        
        let newCacheEntry10 = "123455"
        _ = musicDetailsCache?.add(value: newCacheEntry10)
        
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry5)
        XCTAssertEqual( (cacheEntry == nil), true, "Determining whether returned cache node is invalid.")
        XCTAssertEqual( (cacheEntry?.getValue() == nil), true, "Determining whether returned cache node value is nil.")
        XCTAssertEqual(musicDetailsCache?.isValid(value: newCacheEntry5) == false, true, "Determining whether old but valid entry still shows up in cache.")
    }
    
    func testCacheEntryWithInvalidValues() {
        var newCacheEntry: String
        var cacheEntry: Node?
        
        // Empty value
        newCacheEntry = ""
        _ = musicDetailsCache?.add(value: newCacheEntry)
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry)
        XCTAssertEqual( (cacheEntry == nil), true, "Determining whether returned cache node is invalid.")
        XCTAssertEqual(musicDetailsCache?.isEmpty() == true, true, "Determining whether cache is empty failed.")
        XCTAssertEqual(musicDetailsCache?.isValid(value: newCacheEntry) == false, true, "Determining whether invalid entry shows up in cache.")
        
        
        // Value with spaces
        newCacheEntry = "   "
        _ = musicDetailsCache?.add(value: newCacheEntry)
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry)
        XCTAssertEqual( (cacheEntry == nil), true, "Determining whether returned cache node is invalid.")
        XCTAssertEqual(musicDetailsCache?.isEmpty() == true, true, "Determining whether cache is empty failed.")
        XCTAssertEqual(musicDetailsCache?.isValid(value: newCacheEntry) == false, true, "Determining whether invalid entry shows up in cache.")
        
        // Value with newlines and spaces
        newCacheEntry = "\n \n"
        _ = musicDetailsCache?.add(value: newCacheEntry)
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry)
        XCTAssertEqual( (cacheEntry == nil), true, "Determining whether returned cache node is invalid.")
        XCTAssertEqual(musicDetailsCache?.isEmpty() == true, true, "Determining whether cache is empty failed.")
        XCTAssertEqual(musicDetailsCache?.isValid(value: newCacheEntry) == false, true, "Determining whether invalid entry shows up in cache.")
        
        // Value with newlines, spaces, and tabs
        newCacheEntry = " \n \t \n  \n  \t"
        _ = musicDetailsCache?.add(value: newCacheEntry)
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry)
        XCTAssertEqual( (cacheEntry == nil), true, "Determining whether returned cache node is invalid.")
        XCTAssertEqual(musicDetailsCache?.isEmpty() == true, true, "Determining whether cache is empty failed.")
        XCTAssertEqual(musicDetailsCache?.isValid(value: newCacheEntry) == false, true, "Determining whether invalid entry shows up in cache.")
        
        // Value with valid characters and invalid newlines, spaces, and tabs
        newCacheEntry = "123456 \n \t \n  \n  \t"
        _ = musicDetailsCache?.add(value: newCacheEntry)
        cacheEntry = musicDetailsCache?.get(value: newCacheEntry)
        XCTAssertEqual( (cacheEntry == nil), true, "Determining whether returned cache node is invalid.")
        XCTAssertEqual(musicDetailsCache?.isEmpty() == true, true, "Determining whether cache is empty failed.")
        XCTAssertEqual(musicDetailsCache?.isValid(value: newCacheEntry) == false, true, "Determining whether invalid entry shows up in cache.")
    }

}
