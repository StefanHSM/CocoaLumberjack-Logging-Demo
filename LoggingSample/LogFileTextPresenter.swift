//
//  LogFileTextPresenter.swift
//  LoggingSample
//
//  Created by Stefan Lahme on 08.09.17.
//  Copyright © 2017 Huf Secure Mobile GmbH. All rights reserved.
//

import CocoaLumberjack

class LogFileTextPresenter {
    /// Get text content of a particular log file
    func getLogFileContent(logFileIndex: Int) -> String {
        var logFileContent: String = ""
        if let logFilePath = LogUtils.getFileLogger()?.logFileManager.sortedLogFilePaths[logFileIndex] {
            let logFileURL = URL(fileURLWithPath: logFilePath)
            do {
                try logFileContent = String(contentsOf: logFileURL, encoding: String.Encoding.utf8)
            }
            catch {
                print(error)
            }
        }
        return logFileContent
    }

    /// Get data content of a particular log file
    func getLogFileData(logFileIndex: Int) -> Data {
        var logFileData: Data = Data()
        if let logFilePath = LogUtils.getFileLogger()?.logFileManager.sortedLogFilePaths[logFileIndex] {
            let logFileURL = URL(fileURLWithPath: logFilePath)
            do {
                try logFileData = Data(contentsOf:logFileURL)
            }
            catch {
                print(error)
            }
        }
        return logFileData
    }
    
    /// Get name of a particular log file
    func getLogFileName(logFileIndex: Int) -> String {
        var logFileName: String = ""
        if let fileName = LogUtils.getFileLogger()?.logFileManager.sortedLogFileNames[logFileIndex] {
            logFileName = fileName
        }
        return logFileName
    }
}
