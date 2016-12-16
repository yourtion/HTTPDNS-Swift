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

protocol HTTPDNSBaseProtocol {
    func parseResult (_ data: Data) -> DNSRecord!
    func getRequestString(_ domain: String) -> String
}

class HTTPDNSBase: HTTPDNSBaseProtocol {
    
    func getRequestString(_ domain: String) -> String {
        return ""
    }
    
    func parseResult (_ data: Data) -> DNSRecord! {
        return nil
    }
    
    func requsetRecord(_ domain: String, callback: @escaping (_ result:DNSRecord?) -> Void) {
        let urlString = getRequestString(domain)
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            guard let responseData = data else {
                print("Error: Didn't receive data")
                return
            }
            guard error == nil else {
                print("Error: Calling GET error on " + urlString)
                print(error!)
                return
            }
            guard let res = self.parseResult(responseData) else {
                return callback(nil)
            }
            callback(res)
        }) 
        task.resume()
    }
    
    func requsetRecordSync(_ domain: String) -> DNSRecord! {
        let urlString = getRequestString(domain)
        print(urlString)
        guard let url = URL(string: urlString) else {
            print("Error: Can't create URL")
            return nil
        }
        guard let data = try? Data.init(contentsOf: url) else {
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
    func getAliYun(_ key:String = "100000") -> HTTPDNSBase {
        return AliYun(account:key)
    }
}
