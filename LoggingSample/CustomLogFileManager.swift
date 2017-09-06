//
//  CustomLogFileManager.swift
//  LoggingSample
//
//  Created by Stefan Lahme on 06.09.17.
//  Copyright © 2017 Huf Secure Mobile GmbH. All rights reserved.
//

import Foundation
import CocoaLumberjack

// Class for creating custom log file names
class CustomLogFileManager: DDLogFileManagerDefault {
    override var newLogFileName: String! {
        get {
            return String(format: "%@ %@.log", getAppName(), getTimeStamp())
        }
    }
    
    override func isLogFile(withName fileName: String!) -> Bool {
        return false
    }
    
    func getTimeStamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY-HH:mm:ss"
        return dateFormatter.string(from: Date())
    }

    func getAppName() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
    }
}
