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
    
    override func getRequestString(_ domain: String) -> String {
        return self.SERVER_ADDRESS + "d?dn=" + domain + "&ttl=1"
    }
    
    override func parseResult (_ data: Data) -> DNSRecord! {
        let str = String(data: data, encoding: String.Encoding.utf8)
        let strArray = str!.components(separatedBy: ",")
        let ipStr = strArray[0] as String
        let ipList = ipStr.components(separatedBy: ";") as Array<String>
        guard let ttl = Int(strArray[1]), (ipList.count > 0 && ttl > 0) else {
            return nil
        }
        return DNSRecord.init(ip: ipList[0], ttl: ttl, ips: ipList)
    }
    
}
