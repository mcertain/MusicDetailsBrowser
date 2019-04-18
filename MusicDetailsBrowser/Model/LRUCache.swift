//
//  LRUCache.swift
//  MusicDetailsBrowser
//
//  Created by Matthew Certain on 4/15/19.
//  Copyright © 2019 M. Certain. All rights reserved.
//

import Foundation

class Node
{
    init(value: String) {
        next = nil
        previous = nil
        self.value = value
        self.objectData = nil
    }
    
    fileprivate let value: String
    fileprivate var next: Node?
    fileprivate var previous: Node?
    fileprivate var objectData: AnyObject?
    
    func setObjectData(object: AnyObject?) {
        objectData = object
    }
    
    func getObjectData() -> AnyObject? {
        return objectData
    }
    
    func getValue() -> String? {
        return value
    }
}

class LRUCache
{
    init(sizeLimit: Int) {
        head = nil
        tail = nil
        self.sizeLimit = sizeLimit
        
        LRUCacheLookup = [String:Node]()
        LRUCacheLookup.reserveCapacity(self.sizeLimit)
    }

    fileprivate var LRUCacheLookup: [String:Node]
    fileprivate let sizeLimit: Int
    fileprivate var head: Node?
    fileprivate var tail: Node?
    
    func isEmpty() -> Bool {
        return (LRUCacheLookup.count == 0) ? true : false
    }
    
    func get(value: String)  -> Node? {
        return LRUCacheLookup[value]
    }
    
    func isValid(value: String) -> Bool {
        return (LRUCacheLookup[value] == nil) ? false : true
    }
    
    func add(value: String) -> Node? {
        
        let cleanedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard cleanedValue == value && value != "" else {
            // Don't add value since it has invalid characters in it
            return nil
        }
        
        if(isEmpty() == false)
        {
            // If the cache is not empty, then check to see if the value we want is in cache
            let foundNode: Node? = get(value: value)
            if(foundNode == nil) {
                // If the node isn't in cache and we're at the size limit,
                // then remove node from the tail to make room for new node
                if(LRUCacheLookup.count == sizeLimit) {
                    tail?.previous?.next = nil
                    LRUCacheLookup.removeValue(forKey: (tail?.value)!)
                    tail = tail?.previous
                }
                
                // Now create a new node and insert it at the head
                let newNode: Node? = Node(value: value)
                LRUCacheLookup[value] = newNode
                
                newNode?.next = self.head
                self.head?.previous = newNode
                self.head = newNode
            }
            else {
                
                // If the head is already the value being accessed, then no cache update needed
                if(self.head?.value == value)
                {
                    return self.head
                }
                
                // Otherwise, move to the value being accessed to the front
                foundNode?.previous?.next = foundNode?.next
                foundNode?.next?.previous = foundNode?.previous
                foundNode?.next = self.head
                foundNode?.previous = nil
                self.head = foundNode
            }
        }
        else
        {
            // If the cache is empty, then create the new node and add it to the head
            let newNode: Node? = Node(value: value)
            LRUCacheLookup[value] = newNode
            self.head = newNode
            self.tail = newNode
        }
        return self.head
    }
}
