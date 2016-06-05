//
//  HTTPDNS.swift
//  HTTPDNS-SwiftDemo
//
//  Created by YourtionGuo on 12/4/15.
//  Copyright © 2015 Yourtion. All rights reserved.
//

import Foundation

public struct HTTPDNSResult {
    public let ip : String
    public let ips : Array<String>
    let timeout : Int
    public var cached : Bool
    
    public var description : String {
        return "ip: \(ip) \n ips: \(ips) \n cached: \(cached)"
    }
}

public class HTTPDNS {
    
    var cache = Dictionary<String,HTTPDNSResult>()
    
    /// HTTPDNS sharedInstance
    public static let sharedInstance = HTTPDNS()
    
    private init() {}
    
    let DNS = HTTPDNSFactory().getAliYun()
    
    /**
     Get DNS record asycn
     
     - parameter domain:   domain name
     - parameter callback: callback block with DNS record
     */
    public func getRecord(domain: String, callback: (result:HTTPDNSResult!) -> Void) {
        let res = getCacheResult(domain)
        if (res != nil) {
            return callback(result: res)
        }
        DNSpod().requsetRecord(domain, callback: { (res) -> Void in
            guard let res = self.DNS.requsetRecordSync(domain) else {
                return callback(result: nil)
            }
            callback(result: self.setCache(domain, record: res))
        })
    }
    
    /**
     Get DNS record sync (if not exist in cache return nil)
     
     - parameter domain: domain name
     
     - returns: DSN record
     */
    public func getRecordSync(domain: String) -> HTTPDNSResult! {
        guard let res = getCacheResult(domain) else {
            guard let res = self.DNS.requsetRecordSync(domain) else {
                return nil
            }
            return self.setCache(domain, record: res)
        }
        return res
    }
    
    /**
     Clean all DNS record cahce
     */
    public func cleanCache() {
        self.cache.removeAll()
    }
    
    func setCache(domain: String, record: DNSRecord) -> HTTPDNSResult {
        let timeout = Utils().getSecondTimestamp() + record.ttl
        var res = HTTPDNSResult.init(ip: record.ip, ips: record.ips, timeout: timeout, cached: true)
        self.cache.updateValue(res, forKey:domain)
        res.cached = false
        return res
    }
    
    func getCacheResult(domain: String) -> HTTPDNSResult! {
        guard let res = self.cache[domain] else {
            return nil
        }
        if (res.timeout >= Utils().getSecondTimestamp()){
            self.cache.removeValueForKey(domain)
            return nil
        }
        return res
    }

}