//
//  LogFileTextViewController.swift
//  LoggingSample
//
//  Created by Stefan Lahme on 05.09.17.
//  Copyright © 2017 Huf Secure Mobile GmbH. All rights reserved.
//

import UIKit
import MessageUI

class LogFileTextViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var textView: UITextView!
    
    var logFileIndex: Int = 0
    private var presenter = LogFileTextPresenter()
    private let subject = "Log-Datei"
    private let messageBody = "Siehe Anhang"
    private let fontName = "Menlo"
    private let fontSize: CGFloat = 13
    private let lineSpacing: CGFloat = 5
    
    /// Share selected log file as plain text
    @IBAction func shareLogFile(sender: AnyObject) {
        var activityItems = [String]()
        activityItems.append(textView.text)
        let avc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        avc.setValue(subject, forKey: "subject")
        present(avc, animated: true, completion: nil)
    }
    
    /// Send selected log file as mail attachment
    @IBAction func mailWithAttachment(sender: AnyObject) {
        /// Check to see if the device can send emails
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            /// Set the subject and message of the email
            mailComposer.setSubject(subject)
            mailComposer.setMessageBody(messageBody, isHTML: false)
            mailComposer.addAttachmentData(presenter.getLogFileData(logFileIndex: logFileIndex), mimeType: "text/plain",
                                           fileName: presenter.getLogFileName(logFileIndex: logFileIndex))
            
            /// Present mailComposeController
            present(mailComposer, animated: true, completion: nil)
        }
    }
    
    /// Dismiss mailComposeController
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Layout text view
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        let textAttributes: [String : Any] = [
            NSParagraphStyleAttributeName : style,
            NSFontAttributeName: UIFont(name: fontName, size: fontSize)!]
        
        /// Get log file content and present in text view
        textView.attributedText = NSAttributedString(string: presenter.getLogFileContent(logFileIndex: logFileIndex),
                                                     attributes:textAttributes)
        textView.isEditable = false
        textView.textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping
    }
}
