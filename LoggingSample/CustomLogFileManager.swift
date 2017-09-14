//
//  CustomLogFileManager.swift
//  LoggingSample
//
//  Created by Stefan Lahme on 06.09.17.
//  Copyright © 2017 Huf Secure Mobile GmbH. All rights reserved.
//

import Foundation
import CocoaLumberjack

/// Create custom log file names
class CustomLogFileManager: DDLogFileManagerDefault {
    let dateFormat = "yyyy-MM-dd-HH:mm:ss"
    
    override var newLogFileName: String! {
        return String(format: "%@ %@.log", getAppName(), getTimeStamp())
    }
    
    override func isLogFile(withName _: String!) -> Bool {
        return true
    }
    
    func getTimeStamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: Date())
    }
    
    func getAppName() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
    }
}
