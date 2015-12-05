//
//  HTTPDNS.swift
//  HTTPDNS-SwiftDemo
//
//  Created by YourtionGuo on 12/4/15.
//  Copyright © 2015 Yourtion. All rights reserved.
//

import Foundation

class HTTPDNS {
    private let SERVER_ADDRESS = "http://119.29.29.29/"
    
    func requsetRecord(domain: String){
        let urlString = self.SERVER_ADDRESS + "d?dn=" + domain + "&ttl=1"
        let url = NSURL(string: urlString)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            if let data = data {
                self.parseResult(data)
            }
        }
        
        task.resume()
    }
    
    func parseResult (data: NSData) -> (ipList: Array<String>, ttl: Int){
        let str = String(data: data, encoding: NSUTF8StringEncoding)
        let strArray = str!.componentsSeparatedByString(",")
        let ttl = Int(strArray[1])
        let ipStr = strArray[0] as String
        let ipList = ipStr.componentsSeparatedByString(";") as Array<String>
        print(ipList, ttl)
        if (ipList.count > 0 && ttl > 0){
            return (ipList,ttl!)
        }
        return (ipList,ttl!)
    }
    
    
}