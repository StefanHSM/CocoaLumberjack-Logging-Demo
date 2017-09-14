//
//  LogFileListPresenter.swift
//  LoggingSample
//
//  Created by Stefan Lahme on 08.09.17.
//  Copyright © 2017 Huf Secure Mobile GmbH. All rights reserved.
//

import CocoaLumberjack
import Zip

protocol LogFileListUserInterface: class {
    func updateView()
}

class LogFileListPresenter {

    weak var view: LogFileListUserInterface?
    private let zipFileName = "log_files"
    
    /// Add logs for demo use
    func addTestLogs() {
        HSMLog(message: "Testlog", level: .verbose)
        HSMLog(message: "Testlog", level: .debug)
        HSMLog(message: "Testlog", level: .info)
        HSMLog(message: "Testlog", level: .warning)
        HSMLog(message: "Testlog", level: .error)
    }

    /// Finish current log file
    func rollLogFile() {
        LogUtils.getFileLogger()?.rollLogFile(withCompletion: {
            DispatchQueue.main.async {
                self.view?.updateView()
            }
        })
    }
    
    /// Get number of log files
    func getLogFileCount() -> Int {
        if LogUtils.getFileLogger()?.logFileManager.sortedLogFileNames.count != nil {
            return (LogUtils.getFileLogger()?.logFileManager.sortedLogFileNames.count)!
        }
        else {
            return 0
        }
    }
    
    /// Get log file name for row (and  cut off project name for display reasons)
    func getLogFileName(for row: Int) -> String? {
        return LogUtils.getFileLogger()?.logFileManager.sortedLogFileNames?[row].components(separatedBy: " ").last
    }
    
    /// Zip all log files and return data and path
    func getZipFileDataAndPath() -> (Data, URL?) {
        let logFilePathStringArray = LogUtils.getFileLogger()?.logFileManager.sortedLogFilePaths
        var logFilePathUrlArray = [URL]()
        var zipFileData = Data()
        var zipFilePath: URL?
        if logFilePathStringArray != nil {
            for logFilePathString in logFilePathStringArray! {
                logFilePathUrlArray.append(URL(fileURLWithPath: logFilePathString, isDirectory: false))
            }
        }
        do {
            zipFilePath = try Zip.quickZipFiles(logFilePathUrlArray, fileName: zipFileName)
            if !zipFilePath!.absoluteString.isEmpty
            {
                zipFileData = try Data(contentsOf:zipFilePath!)
            }
        }
        catch {
            print(error)
        }
        return (zipFileData, zipFilePath)
    }
    
    /// Remove zip file
    func removeZipFile(zipFilePath: URL?) {
        if zipFilePath != nil {
            do {
                try FileManager.default.removeItem(atPath: zipFilePath!.path)
            }
            catch {
                print(error)
            }
        }
    }
}
