//
//  AliYunTest.swift
//  HTTPDNS
//
//  Created by YourtionGuo on 4/21/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

import XCTest
import HTTPDNS

class Google_iOSTests: XCTestCase {
    
    let CLASS_HTTP = Google()
    let RES_Domain = "yourtion.com"
    let RES_String = "{\"Status\":0,\"TC\":false,\"RD\":true,\"RA\":true,\"AD\":false,\"CD\":false,\"Question\":[{\"name\":\"apple.com.\",\"type\":1}],\"Answer\":[{\"name\":\"apple.com.\",\"type\":1,\"TTL\":2365,\"data\":\"17.172.224.47\"},{\"name\":\"apple.com.\",\"type\":1,\"TTL\":2365,\"data\":\"17.178.96.59\"},{\"name\":\"apple.com.\",\"type\":1,\"TTL\":2365,\"data\":\"17.142.160.59\"}]}"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBasic() {
        XCTAssertEqual(CLASS_HTTP.SERVER_ADDRESS, "https://dns.google.com")
    }
    
    func testGetRequestString () {
        let REQ_String = CLASS_HTTP.getRequestString(RES_Domain)
        XCTAssertEqual(REQ_String, "https://dns.google.com/resolve?type=1&name=" + RES_Domain)
    }
    
    func testParseResult() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let RES_Data = RES_String.data(using: String.Encoding.utf8)
        let RES_Parsed = CLASS_HTTP.parseResult(RES_Data!)
        XCTAssertEqual(RES_Parsed?.ip, "17.172.224.47")
        XCTAssertEqual(RES_Parsed?.ips.count, 3)
        XCTAssertEqual(RES_Parsed?.ips[0], "17.172.224.47")
        XCTAssertEqual(RES_Parsed?.ips[1], "17.178.96.59")
        XCTAssertEqual(RES_Parsed?.ips[2], "17.142.160.59")
        XCTAssertEqual(RES_Parsed?.ttl, 2365)
    }
    
}
