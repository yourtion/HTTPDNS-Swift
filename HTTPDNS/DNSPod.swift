//
//  DNSPod.swift
//  HTTPDNS
//
//  Created by YourtionGuo on 4/21/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

import Foundation

class DNSpod : HTTPDNSBase {
    let SERVER_ADDRESS = "http://119.29.29.29/"
    
    override func getRequestString(domain: String) -> String {
        return self.SERVER_ADDRESS + "d?dn=" + domain + "&ttl=1"
    }
    
    override func parseResult (data: NSData) -> DNSRecord! {
        let str = String(data: data, encoding: NSUTF8StringEncoding)
        let strArray = str!.componentsSeparatedByString(",")
        let ipStr = strArray[0] as String
        let ipList = ipStr.componentsSeparatedByString(";") as Array<String>
        guard let ttl = NSTimeInterval(strArray[1]) where (ipList.count > 0 && ttl > 0) else {
            return nil
        }
        return DNSRecord.init(ip: ipList[0], ttl: ttl, ips: ipList)
    }
    
}
