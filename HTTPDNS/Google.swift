//
//  AliYun.swift
//  HTTPDNS
//
//  Created by YourtionGuo on 4/21/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

import Foundation

class Google : HTTPDNSBase {
    let SERVER_ADDRESS = "https://dns.google.com"
    
    override func getRequestString(_ domain: String) -> String {
        return self.SERVER_ADDRESS + "/resolve?type=1&name=" + domain
    }
    
    override func parseResult (_ data: Data) -> DNSRecord! {
        do {
            let json = try JSONSerialization.jsonObject(with: data,options:JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            let answerList = json.object(forKey: "Answer") as! Array<NSDictionary>
            var ipList :Array<String> = Array()
            var ttl = -1
            for answer in answerList {
                if(answer.object(forKey: "type") as! Int == 1) {
                    ipList.append(answer.object(forKey: "data") as! String)
                    ttl = answer.object(forKey: "TTL") as! Int
                }
            }
            if ttl>0 && ipList.count > 0 {
                 return DNSRecord.init(ip: ipList[0], ttl: ttl, ips: ipList)
            }
            return nil
        } catch {
            print("error serializing JSON: \(error)")
            return nil
        }
    }
    
}
