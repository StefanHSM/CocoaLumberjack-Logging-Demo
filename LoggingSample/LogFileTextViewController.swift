//
//  LogFileTextViewController.swift
//  LoggingSample
//
//  Created by Stefan Lahme on 05.09.17.
//  Copyright © 2017 Huf Secure Mobile GmbH. All rights reserved.
//

import UIKit

class LogFileTextViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    
    var logFileIndex: Int = 0
    
    // use activity view controller for sharing log files
    @IBAction func shareLogFile(sender: AnyObject)
    {
        var activityItems:[Any] = []
        activityItems.append(self.textView.text)
        let avc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        avc.setValue("Application Logs", forKey: "subject")
        avc.completionWithItemsHandler = {
            (s, ok, items, error) in
        }
        present(avc, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // get log file content and visualize in a textview
        let logFileContent = LogUtils().getLogFileContent(logFileIndex: logFileIndex)
        
        // layout for text view
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        
        let textAttributes: [String : Any] = [
            NSParagraphStyleAttributeName : style,
            NSFontAttributeName: UIFont(name: "Menlo", size: 13.0)!]
        
        self.textView.attributedText = NSAttributedString(string: logFileContent, attributes:textAttributes)
        self.textView.isEditable = false
        self.textView.textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
