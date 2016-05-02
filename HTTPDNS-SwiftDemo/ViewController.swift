//
//  ViewController.swift
//  HTTPDNS-SwiftDemo
//
//  Created by YourtionGuo on 11/26/15.
//  Copyright © 2015 Yourtion. All rights reserved.
//

import UIKit
import HTTPDNS

class ViewController: UIViewController,NSURLSessionDelegate,NSURLSessionDataDelegate {
    
    var data = NSMutableData()
    var host = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        HTTPDNS.sharedInstance.getRecord("qq.com", callback: { (result) -> Void in
            print("Async QQ.com", result)
        })
        
        print("Sync baidu.com", HTTPDNS.sharedInstance.getRecordSync("baidu.com"))
        
        requestHTTPS(NSURL(string: "https://api.github.com/users/octocat/orgs")!)
        
        requestHTTP(NSURL(string: "http://baidu.com/"))
        
        print("Sync baidu.com cached", HTTPDNS.sharedInstance.getRecordSync("baidu.com"))
        
    }
    
    func requestHTTPS(url:NSURL!) {
        let host = url.host
        self.host = host!
        let res = HTTPDNS.sharedInstance.getRecordSync(host!)
        let newURL = url.absoluteString.stringByReplacingOccurrencesOfString(host!, withString: res.ip)
        print("RequestHTTPS NewURL:\(newURL)")
        
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
        let request = NSMutableURLRequest(URL: NSURL(string: newURL)!)
        request.setValue(host, forHTTPHeaderField: "host")
        let task = session.dataTaskWithRequest(request)
        task.resume()
        
    }
    
    func requestHTTP(url:NSURL!) {
        let host = url.host
        let res = HTTPDNS.sharedInstance.getRecordSync(host!)
        let newURL = url.absoluteString.stringByReplacingOccurrencesOfString(host!, withString: res.ip)
        print("RequestHTTP NewURL:\(newURL)")
        
        let request = NSMutableURLRequest(URL: NSURL(string: newURL)!)
        request.setValue(host, forHTTPHeaderField: "host")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            let str = NSString(data: NSData(data: data!), encoding: NSUTF8StringEncoding)
            print("RequestHTTP response:\(str)") // IT PRINTS nil :(
        }
        task.resume()
        
    }
    
    
    func evaluateServerTrust(serverTrust:SecTrustRef!, domain:String!) -> Bool{
        /*
        * 创建证书校验策略
        */
        let policies = NSMutableArray()
        if (domain != nil) {
            policies.addObject(SecPolicyCreateSSL(true, domain))
        } else {
            policies.addObject(SecPolicyCreateBasicX509())
        }
    
        /*
        * 绑定校验策略到服务端的证书上
        */
        SecTrustSetPolicies(serverTrust,policies)
    
        /*
        * 评估当前serverTrust是否可信任，
        * 官方建议在result = kSecTrustResultUnspecified 或 kSecTrustResultProceed
        * 的情况下serverTrust可以被验证通过，https://developer.apple.com/library/ios/technotes/tn2232/_index.html
        * 关于SecTrustResultType的详细信息请参考SecTrust.h
        */
        var result = SecTrustResultType()
        SecTrustEvaluate(serverTrust, &result);
        
        return result == UInt32(kSecTrustResultUnspecified) || result == UInt32(kSecTrustResultProceed)
    }

    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
        var disposition:NSURLSessionAuthChallengeDisposition = .PerformDefaultHandling
        
        var credential = NSURLCredential()
        
        let host = self.host
        
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            if (self.evaluateServerTrust(challenge.protectionSpace.serverTrust!, domain: host)) {
                disposition = .UseCredential
                credential = NSURLCredential(forTrust:challenge.protectionSpace.serverTrust!)
            } else {
                disposition = .CancelAuthenticationChallenge
            }
        } else {
            disposition = .PerformDefaultHandling
        }
        // 对于其他的challenges直接使用默认的验证方案
        completionHandler(disposition, credential)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?){
        let str = NSString(data: NSData(data: self.data), encoding: NSUTF8StringEncoding)
        print("RequestHTTPS Response:\(str)") // IT PRINTS nil :(
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData){
        self.data.appendData(data)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

