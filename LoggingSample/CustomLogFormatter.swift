//
//  CustomLogFormatter.swift
//  LoggingSample
//
//  Created by Stefan Lahme on 05.09.17.
//  Copyright © 2017 Huf Secure Mobile GmbH. All rights reserved.
//

import Foundation
import CocoaLumberjack

/// Create custom log formats
class CustomLogFormatter: NSObject, DDLogFormatter {
    func format(message logMessage: DDLogMessage) -> String? {
        return "\(logMessage.message)"
    }
}
