//
//  MainViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 26/03/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import DatingKit


protocol MainViewControllerDelegate: class {
    func tapOnChats()
    func tapOnSearch()
}

class MainViewController: UIViewController {
    
    public static let showChatsNotify = Notification.Name(rawValue: "showChatsNotify")

    @IBOutlet weak var pauseView: UIStackView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var profileItem: UIBarButtonItem!
    @IBOutlet weak var mainPageController: UIView!
    @IBOutlet weak var helloView: HelloView!
    
    var paygateOnScreen: Bool = false
    weak var delegate:MainViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScreenManager.shared.mainViewController = self
        searchButton.setImage(#imageLiteral(resourceName: "search_btn_hight"), for: .normal)
        chatButton.setImage(#imageLiteral(resourceName: "chat_btn"), for: .normal)
        profileItem.image = nil
        profileItem.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(search), name: SearchManager.startSearchNotify, object: nil)
        ScreenManager.shared.generalController = self
        helloView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(showChat), name: NotificationManager.kMessageNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideHelloView), name: MainViewController.showChatsNotify, object: nil)
        
        
        
    }
    
    @objc func showChat() {
        if let chat: ChatItem = ScreenManager.shared.chatItemOnScreen {
            if let pushChat: ChatItem = ScreenManager.shared.pushChat {
                if pushChat.chatID != chat.chatID {
                    performSegue(withIdentifier: "chat", sender: nil)
                } 
            }
        } else {
            DatingKit.chat.disconnect()
            performSegue(withIdentifier: "chat", sender: nil)
        }
    }
    
    @objc func hideHelloView() {
        delegate?.tapOnChats()
        chatButton.setImage(#imageLiteral(resourceName: "chat_btn_hight"), for: .normal)
        searchButton.setImage(#imageLiteral(resourceName: "search_btn"), for: .normal)
        profileItem.image = #imageLiteral(resourceName: "profile_icon")
        profileItem.isEnabled = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if ScreenManager.shared.showChat {
            guard let chat: ChatItem = ScreenManager.shared.pushChat else { return }
            performSegue(withIdentifier: "chat", sender: nil)
        }

    }
    
    @IBAction func tapOnSearch(_ sender: UIButton) {
        search()
//        SearchManager.shared.startSearch()
    }
    
    @IBAction func tapOnChats(_ sender: UIButton) {
        delegate?.tapOnChats()
//        pauseView.isHidden = false
        sender.setImage(#imageLiteral(resourceName: "chat_btn_hight"), for: .normal)
        searchButton.setImage(#imageLiteral(resourceName: "search_btn"), for: .normal)
        profileItem.image = #imageLiteral(resourceName: "profile_icon")
        profileItem.isEnabled = true
    }
    
    @objc func search() {
        searchButton.setImage(#imageLiteral(resourceName: "search_btn_hight"), for: .normal)
        chatButton.setImage(#imageLiteral(resourceName: "chat_btn"), for: .normal)
        profileItem.image = nil
        profileItem.isEnabled = false
        
        delegate?.tapOnSearch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "page" {
            let pageViewController: PageViewController = segue.destination as! PageViewController
            delegate = pageViewController
        }
        if segue.identifier == "paygate" {
            let paygate: PaygateViewController = segue.destination as! PaygateViewController
            paygate.delegate = self
            let config: ConfigBundle = sender as! ConfigBundle
            paygate.config(bundle: config)
        }
        if segue.identifier == "chat" {
            guard let chat: ChatItem = ScreenManager.shared.pushChat else { return }
            delegate?.tapOnChats()
            chatButton.setImage(#imageLiteral(resourceName: "chat_btn_hight"), for: .normal)
            searchButton.setImage(#imageLiteral(resourceName: "search_btn"), for: .normal)
            profileItem.image = #imageLiteral(resourceName: "profile_icon")
            profileItem.isEnabled = true
            let chatVC: ChatViewController = segue.destination as! ChatViewController
            chatVC.config(with: chat)
        }
    }
}


extension MainViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    
}

extension MainViewController: PaygateViewDelegate {
    func purchaseWasEndet() {
        paygateOnScreen = false
        mainPageController.isHidden = false
        helloView.isHidden = true
        searchButton.isUserInteractionEnabled = true
        chatButton.isUserInteractionEnabled = true
    }
    
}
