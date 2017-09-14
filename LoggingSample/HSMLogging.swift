//
//  HSMLogging.swift
//  LoggingSample
//
//  Created by Stefan Lahme on 13.09.17.
//  Copyright © 2017 Huf Secure Mobile GmbH. All rights reserved.
//

import Foundation

/// Log level definition
public enum LogLevel: Int {
    case error, warning, info, debug, verbose
    
    func toString() -> String {
        switch self {
            case .error:
                return "Error"
            case .warning:
                return "Warning"
            case .info:
                return "Info"
            case .debug:
                return "Debug"
            case .verbose:
                return "Verbose"
        }
    }
}

/// HSMLogging interface declaration
protocol HSMLogging {
    func HSMLog(message: @autoclosure () -> String, file: String, function: StaticString, line: UInt, level: LogLevel)
}

/// HSMLogging interface extension (necessary for using default values in function declarations)
extension HSMLogging {
    func log(message: @autoclosure () -> String, file: String = #file, function: StaticString = #function, line: UInt = #line,
             level: LogLevel)
    {
        HSMLog(message: message, file: file, function: function, line: line, level: level)
    }
}

/// LogManager
public class LogManager {
    static var logger: HSMLogging?
    static let dateFormatter: DateFormatter = createDateFormatter()
    static var logLevel: LogLevel = LogLevel.error

    private class func createDateFormatter() -> DateFormatter {
        let dateFormat = "yyyy-MM-dd HH:mm:ss"
        let localeIdentifier = "DE_de"
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: localeIdentifier)
        formatter.dateFormat = dateFormat
        return formatter
    }
}

/// Definition of public function HSMLog
public func HSMLog(message: @autoclosure () -> String, file: String = #file, function: StaticString = #function,
                   line: UInt = #line, level: LogLevel) {
    var _file = String()
    
    if file.components(separatedBy: "/").last != nil {
        _file = file.components(separatedBy: "/").last!
    }
    
    if let logger = LogManager.logger {
        logger.log(message: message, file: _file, function: function, line: line, level: level)
    }
    else if level.rawValue > LogManager.logLevel.rawValue
    {
        let date = LogManager.dateFormatter.string(from: Date())
        print("\(date) [\(_file):\(function):\(line)] \(level.toString()): \(message())")
    }
}


