//
//  HTTPDNS.swift
//  HTTPDNS-SwiftDemo
//
//  Created by YourtionGuo on 12/4/15.
//  Copyright © 2015 Yourtion. All rights reserved.
//

import Foundation

struct DNSRecord {
    let ip : String
    let ttl : Int
    let ips : Array<String>
}

class HTTPDNS {
    private let SERVER_ADDRESS = "http://119.29.29.29/"
    private var cache = Dictionary<String,DNSRecord>()
    
    static let sharedInstance = HTTPDNS()
    
    func getRecord(domain: String, callback: (result:DNSRecord!) -> Void) {
        let res = self.cache[domain]
        if (res != nil) {
            return callback(result: res)
        }
        requsetRecord(domain, callback: { (res) -> Void in
            callback(result: res)
        })
    }
    
    /**
     Get DNS record sync (if not exist in cache return nil)
     
     - parameter domain: domain name
     
     - returns: DSN record
     */
    func getRecordSync(domain: String) -> DNSRecord! {
        let res = self.cache[domain]
        if (res == nil) {
            requsetRecord(domain, callback: { (res) -> Void in })
            return nil
        }
        return res
    }
    
    private func requsetRecord(domain: String, callback: (result:DNSRecord!) -> Void) {
        let urlString = self.SERVER_ADDRESS + "d?dn=" + domain + "&ttl=1"
        guard let url = NSURL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            guard let data = data else {
                print("Error: data is nil")
                return
            }
            let res = self.parseResult(data)
            if (res.ipList.count > 0) {
                let record = DNSRecord.init(ip: res.ipList[0], ttl: res.ttl, ips: res.ipList)
                self.cache.updateValue(record, forKey: domain)
                callback(result: record)
            }
        }
        
        task.resume()
    }
    
    private func parseResult (data: NSData) -> (ipList: Array<String>, ttl: Int){
        let str = String(data: data, encoding: NSUTF8StringEncoding)
        let strArray = str!.componentsSeparatedByString(",")
        let ttl = Int(strArray[1])
        let ipStr = strArray[0] as String
        let ipList = ipStr.componentsSeparatedByString(";") as Array<String>
        print(ipList, ttl)
        if (ipList.count > 0 && ttl > 0){
            return (ipList,ttl!)
        }
        return ([],0)
    }
}