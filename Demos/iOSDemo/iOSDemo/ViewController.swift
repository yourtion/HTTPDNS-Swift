//
//  ViewController.swift
//  iOSDemo
//
//  Created by YourtionGuo on 15/12/2016.
//  Copyright © 2016 Yourtion. All rights reserved.
//

import UIKit
import HTTPDNS

class ViewController: UIViewController,URLSessionTaskDelegate {
    
    @IBOutlet weak var resultText: UITextView!
    @IBOutlet weak var urlField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        HTTPDNS.sharedInstance.switchProvider(.google, key: nil)
//        HTTPDNS.sharedInstance.getRecord("apple.com", callback: { (result) -> Void in
//            print("Async QQ.com ", result ?? "Faild")
//        })
        
        requestHTTPS(URL(string: "https://api.github.com/users/octocat/orgs"))
        
//        requestHTTP(URL(string: "http://baidu.com/"))

    }

    func requestHTTPS(_ url:URL!) {
        let host = url.host
        let res = HTTPDNS.sharedInstance.getRecordSync(host!)
        var newURL = url.absoluteString
        if (res != nil) {
          newURL = url.absoluteString.replacingOccurrences(of: host!, with: (res?.ip)!)
        }
        print("RequestHTTPS NewURL:\(newURL)")
        
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL(string: newURL)!)
        request.setValue(host, forHTTPHeaderField: "host")
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            let str = String(data: data!, encoding: String.Encoding.utf8)
            print("RequestHTTP response:\(str)") // IT PRINTS nil :(
        }

        task.resume()
        
    }
    
    func requestHTTP(_ url:URL!) {
        let host = url.host
        let res = HTTPDNS.sharedInstance.getRecordSync(host!)
        var newURL = url.absoluteString
        if (res != nil) {
            newURL = url.absoluteString.replacingOccurrences(of: host!, with: (res?.ip)!)
        }
        print("RequestHTTP NewURL:\(newURL)")
        
        let request = NSMutableURLRequest(url: URL(string: newURL)!)
        request.setValue(host, forHTTPHeaderField: "host")
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            let str = String(data: data!, encoding: String.Encoding.utf8)
            print("RequestHTTP response:\(str)") // IT PRINTS nil :(
        }
        task.resume()
        
    }
    
    func evaluateServerTrust(_ serverTrust:SecTrust!, domain:String!) -> Bool{
        /*
         * 创建证书校验策略
         */
        let policies = NSMutableArray()
        if (domain != nil) {
            policies.add(SecPolicyCreateSSL(true, domain as CFString?))
        } else {
            policies.add(SecPolicyCreateBasicX509())
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
        var result:SecTrustResultType = .deny
        SecTrustEvaluate(serverTrust, &result)
        
        return result == .unspecified || result == .proceed
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        var disposition:URLSession.AuthChallengeDisposition = .performDefaultHandling
        
        var credential = URLCredential()
        
        var host = task.originalRequest?.allHTTPHeaderFields?["Host"]
        if (host == nil) {
            host = task.originalRequest?.url?.host
        }
        
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            if (self.evaluateServerTrust(challenge.protectionSpace.serverTrust!, domain: host)) {
                disposition = .useCredential
                credential = URLCredential(trust:challenge.protectionSpace.serverTrust!)
            } else {
                disposition = .cancelAuthenticationChallenge
            }
        } else {
            disposition = .performDefaultHandling
        }
        // 对于其他的challenges直接使用默认的验证方案
        completionHandler(disposition, credential)
    }
    

}
