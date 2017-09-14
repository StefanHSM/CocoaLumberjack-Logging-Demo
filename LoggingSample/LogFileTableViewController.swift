//
//  LogFileTableViewController.swift
//  LoggingSample
//
//  Created by Stefan Lahme on 05.09.17.
//  Copyright © 2017 Huf Secure Mobile GmbH. All rights reserved.
//

import UIKit
import MessageUI

class LogFileTableViewController: UITableViewController, LogFileListUserInterface, MFMailComposeViewControllerDelegate {
    
    var presenter = LogFileListPresenter()
    private var zipFileData = Data()
    private var zipFilePath: URL?
    private let logFileCellName = "LogFileCell"
    private let textViewSegueName = "TextViewSegue"
    private let numberOfTableViewSections = 1
    
    override func viewDidLoad() {
        presenter.addTestLogs()
        updateView()
    }
    
    /// Add logs for demo use
    @IBAction func addTestLogs(sender: AnyObject) {
        presenter.addTestLogs()
        updateView()
    }
    
    /// Finish current log file
    @IBAction func rollLogFile(sender: AnyObject) {
        presenter.rollLogFile()
    }
    
    /// Mail log files as zipped attachment
    @IBAction func mailAllZippedLogs(sender: AnyObject) {
        /// Check to see if the device can send emails
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            zipFileData = presenter.getZipFileDataAndPath().0
            zipFilePath = presenter.getZipFileDataAndPath().1
            
            /// Set the subject and message of the email
            mailComposer.setSubject("Versende alle Log-Dateien als ZIP")
            mailComposer.setMessageBody("Siehe unten...", isHTML: false)
            mailComposer.addAttachmentData(zipFileData, mimeType: "application/gzip", fileName: "log_files.zip")

            /// Present mail composer
            present(mailComposer, animated: true, completion: nil)
        }
    }
    
    /// Remove zip file and dismiss mailComposeController
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        presenter.removeZipFile(zipFilePath: zipFilePath)
        controller.dismiss(animated: true, completion: nil)
    }

    /// Create table view sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfTableViewSections
    }

    /// Create a table view row for every log file
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getLogFileCount()
    }

    /// Assign the log file name to the text label
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: logFileCellName, for: indexPath)
        cell.textLabel?.text = presenter.getLogFileName(for: indexPath.row)
        return cell
    }
    
    /// Display text view for selected log file
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: textViewSegueName, sender: self)
    }
    
    /// Assign selected log file index to destination view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let logFileTextVC: LogFileTextViewController = segue.destination as! LogFileTextViewController
        if ((tableView.indexPathForSelectedRow?.row) != nil) {
            logFileTextVC.logFileIndex = (tableView.indexPathForSelectedRow?.row)!
        }
    }
    
    // MARK: LogFileListView

    func updateView() {
        tableView.reloadData()
    }
}
