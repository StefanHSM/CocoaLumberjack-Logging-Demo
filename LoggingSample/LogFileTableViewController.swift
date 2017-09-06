//
//  LogFileTableViewController.swift
//  LoggingSample
//
//  Created by Stefan Lahme on 05.09.17.
//  Copyright © 2017 Huf Secure Mobile GmbH. All rights reserved.
//

import UIKit
import CocoaLumberjack

class LogFileTableViewController: UITableViewController {
    
    // adding logs for demo use
    @IBAction func addTestLogs(sender: AnyObject) {
        DDLogVerbose("Another verbose log");
        DDLogDebug("Another debug log");
        DDLogInfo("Another info log");
        DDLogWarn("Another warning log");
        DDLogError("Another error log");
    }
    
    // finish current log file
    @IBAction func rollLogFile(sender: AnyObject) {
        let fileLogger = DDLog.allLoggers.last as! DDFileLogger
        
        fileLogger.rollLogFile(withCompletion: {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LogUtils().getLogFileNameArray()!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogFileCell", for: indexPath)
        
        // get log file names (and  cut off project name just for display reasons)
        let logFileNameComponents = LogUtils().getLogFileNameArray()![indexPath.row].components(separatedBy: " ")
        
        cell.textLabel?.text = logFileNameComponents.last
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "TextViewSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let logFileTextVC: LogFileTextViewController = segue.destination as! LogFileTextViewController
        logFileTextVC.logFileIndex = (self.tableView.indexPathForSelectedRow?.row)!
    }
}
