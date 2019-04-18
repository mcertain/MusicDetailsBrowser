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

    var movieDetailsCache: LRUCache?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        movieDetailsCache = LRUCache(sizeLimit: 5)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        movieDetailsCache = nil
    }

    func testIsCacheEmptyWhenTrue() {
        
        // Verify that true is returned when values have been added to the cache

        let empty = movieDetailsCache?.isEmpty()
        
        XCTAssertEqual(empty, true, "Determining whether cache is empty failed.")
    }
    
    func testIsCacheEmptyWhenFalse() {
        var empty: Bool?
        
        // Verify that isEmpty continues to indicate that the Cache is not empty while
        // the number of entries added is less than and greater than the max Cache Size 
        
        _ = movieDetailsCache?.add(value: "123456")
        empty = movieDetailsCache?.isEmpty()
        XCTAssertEqual(empty, false, "Determining whether cache is empty failed.")
        
        _ = movieDetailsCache?.add(value: "234567")
        empty = movieDetailsCache?.isEmpty()
        XCTAssertEqual(empty, false, "Determining whether cache is empty failed.")
        
        _ = movieDetailsCache?.add(value: "345678")
        empty = movieDetailsCache?.isEmpty()
        XCTAssertEqual(empty, false, "Determining whether cache is empty failed.")
        
        _ = movieDetailsCache?.add(value: "456789")
        empty = movieDetailsCache?.isEmpty()
        XCTAssertEqual(empty, false, "Determining whether cache is empty failed.")
        
        _ = movieDetailsCache?.add(value: "567890")
        empty = movieDetailsCache?.isEmpty()
        XCTAssertEqual(empty, false, "Determining whether cache is empty failed.")
        
        _ = movieDetailsCache?.add(value: "678901")
        empty = movieDetailsCache?.isEmpty()
        XCTAssertEqual(empty, false, "Determining whether cache is empty failed.")
    }
    
    func testIsCacheEmptyWhenCacheIsNil() {
        
        // Verify that an unallocated cache object cases isEmpty to return nil and
        // NOT a true or false value
        
        let unallocatedMovieDetailsCache: LRUCache? = nil
        
        let empty = unallocatedMovieDetailsCache?.isEmpty()
        
        XCTAssertEqual((empty == nil), true, "Determining whether cache is empty failed.")
    }
    
    func testCacheEntryObjectReferences() {
        var newCacheEntry: String
        var cacheEntry: Node?
        var newNode: Node?
        
        let stringObject: String? = "ABCDEF"
        let dictionaryObject: [String:Int]? = ["A":1, "B":2, "C":3]
        let urlObject: URL? = URL(string: "https://www.google.com/")
        let movieDetailsObject: MovieDetails? = MovieDetails(title: "Fred: The Movie",
                                                             image: "http://images.adrise.tv/lKsDShnaRNa1karinuKUMk0woKc=/214x306/smart/img.adrise.tv/90115436-a94c-4536-8ff8-906a4a193fd8.jpg",
                                                             id: "321861",
                                                             index: 26)
        
        // Verify attaching string object references
        newCacheEntry = "123456"
        newNode = movieDetailsCache?.add(value: newCacheEntry)
        newNode?.setObjectData(object: stringObject as AnyObject)
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry)
        let stringObj: String? = cacheEntry?.getObjectData() as! String?
        XCTAssertEqual(stringObject == stringObj, true, "Determining whether stored object references is stored without getting mutated.")
        
        // Verify attaching Dictionary object references
        newCacheEntry = "123457"
        newNode = movieDetailsCache?.add(value: newCacheEntry)
        newNode?.setObjectData(object: dictionaryObject as AnyObject)
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry)
        let dictionaryObj: [String:Int]? = cacheEntry?.getObjectData() as! [String:Int]?
        XCTAssertEqual(dictionaryObject == dictionaryObj, true, "Determining whether stored object references is stored without getting mutated.")
        
        // Verify attaching URL object references
        newCacheEntry = "123458"
        newNode = movieDetailsCache?.add(value: newCacheEntry)
        newNode?.setObjectData(object: urlObject as AnyObject)
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry)
        let urlObj: URL? = cacheEntry?.getObjectData() as! URL?
        XCTAssertEqual(urlObject == urlObj, true, "Determining whether stored object references is stored without getting mutated.")
        
        // Verify attaching MovieDetails object references
        newCacheEntry = "123459"
        newNode = movieDetailsCache?.add(value: newCacheEntry)
        newNode?.setObjectData(object: movieDetailsObject as AnyObject)
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry)
        let movieDetailsObj: MovieDetails? = cacheEntry?.getObjectData() as! MovieDetails?
        XCTAssertEqual(movieDetailsObject == movieDetailsObj, true, "Determining whether stored object references is stored without getting mutated.")
        
    }
    
    func testCacheEntryWithOutMisses() {
        var newCacheEntry: String
        var cacheEntry: Node?
        
        newCacheEntry = "123456"
        _ = movieDetailsCache?.add(value: newCacheEntry)
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry)
        XCTAssertEqual( (cacheEntry != nil), true, "Determining whether returned cache node is valid.")
        XCTAssertEqual( (cacheEntry?.getValue() == newCacheEntry), true, "Determining whether returned cache node matches added value.")
        XCTAssertEqual(movieDetailsCache?.isValid(value: newCacheEntry) == true, true, "Determining whether valid entry shows up in cache.")
        
        newCacheEntry = "123457"
        _ = movieDetailsCache?.add(value: newCacheEntry)
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry)
        XCTAssertEqual( (cacheEntry != nil), true, "Determining whether returned cache node is valid.")
        XCTAssertEqual( (cacheEntry?.getValue() == newCacheEntry), true, "Determining whether returned cache node matches added value.")
        XCTAssertEqual(movieDetailsCache?.isValid(value: newCacheEntry) == true, true, "Determining whether valid entry shows up in cache.")

        newCacheEntry = "123458"
        _ = movieDetailsCache?.add(value: newCacheEntry)
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry)
        XCTAssertEqual( (cacheEntry != nil), true, "Determining whether returned cache node is valid.")
        XCTAssertEqual( (cacheEntry?.getValue() == newCacheEntry), true, "Determining whether returned cache node matches added value.")
        XCTAssertEqual(movieDetailsCache?.isValid(value: newCacheEntry) == true, true, "Determining whether valid entry shows up in cache.")

        newCacheEntry = "123459"
        _ = movieDetailsCache?.add(value: newCacheEntry)
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry)
        XCTAssertEqual( (cacheEntry != nil), true, "Determining whether returned cache node is valid.")
        XCTAssertEqual( (cacheEntry?.getValue() == newCacheEntry), true, "Determining whether returned cache node matches added value.")
        XCTAssertEqual(movieDetailsCache?.isValid(value: newCacheEntry) == true, true, "Determining whether valid entry shows up in cache.")

        newCacheEntry = "123450"
        _ = movieDetailsCache?.add(value: newCacheEntry)
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry)
        XCTAssertEqual( (cacheEntry != nil), true, "Determining whether returned cache node is valid.")
        XCTAssertEqual( (cacheEntry?.getValue() == newCacheEntry), true, "Determining whether returned cache node matches added value.")
        XCTAssertEqual(movieDetailsCache?.isValid(value: newCacheEntry) == true, true, "Determining whether valid entry shows up in cache.")
    }
    
    func testCacheEntryWithMisses() {
        var cacheEntry: Node?
        
        let newCacheEntry1 = "123456"
        _ = movieDetailsCache?.add(value: newCacheEntry1)
        let newCacheEntry2 = "123457"
        _ = movieDetailsCache?.add(value: newCacheEntry2)
        let newCacheEntry3 = "123458"
        _ = movieDetailsCache?.add(value: newCacheEntry3)
        let newCacheEntry4 = "123459"
        _ = movieDetailsCache?.add(value: newCacheEntry4)
        let newCacheEntry5 = "123450"
        _ = movieDetailsCache?.add(value: newCacheEntry5)
        let newCacheEntry6 = "123451"
        _ = movieDetailsCache?.add(value: newCacheEntry6)
        
        // The oldest entry should be a miss and invalid since it's not in cache anymore
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry1)
        XCTAssertEqual( (cacheEntry == nil), true, "Determining whether returned cache node is invalid.")
        XCTAssertEqual( (cacheEntry?.getValue() == nil), true, "Determining whether returned cache node value is nil.")
        XCTAssertEqual(movieDetailsCache?.isValid(value: newCacheEntry1) == false, true, "Determining whether old but valid entry still shows up in cache.")
        
        // The 5 most recent should be hits and still in the cache
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry2)
        XCTAssertEqual( (cacheEntry != nil), true, "Determining whether returned cache node is valid.")
        XCTAssertEqual( (cacheEntry?.getValue() == newCacheEntry2), true, "Determining whether returned cache node matches added value.")
        XCTAssertEqual(movieDetailsCache?.isValid(value: newCacheEntry2) == true, true, "Determining whether current and valid entry shows up in cache.")
        
        
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry3)
        XCTAssertEqual( (cacheEntry != nil), true, "Determining whether returned cache node is valid.")
        XCTAssertEqual( (cacheEntry?.getValue() == newCacheEntry3), true, "Determining whether returned cache node matches added value.")
        XCTAssertEqual(movieDetailsCache?.isValid(value: newCacheEntry3) == true, true, "Determining whether current and valid entry shows up in cache.")
        
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry4)
        XCTAssertEqual( (cacheEntry != nil), true, "Determining whether returned cache node is valid.")
        XCTAssertEqual( (cacheEntry?.getValue() == newCacheEntry4), true, "Determining whether returned cache node matches added value.")
        XCTAssertEqual(movieDetailsCache?.isValid(value: newCacheEntry4) == true, true, "Determining whether current and valid entry shows up in cache.")
        
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry5)
        XCTAssertEqual( (cacheEntry != nil), true, "Determining whether returned cache node is valid.")
        XCTAssertEqual( (cacheEntry?.getValue() == newCacheEntry5), true, "Determining whether returned cache node matches added value.")
        XCTAssertEqual(movieDetailsCache?.isValid(value: newCacheEntry5) == true, true, "Determining whether current and valid entry shows up in cache.")
        
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry6)
        XCTAssertEqual( (cacheEntry != nil), true, "Determining whether returned cache node is valid.")
        XCTAssertEqual( (cacheEntry?.getValue() == newCacheEntry6), true, "Determining whether returned cache node matches added value.")
        XCTAssertEqual(movieDetailsCache?.isValid(value: newCacheEntry6) == true, true, "Determining whether current and valid entry shows up in cache.")
        
        // The oldest entries should be misses and invalid since they are not in cache anymore
        let newCacheEntry7 = "123452"
        _ = movieDetailsCache?.add(value: newCacheEntry7)
        
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry2)
        XCTAssertEqual( (cacheEntry == nil), true, "Determining whether returned cache node is invalid.")
        XCTAssertEqual( (cacheEntry?.getValue() == nil), true, "Determining whether returned cache node value is nil.")
        XCTAssertEqual(movieDetailsCache?.isValid(value: newCacheEntry2) == false, true, "Determining whether old but valid entry still shows up in cache.")
        
        let newCacheEntry8 = "123453"
        _ = movieDetailsCache?.add(value: newCacheEntry8)
        
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry3)
        XCTAssertEqual( (cacheEntry == nil), true, "Determining whether returned cache node is invalid.")
        XCTAssertEqual( (cacheEntry?.getValue() == nil), true, "Determining whether returned cache node value is nil.")
        XCTAssertEqual(movieDetailsCache?.isValid(value: newCacheEntry3) == false, true, "Determining whether old but valid entry still shows up in cache.")
        
        let newCacheEntry9 = "123454"
        _ = movieDetailsCache?.add(value: newCacheEntry9)
        
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry4)
        XCTAssertEqual( (cacheEntry == nil), true, "Determining whether returned cache node is invalid.")
        XCTAssertEqual( (cacheEntry?.getValue() == nil), true, "Determining whether returned cache node value is nil.")
        XCTAssertEqual(movieDetailsCache?.isValid(value: newCacheEntry4) == false, true, "Determining whether old but valid entry still shows up in cache.")
        
        let newCacheEntry10 = "123455"
        _ = movieDetailsCache?.add(value: newCacheEntry10)
        
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry5)
        XCTAssertEqual( (cacheEntry == nil), true, "Determining whether returned cache node is invalid.")
        XCTAssertEqual( (cacheEntry?.getValue() == nil), true, "Determining whether returned cache node value is nil.")
        XCTAssertEqual(movieDetailsCache?.isValid(value: newCacheEntry5) == false, true, "Determining whether old but valid entry still shows up in cache.")
    }
    
    func testCacheEntryWithInvalidValues() {
        var newCacheEntry: String
        var cacheEntry: Node?
        
        // Empty value
        newCacheEntry = ""
        _ = movieDetailsCache?.add(value: newCacheEntry)
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry)
        XCTAssertEqual( (cacheEntry == nil), true, "Determining whether returned cache node is invalid.")
        XCTAssertEqual(movieDetailsCache?.isEmpty() == true, true, "Determining whether cache is empty failed.")
        XCTAssertEqual(movieDetailsCache?.isValid(value: newCacheEntry) == false, true, "Determining whether invalid entry shows up in cache.")
        
        
        // Value with spaces
        newCacheEntry = "   "
        _ = movieDetailsCache?.add(value: newCacheEntry)
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry)
        XCTAssertEqual( (cacheEntry == nil), true, "Determining whether returned cache node is invalid.")
        XCTAssertEqual(movieDetailsCache?.isEmpty() == true, true, "Determining whether cache is empty failed.")
        XCTAssertEqual(movieDetailsCache?.isValid(value: newCacheEntry) == false, true, "Determining whether invalid entry shows up in cache.")
        
        // Value with newlines and spaces
        newCacheEntry = "\n \n"
        _ = movieDetailsCache?.add(value: newCacheEntry)
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry)
        XCTAssertEqual( (cacheEntry == nil), true, "Determining whether returned cache node is invalid.")
        XCTAssertEqual(movieDetailsCache?.isEmpty() == true, true, "Determining whether cache is empty failed.")
        XCTAssertEqual(movieDetailsCache?.isValid(value: newCacheEntry) == false, true, "Determining whether invalid entry shows up in cache.")
        
        // Value with newlines, spaces, and tabs
        newCacheEntry = " \n \t \n  \n  \t"
        _ = movieDetailsCache?.add(value: newCacheEntry)
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry)
        XCTAssertEqual( (cacheEntry == nil), true, "Determining whether returned cache node is invalid.")
        XCTAssertEqual(movieDetailsCache?.isEmpty() == true, true, "Determining whether cache is empty failed.")
        XCTAssertEqual(movieDetailsCache?.isValid(value: newCacheEntry) == false, true, "Determining whether invalid entry shows up in cache.")
        
        // Value with valid characters and invalid newlines, spaces, and tabs
        newCacheEntry = "123456 \n \t \n  \n  \t"
        _ = movieDetailsCache?.add(value: newCacheEntry)
        cacheEntry = movieDetailsCache?.get(value: newCacheEntry)
        XCTAssertEqual( (cacheEntry == nil), true, "Determining whether returned cache node is invalid.")
        XCTAssertEqual(movieDetailsCache?.isEmpty() == true, true, "Determining whether cache is empty failed.")
        XCTAssertEqual(movieDetailsCache?.isValid(value: newCacheEntry) == false, true, "Determining whether invalid entry shows up in cache.")
    }

}
