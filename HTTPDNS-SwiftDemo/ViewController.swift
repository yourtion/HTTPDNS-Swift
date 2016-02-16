//
//  ViewController.swift
//  HTTPDNS-SwiftDemo
//
//  Created by YourtionGuo on 11/26/15.
//  Copyright © 2015 Yourtion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        HTTPDNS.sharedInstance.getRecord("qq.com", callback: { (result) -> Void in
            print("Async QQ.com", result)
        })
        print("Sync baidu.com", HTTPDNS.sharedInstance.getRecordSync("baidu.com"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

