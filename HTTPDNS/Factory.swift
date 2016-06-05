//
//  Factory.swift
//  HTTPDNS
//
//  Created by YourtionGuo on 4/21/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

import Foundation

struct DNSRecord {
    let ip : String
    let ttl : Int
    let ips : Array<String>
}

enum CompassPoint {
    case DNSPod
    case DNSPodPro
    case AliYun
}

protocol HTTPDNSBaseProtocol {
    func parseResult (data: NSData) -> DNSRecord!
    func getRequestString(domain: String) -> String
}

class HTTPDNSBase: HTTPDNSBaseProtocol {
    
    func getRequestString(domain: String) -> String {
        return ""
    }
    
    func parseResult (data: NSData) -> DNSRecord! {
        return nil
    }
    
    func requsetRecord(domain: String, callback: (result:DNSRecord!) -> Void) {
        let urlString = getRequestString(domain)
        guard let url = NSURL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            guard let responseData = data else {
                print("Error: Didn't receive data")
                return
            }
            guard error == nil else {
                print("Error: Calling GET error on " + urlString)
                print(error)
                return
            }
            guard let res = self.parseResult(responseData) else {
                return callback(result: nil)
            }
            callback(result: res)
        }
        task.resume()
    }
    
    func requsetRecordSync(domain: String) -> DNSRecord! {
        let urlString = getRequestString(domain)
        print(urlString)
        guard let url = NSURL(string: urlString) else {
            print("Error: Can't create URL")
            return nil
        }
        guard let data = NSData.init(contentsOfURL: url) else {
            print("Error: Did not receive data")
            return nil
        }
        guard let res = self.parseResult(data) else {
            print("Error: ParseResult error")
            return nil
        }
        return res
    }

}

class HTTPDNSFactory {
    func getDNSPod() -> HTTPDNSBase {
        return DNSpod()
    }
    func getAliYun(key:String! = "100000") -> HTTPDNSBase {
        return AliYun(account:key)
    }
}