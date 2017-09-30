//
//  HTTPDNS.swift
//  HTTPDNS-SwiftDemo
//
//  Created by YourtionGuo on 12/4/15.
//  Copyright © 2015 Yourtion. All rights reserved.
//

import Foundation

/**
 *  HTTPDNS Result
 */
public struct HTTPDNSResult {
    /// IP address
    public let ip : String
    /// IP array
    public let ips : Array<String>
    /// Timeout
    let timeout : TimeInterval
    /// is Cached
    public var cached : Bool
    
    /// Description
    public var description : String {
        return "ip: \(ip) \n ips: \(ips) \n cached: \(cached)"
    }
}

/**
 HTTPDNS Provider
 
 - DNSPod: [DNSPod](https://www.dnspod.cn/httpdns)
 - AliYun: [AliYun](https://help.aliyun.com/product/9173596_30100.html)
 */
public enum Provider {
    /// DNSPod
    case dnsPod
    /// AliYun
    case aliYun
    /// Google
    case google
}

/// HTTPDNS Client
open class HTTPDNS {
    
    fileprivate init() {}
    fileprivate var cache = Dictionary<String,HTTPDNSResult>()
    fileprivate var DNS = HTTPDNSFactory().getDNSPod()
    
    /// HTTPDNS sharedInstance
    open static let sharedInstance = HTTPDNS()
    
    /**
     Switch HTTPDNS provider
     
     - parameter provider: DNSPod or AliYun
     - parameter key:      provider key
     */
    open func switchProvider (_ provider:Provider, key:String!) {
        self.cleanCache()
        switch provider {
        case .dnsPod:
            DNS = HTTPDNSFactory().getDNSPod()
            break
        case .aliYun:
            DNS = HTTPDNSFactory().getAliYun(key)
            break
        case .google:
            DNS = HTTPDNSFactory().getGoogle()
            break
        }
    }
    
    /**
     Get DNS record async
     
     - parameter domain:   domain name
     - parameter callback: callback block with DNS record
     */
    open func getRecord(_ domain: String, callback: @escaping (_ result:HTTPDNSResult?) -> Void) {
        let res = getCacheResult(domain)
        if (res != nil) {
            return callback(res)
        }
        DNS.requsetRecord(domain, callback: { (res) -> Void in
            if let res = res {
                callback(self.setCache(domain, record: res))
            } else {
                return callback(nil)
            }
        })
    }
    
    /**
     Get DNS record sync (if not exist in cache return nil)
     
     - parameter domain: domain name
     
     - returns: DSN record
     */
    open func getRecordSync(_ domain: String) -> HTTPDNSResult! {
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
    open func cleanCache() {
        self.cache.removeAll()
    }
    
    func setCache(_ domain: String, record: DNSRecord) -> HTTPDNSResult? {
        guard let _record = record else { return nil }
        let timeout = Date().timeIntervalSince1970 + Double(_record.ttl) * 1000
        var res = HTTPDNSResult.init(ip: _record.ip, ips: _record.ips, timeout: timeout, cached: true)
        self.cache.updateValue(res, forKey:domain)
        res.cached = false
        return res
    }
    
    func getCacheResult(_ domain: String) -> HTTPDNSResult! {
        guard let res = self.cache[domain] else {
            return nil
        }
        if (res.timeout <= Date().timeIntervalSince1970){
            self.cache.removeValue(forKey: domain)
            return nil
        }
        return res
    }

}
