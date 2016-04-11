//
//  File.swift
//  ObjectiveCloudant
//
//  Created by Rhys Short on 26/03/2016.
//  Copyright (c) 2016 IBM Corp.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License. You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//  Unless required by applicable law or agreed to in writing, software distributed under the
//  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
//  either express or implied. See the License for the specific language governing permissions
//  and limitations under the License.
//


import Foundation
import XCTest
@testable import SwiftCloudant

class PutDocumentTests : XCTestCase {
    let url = "http://localhost:5984"
    let username: String? = nil
    let password: String? = nil
    var client: CouchDBClient? = nil;
    var dbName: String? = nil
    
    override func setUp() {
        super.setUp()
        
        dbName = "a-\(NSUUID().UUIDString.lowercaseString)"
        self.client = CouchDBClient(url:NSURL(string: url)!, username:username, password:password)
        let create = CreateDatabaseOperation()
        create.databaseName = dbName!
        client!.addOperation(create)
        create.waitUntilFinished()
        
        print("Created database: \(dbName!)")
    }
    
    
    func testSaveDocument(){
        let db = self.client![self.dbName!]
        let putExpectation = self.expectationWithDescription("Put Document expectation")
        let put = PutDocumentOperation()
        put.docId = "Doc1"
        put.body = ["hello":"world"]
        put.putDocumentCompletionBlock = {(docId,revId,statusCode,error) in
            putExpectation.fulfill()
            XCTAssertNotNil(docId)
            XCTAssertNotNil(revId)
            XCTAssertEqual(2, statusCode / 100)
            XCTAssertEqual("Doc1", docId)
        }
        db.add(put)
        
        self.waitForExpectationsWithTimeout(10) { (_) in
            
        }
        
    }
}