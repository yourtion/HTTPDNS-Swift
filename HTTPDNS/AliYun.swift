//
//  AliYun.swift
//  HTTPDNS
//
//  Created by YourtionGuo on 4/21/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

import Foundation

class AliYun : HTTPDNSBase {
    let SERVER_ADDRESS_HTTP = "http://203.107.1.1/"
    let SERVER_ADDRESS_HTTPS = "https://203.107.1.1/"
    var SERVER_ADDRESS: String
    var accountId : String
    
    init (account:String, https:Bool = true) {
        accountId = account
        if(https) {
            SERVER_ADDRESS = SERVER_ADDRESS_HTTPS
        } else {
            SERVER_ADDRESS = SERVER_ADDRESS_HTTP
        }
    }
    
    override func getRequestString(_ domain: String) -> String {
        return self.SERVER_ADDRESS + accountId + "/d?host=" + domain
    }
    
    override func parseResult (_ data: Data) -> DNSRecord! {
        do {
            let json = try JSONSerialization.jsonObject(with: data,options:JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            let ipList = json.object(forKey: "ips") as! Array<String>
            guard let ttl = json.object(forKey: "ttl") as? Int, (ipList.count > 0 && ttl > 0) else {
                return nil
            }
            return DNSRecord.init(ip: ipList[0], ttl: ttl, ips: ipList)
        } catch {
            print("error serializing JSON: \(error)")
            return nil
        }
    }
    
}
