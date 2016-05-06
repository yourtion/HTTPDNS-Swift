//
//  AliYunTest.swift
//  HTTPDNS
//
//  Created by YourtionGuo on 4/21/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

import XCTest
import HTTPDNS

class AliYun_iOSTests: XCTestCase {
    
    let CLASS = AliYun(account:"100000")
    let RES_Domain = "yourtion.com"
    let RES_String = "{\"host\":\"yourtion.com\",\"ips\":[\"192.243.118.110\",\"192.243.118.111\",\"192.243.118.112\"],\"ttl\":600}"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBasic() {
        XCTAssertEqual(CLASS.SERVER_ADDRESS, "http://203.107.1.1/")
    }
    
    func testGetRequestString () {
        let REQ_String = CLASS.getRequestString(RES_Domain)
        XCTAssertEqual(REQ_String, "http://203.107.1.1/100000/d?host=" + RES_Domain)
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
