//
//  Utils.swift
//  HTTPDNS
//
//  Created by YourtionGuo on 4/21/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

import Foundation

class Utils {
    func getSecondTimestamp() -> Int {
        return Int(NSDate().timeIntervalSince1970 * 1000)
    }
}