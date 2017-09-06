//
//  Helpers.swift
//  LoggingSample
//
//  Created by Stefan Lahme on 06.09.17.
//  Copyright © 2017 Huf Secure Mobile GmbH. All rights reserved.
//

import Foundation
import CocoaLumberjack

// Utility class for accessing log file directory, names and content
class LogUtils {
    
    var fileManager = FileManager.default
    
    func getLogFileContent(logFileIndex: Int) -> String {
        let logFile = self.getLogFileNameArray()?[logFileIndex]
        let logFilePath = getDocumentsDirectoryPath().appendingPathComponent(logFile!)
        return try! String(contentsOf: logFilePath, encoding: String.Encoding.utf8)
    }
    
    func getLogFileNameArray() -> [String]? {
        return try? self.fileManager.contentsOfDirectory(atPath:self.getDocumentsDirectoryPath().path)
    }
    
    func getDocumentsDirectoryPath() -> URL {
        return self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
