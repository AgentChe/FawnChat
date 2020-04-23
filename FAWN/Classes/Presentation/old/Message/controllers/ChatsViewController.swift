//
//  ChatsViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 07/04/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import RevealingTableViewCell
import Amplitude_iOS
import DatingKit
import NotificationBannerSwift


class ChatsViewController: UIViewController {

    @IBOutlet var emptyMessage: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private var chats: [ChatItem] = [ChatItem]()
    private var paygateOnScreen: Bool = false

    private var isEditingCell: Bool = false
    
    func noInternet() {
        let banner = NotificationBanner(customView: NoInternetView.instanceFromNib())
        banner.show(on: self.navigationController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ChatsTableViewCell", bundle: .main), forCellReuseIdentifier: "ChatsTableViewCell")
        emptyMessage.alpha = 0.0
        tableView.alpha = 0.0
        tableView.isHidden = true
        emptyMessage.isHidden = true
        DatingKit.chat.getChatList { (result, status) in
            
            self.chats = result.itemsList
            if result.itemsList.count == 0 {
                self.tableView.isHidden = true
                if self.emptyMessage.isHidden {
                    self.emptyMessage.alpha = 0.0
                    UIView.animate(withDuration: 0.3, animations: {
                        self.emptyMessage.alpha = 1.0
                    }, completion: { (fin) in
                        self.emptyMessage.isHidden = false
                    })
                }
            } else {
                self.tableView.isHidden = false
                self.chats = result.itemsList
                self.tableView.reloadData()
          
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.tableView.alpha = 1.0
                    self.emptyMessage.alpha = 0.0
                }) { (_) in
                    self.emptyMessage.isHidden = true
                }
            }
            
            if status == .noInternetConnection {
                self.noInternet()
                return
            }
        }
    }

    @IBAction func tapOnNevSearch(_ sender: UIButton) {
        Amplitude.instance()?.log(event: .chatListNewSearchTap)
        NotificationCenter.default.post(name: SearchManager.startSearchNotify, object: nil)
    }
    
    @IBAction func tapOnProfile(_ sender: UIBarButtonItem) {
        ScreenManager.shared.showProfile()
    }
    
    @objc func showPaygate() {
        if paygateOnScreen == false {
            paygateOnScreen = true
            PurchaseManager.shared.loadProducts { (bundle) in
                self.performSegue(withIdentifier: "paygate", sender: bundle)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        
        Amplitude.instance()?.log(event: .chatListScr)
        SearchManager.shared.stopSearch()
        apper()
    }
    
    func apper() {
         DatingKit.chat.connect { (result, status) in
             self.chats = result.itemsList
             self.tableView.reloadData()
             self.tableView.isHidden = false
                    if result.itemsList.count == 0 {
                     self.tableView.alpha = 0.0
                        self.tableView.isHidden = true
                        
                        if self.emptyMessage.isHidden {
                            self.emptyMessage.alpha = 0.0
                            UIView.animate(withDuration: 0.3, animations: {
                                self.emptyMessage.alpha = 1.0
                            }, completion: { (fin) in
                                self.emptyMessage.isHidden = false
                            })
                        }
                    } else {
                         self.tableView.isHidden = false
                         
                         self.chats = result.itemsList
                         self.tableView.reloadData()
                        UIView.animate(withDuration: 0.3, animations: {
                             self.tableView.alpha = 1.0
                             self.emptyMessage.alpha = 0.0
                         }) { (_) in
                             self.emptyMessage.isHidden = true
                         }
                    }
                             
                   if status == .noInternetConnection {
                        self.noInternet()
                        return
                    }
                }
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DatingKit.chat.disconnect()
    }
    
   
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chat" {
             guard let chat: ChatItem = sender as? ChatItem else {
                 return
             }
             let chatVC: ChatViewController = segue.destination as! ChatViewController
             chatVC.config(with: chat)
         }
    }

}

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChatsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChatsTableViewCell", for: indexPath) as! ChatsTableViewCell
        cell.config(with: chats[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "chat", sender: self.chats[indexPath.section])
        }
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        isEditingCell = true
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
         isEditingCell = false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .default, title: "Report") { [weak self] (rowAction, indexPath) in
            let cell: ChatsTableViewCell = tableView.cellForRow(at: indexPath) as! ChatsTableViewCell
            let vc = ReportViewController(on: .chatInterlocutor(cell.item))
            vc.delegate = self
            self?.present(vc, animated: true)
        }
        editAction.backgroundColor = .clear
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Unmatch") { (rowAction, indexPath) in
            let message: String = "You'll never see " + self.chats[indexPath.section].partnerName + " ever again."
            let alert = UIAlertController(title: "Sure?", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.view.tintColor = #colorLiteral(red: 1, green: 0.5882352941, blue: 0.2, alpha: 1)
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
                let cell: ChatsTableViewCell = tableView.cellForRow(at: indexPath) as! ChatsTableViewCell
                ReportManager.shared.unmatch(in: Double(cell.item!.chatID), with: { (succses) in
//                    
                })
            }))
            alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        return [deleteAction, editAction]
    }
    
}

extension ChatsViewController: ReportViewControllerDelegate {
    func reportWasCreated(reportOn: ReportViewController.ReportOn) {}
}
