//
//  HTTPDNSTest.swift
//  HTTPDNS
//
//  Created by YourtionGuo on 6/24/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

import XCTest
import HTTPDNS

class HTTPDNSTest: XCTestCase {
    
    let client = HTTPDNS.sharedInstance
    let domain = "www.taobao.com"
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        client.cleanCache()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCache() {
        let record =  DNSRecord(ip: "127.0.0.1", ttl: 900, ips: ["127.0.0.1","127.0.0.2"])
        
        let rec1 = client.getCacheResult(domain)
        XCTAssertNil(rec1)
        
        client.setCache(domain, record: record)
        let rec2 = client.getCacheResult(domain)
        XCTAssertNotNil(rec2)
        XCTAssertEqual(rec2.ip, record.ip)
        XCTAssertEqual(rec2.cached, true)
        
        client.cleanCache()
        let rec3 = client.getCacheResult(domain)
        XCTAssertNil(rec3)
    }
    
    func testSyncDNSPod() {
        client.switchProvider(Provider.DNSPod, key: nil)
        
        let rec1 = client.getRecordSync(domain)
        XCTAssertNotNil(rec1)
        XCTAssertNotNil(rec1.ip)
        XCTAssertEqual(rec1.cached, false)
        
        let rec2 = client.getRecordSync(domain)
        XCTAssertNotNil(rec2)
        XCTAssertNotNil(rec2.ip)
        XCTAssertEqual(rec2.cached, true)
    }
    
    func testSyncAliYun() {
        client.switchProvider(Provider.AliYun, key: "100000")
        
        let rec1 = client.getRecordSync(domain)
        XCTAssertNotNil(rec1)
        XCTAssertNotNil(rec1.ip)
        XCTAssertEqual(rec1.cached, false)
        
        let rec2 = client.getRecordSync(domain)
        XCTAssertNotNil(rec2)
        XCTAssertNotNil(rec2.ip)
        XCTAssertEqual(rec2.cached, true)
    }
    
    func testDNSPod() {
        client.switchProvider(Provider.DNSPod, key: nil)
        
        let exp1 = self.expectationWithDescription("Handler called")
        client.getRecord(domain) { (rec1) in
            XCTAssertNotNil(rec1)
            XCTAssertNotNil(rec1.ip)
            XCTAssertEqual(rec1.cached, false)
            exp1.fulfill()
        }
        self.waitForExpectationsWithTimeout(10, handler: nil)
        
        let exp2 = self.expectationWithDescription("Handler called")
        client.getRecord(domain) { (rec1) in
            XCTAssertNotNil(rec1)
            XCTAssertNotNil(rec1.ip)
            XCTAssertEqual(rec1.cached, true)
            exp2.fulfill()
        }
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testAliYun() {
        client.switchProvider(Provider.AliYun, key: "100000")
        
        let exp1 = self.expectationWithDescription("Handler called")
        client.getRecord(domain) { (rec1) in
            XCTAssertNotNil(rec1)
            XCTAssertNotNil(rec1.ip)
            XCTAssertEqual(rec1.cached, false)
            exp1.fulfill()
        }
        self.waitForExpectationsWithTimeout(10, handler: nil)
        
        let exp2 = self.expectationWithDescription("Handler called")
        client.getRecord(domain) { (rec1) in
            XCTAssertNotNil(rec1)
            XCTAssertNotNil(rec1.ip)
            XCTAssertEqual(rec1.cached, true)
            exp2.fulfill()
        }
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }
    
}
