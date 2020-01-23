//
//  ReportViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 12/05/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import DatingKit


class ReportViewController: UIViewController {
    
    static let reportNotify = Notification.Name("reported")
    
    @IBOutlet weak var otherReasonTextView: UITextView!
    @IBOutlet weak var otherReasonView: UIView!
    @IBOutlet var processingView: UIView!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var menuView: UIView!
    private var currentChat: ChatItem?
    
    
    func config(chat: ChatItem) {
        currentChat = chat
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        headerLabel.text = "What Went Wrong with " + (currentChat?.partnerName)! + "?"
        
    }
    
    @IBAction func tapOnOther(_ sender: UIButton) {
        menuView.isHidden = true
        otherReasonView.isHidden = false
//        otherReasonTextView
        otherReasonTextView.becomeFirstResponder()
    }
    
    @IBAction func tapOnInapproriatePhoto(_ sender: UIButton) {
        menuView.isHidden = true
        processingView.isHidden = false
        ReportManager.shared.report(in: Double(currentChat!.chatID), with: .InappropriatePhotos) { (data) in
            self.processingView.isHidden = true
            NotificationCenter.default.post(name: ReportViewController.reportNotify, object: self, userInfo: nil)
            self.dismiss(animated: true, completion: nil)
        }
//        RequestManager.shared.request(.chatsReport, params: ["chat_id" : currentChat?.chatID,
//                                                             "reason" : ReportReasons.InappropriatePhotos.rawValue,
//                                                             "wording" : ""])
//        { (data) in
//            let tech: Technical = data as! Technical
//            if tech.httpCode == 200 {
//
//            }
//        }
//
    }
    
    @IBAction func tapOnInappropriateMessage(_ sender: UIButton) {
        menuView.isHidden = true
        processingView.isHidden = false
        ReportManager.shared.report(in: Double(currentChat!.chatID), with: .InappropriateMessages) { (data) in
            self.processingView.isHidden = true
            NotificationCenter.default.post(name: ReportViewController.reportNotify, object: self, userInfo: nil)
            self.dismiss(animated: true, completion: nil)
        }
//        RequestManager.shared.request(.chatsReport, params: ["chat_id" : currentChat?.chatID,
//                                                             "reason" : ReportReasons.InappropriateMessages.rawValue,
//                                                             "wording" : ""])
//        { (data) in
//            let tech: Technical = data as! Technical
//            if tech.httpCode == 200 {
//                self.processingView.isHidden = true
//                NotificationCenter.default.post(name: ReportViewController.reportNotify, object: self, userInfo: nil)
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
//
    }
    
    @IBAction func tapOnSpam(_ sender: UIButton) {
        menuView.isHidden = true
        processingView.isHidden = false
        ReportManager.shared.report(in: Double(currentChat!.chatID), with: .spam) { (data) in
            self.processingView.isHidden = true
            NotificationCenter.default.post(name: ReportViewController.reportNotify, object: self, userInfo: nil)
            self.dismiss(animated: true, completion: nil)
        }
//        RequestManager.shared.request(.chatsReport, params: ["chat_id" : currentChat?.chatID,
//                                                             "reason" : ReportReasons.spam.rawValue,
//                                                             "wording" : ""])
//        { (data) in
//            let tech: Technical = data as! Technical
//            if tech.httpCode == 200 {
//                self.processingView.isHidden = true
//                NotificationCenter.default.post(name: ReportViewController.reportNotify, object: self, userInfo: nil)
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
    }
    
    @IBAction func tapOnClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapOnOtherCancel(_ sender: UIButton) {
        otherReasonView.isHidden = true
        otherReasonTextView.resignFirstResponder()
        menuView.isHidden = false

    }
    
    @IBAction func tapOnOtherSend(_ sender: UIButton) {
        otherReasonView.isHidden = true
        processingView.isHidden = false
        otherReasonTextView.resignFirstResponder()
        ReportManager.shared.report(in: Double(currentChat!.chatID), with: .other) { (data) in
            self.processingView.isHidden = true
            NotificationCenter.default.post(name: ReportViewController.reportNotify, object: self, userInfo: nil)
            self.dismiss(animated: true, completion: nil)
        }
//        RequestManager.shared.request(.chatsReport, params: ["chat_id" : currentChat?.chatID,
//                                                             "reason" : ReportReasons.other.rawValue,
//                                                             "wording" : otherReasonTextView.text])
//        { (data) in
//            let tech: Technical = data as! Technical
//            if tech.httpCode == 200 {
//                self.processingView.isHidden = true
//
//                NotificationCenter.default.post(name: ReportViewController.reportNotify, object: self, userInfo: nil)
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
