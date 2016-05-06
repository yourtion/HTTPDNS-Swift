//
//  HTTPDNSTests.swift
//  HTTPDNSTests
//
//  Created by YourtionGuo on 1/10/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

import XCTest
import HTTPDNS

class DNSPod_iOSTests: XCTestCase {
    
    let CLASS = DNSpod()
    let RES_Domain = "yourtion.com"
    let RES_String = "192.243.118.110;192.243.118.111;192.243.118.112,600"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBasic() {
        XCTAssertEqual(CLASS.SERVER_ADDRESS, "http://119.29.29.29/")
    }
    
    func testGetRequestString () {
        let REQ_String = CLASS.getRequestString(RES_Domain)
        XCTAssertEqual(REQ_String, "http://119.29.29.29/d?dn=" + RES_Domain + "&ttl=1")
    }
    
    func testParseResult() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let RES_Data = RES_String.dataUsingEncoding(NSUTF8StringEncoding)
        let RES_Parsed = CLASS.parseResult(RES_Data!)
        XCTAssertEqual(RES_Parsed.ip, "192.243.118.110")
        XCTAssertEqual(RES_Parsed.ips.count, 3)
        XCTAssertEqual(RES_Parsed.ips[0], "192.243.118.110")
        XCTAssertEqual(RES_Parsed.ips[1], "192.243.118.111")
        XCTAssertEqual(RES_Parsed.ips[2], "192.243.118.112")
        XCTAssertEqual(RES_Parsed.ttl, 600)
    }
    
}
