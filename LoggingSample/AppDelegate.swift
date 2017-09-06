//
//  AppDelegate.swift
//  LoggingSample
//
//  Created by Stefan Lahme on 05.09.17.
//  Copyright © 2017 Huf Secure Mobile GmbH. All rights reserved.
//

import UIKit
import CocoaLumberjack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // setup for logging with cocoalumberjack
        // sharing files with itunes is intentionally limited to debugging. take a loot at "targets > build phases > run script".

        // set custom log formatter, see class LogFormatter.swift
        DDASLLogger.sharedInstance.logFormatter = CustomLogFormatter()
        DDTTYLogger.sharedInstance.logFormatter = CustomLogFormatter()
        
        // add apple system logger & console logger
        DDLog.add(DDASLLogger.sharedInstance)
        DDLog.add(DDTTYLogger.sharedInstance)
        
        // create log file manager and set documents directory as logs directory (for retrieval with iTunes)
        let logFileManager = CustomLogFileManager.init(logsDirectory: LogUtils().getDocumentsDirectoryPath().relativePath)
    
        // create and configure file logger
        let fileLogger: DDFileLogger = DDFileLogger(logFileManager: logFileManager)
        fileLogger.rollingFrequency = 60 * 60 * 24 // create log file at least every 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 14 // create log files for the last two weeks
        fileLogger.maximumFileSize = 1024 * 1024 // limit file size to 1 MB
        fileLogger.logFormatter = CustomLogFormatter()
        // fileLogger.doNotReuseLogFiles = true // when set, will always create a new log file at app launch
        
        // add file logger
        DDLog.add(fileLogger)
        // DDLog.add(fileLogger, with:DDLogLevel.debug) // filter the logs by log level

        // use logging example (in descending log level order)
        DDLogVerbose("Verbose");
        DDLogDebug("Debug");
        DDLogInfo("Info");
        DDLogWarn("Warning");
        DDLogError("Error");
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

