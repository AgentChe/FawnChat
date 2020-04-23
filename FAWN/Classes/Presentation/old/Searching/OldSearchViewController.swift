//
//  SearchViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 15/04/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import QuartzCore
import Amplitude_iOS
import DatingKit
import NotificationBannerSwift

enum SearchScreenStates {
    case searchAndFound
    case timeOut
    case noOne
    case sayNo
    case none
    case manualy
}

class OldSearchViewController: UIViewController {
    
    private var isAnimate: Bool = false
    private var userShow: UserShow?
    private var paygateOnScreen: Bool = false
    private var match: Match!
    private var animator: UIViewPropertyAnimator?
    private var currentState: SearchScreenStates = .none
    private var currentMatch: DKMatch!
    private var isSearch: Bool = false
    private var searchScene: SearchView = SearchView.instanceFromNib()
    private var noScene: SayNoView = SayNoView.instanceFromNib()
    private var noOneScene: NoOneView = NoOneView.instanceFromNib()
    private var timeOutScene: TimeOutView = TimeOutView.instanceFromNib()
    private var manualyScene: ManualySearchView = ManualySearchView.instanceFromNib()
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Amplitude.instance()?.log(event: .searchScr)
        UIApplication.shared.isIdleTimerDisabled = true
        DatingKit.user.show { (userShow, status) in
            
            if status == .noInternetConnection {
                let banner = NotificationBanner(customView: NoInternetView.instanceFromNib())
                banner.show(on: self.navigationController)
                return
            }
            
            if status == .succses {
                guard let user: UserShow = userShow else { return }
                self.userShow = user
                
                if self.isSearch == false {
                    self.startSearch()
                }
                
                if self.currentState != .searchAndFound  {
                    self.set(state: .searchAndFound)
                }
                
            }
            
        }
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
        if self.isSearch == true {
            isSearch = false
            DatingKit.search.stopAll()
        }
       
    }
    
    
    // MARK: - layout
    
    func set(state: SearchScreenStates) {
        
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        currentState = state
        
        switch state {
        case .searchAndFound:
            setSearchScene()
            break
        case .timeOut:
            setTimeOutScene()
            break
        case .noOne:
            setNoOneScene()
            break
        case .sayNo:
            setNoViewScene()
            break
        case .none:
            break
        case .manualy:
            setManualyScene()
            break
        }
        
    }
    
    func setManualyScene() {
        manualyScene = ManualySearchView.instanceFromNib()
        manualyScene.frame = CGRect(x: 0,
                                    y: 0.0,
                                    width: view.frame.size.width,
                                    height: view.frame.size.height)
        manualyScene.newSearchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
        view.addSubview(manualyScene)
    }
    
    func setTimeOutScene() {
        timeOutScene = TimeOutView.instanceFromNib()
        timeOutScene.frame = CGRect(x: 0,
                                    y: 0.0,
                                    width: view.frame.size.width,
                                    height: view.frame.size.height)
        timeOutScene.newSearch.addTarget(self, action: #selector(search), for: .touchUpInside)
        view.addSubview(timeOutScene)
    }
    
    func setNoOneScene() {
        noOneScene = NoOneView.instanceFromNib()
        
        noOneScene.config()
        
        noOneScene.frame = CGRect(x: 0,
                                  y: 0.0,
                                  width: view.frame.size.width,
                                  height: view.frame.size.height)
        noOneScene.newSearchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
        noOneScene.skipButton.addTarget(self, action: #selector(skipBTN), for: .touchUpInside)
        noOneScene.sureButton.addTarget(self, action: #selector(requestNotify), for: .touchUpInside)
        view.addSubview(noOneScene)
    }
    
    func setSearchScene() {
        searchScene = SearchView.instanceFromNib()
        
        guard let user: UserShow = self.userShow else { return }
        searchScene.config(user: user)
        searchScene.frame = CGRect(x: 0,
                                   y: 0.0,
                                   width: view.frame.size.width,
                                   height: view.frame.size.height)
        searchScene.skipButton.addTarget(self, action: #selector(skip), for: .touchUpInside)
        searchScene.sureButton.addTarget(self, action: #selector(yes), for: .touchUpInside)
        view.addSubview(searchScene)
        
    }
    
    func setNoViewScene() {
        noScene = SayNoView.instanceFromNib()
        noScene.frame = CGRect(x: 0,
                                y: 0.0,
                                width: view.frame.size.width,
                                height: view.frame.size.height)
        noScene.newSearchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
        noScene.config()
        view.addSubview(noScene)
    }
    
    
    //MARK: - Actions
    
    @objc func skip() {
        isSearch = false
        startSearch()
        sayNo()
    }
    
    @objc func showPaygate() {
        PurchaseManager.shared.loadProducts { (bundle) in
            self.performSegue(withIdentifier: "pay", sender: bundle)
        }
    }
    
    @objc func yes() {
        sayYes()
    }
    
    @objc func skipBTN() {
        noOneScene.showSearchView()
    }
    
    @objc func requestNotify() {
        let alertController = UIAlertController (title: "“FAWN” Would Like to Send You Notifications", message: "To manage push notifications you'll need to enable them in app's settings first", preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    self.noOneScene.showSearchView()
                })
            }
        }
        
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    @objc func search() {
        isSearch = false
        set(state: .searchAndFound)
        startSearch()
    }
    
    
    //MARK: - Network
    
    func sayNo() {
        guard let match: DKMatch = self.currentMatch else {
            return
            
        }
        
        DatingKit.search.sayNo(matchID: match.matchID) { (status) in
            if status == .noInternetConnection {
                let banner = NotificationBanner(customView: NoInternetView.instanceFromNib())
                banner.show(on: self.navigationController)
                return
            }
            
            if status == .needPayment {
                self.showPaygate()
                return
            }
            
            if status == .succses {
                
            }
            
        }
    }
    
    func sayYes() {
        
        guard let match: DKMatch = currentMatch else { return }
        
        DatingKit.search.sayYes(matchID: match.matchID) { (matchStatus, status) in
             switch status {
             case .succses:
                switch matchStatus {
                case .waitPartnerAnser:
                    break
                case .timeOut:
                    self.set(state: .timeOut)
                    break
                case .deny:
                    self.isSearch = false
                    self.set(state: .sayNo)
                    break
                case .confirmPending:
                    self.performSegue(withIdentifier: "chat", sender: match.matchID)
                    self.set(state: .searchAndFound)
                    NotificationCenter.default.post(name: MainViewController.showChatsNotify, object: nil)
                    break
                    
                    
                    
//
                case .lostChat:
                    break
                case .report:
                    break
                case .cantAnswer:
                    break
                }
                
             case .noInternetConnection:
                
                switch matchStatus {
                case .cantAnswer:
                    let banner = NotificationBanner(customView: NoInternetView.instanceFromNib())
                    banner.show(on: self.navigationController)

                    break
                    
                case .waitPartnerAnser:
                    
                    let banner = NotificationBanner(customView: NoInternetView.instanceFromNib())
                    banner.show(on: self.navigationController)

                    break
                                        
                default:
                    break
                }
             case .needPayment:
                self.showPaygate()
                break
             case .forbitten:
                if matchStatus == .cantAnswer {
                    self.set(state: .timeOut)
                }
             default:
                break
            }
        }
    }
    
    func startSearch() {
        guard let user: UserShow = userShow else {return}
        
        isSearch = true
        
        DatingKit.search.startSearch(email: user.email) { (match, status) in
            switch status {
              case .succses:
                self.currentMatch = match
                self.searchScene.set(match: match)
              case .noInternetConnection:
                let banner = NotificationBanner(customView: NoInternetView.instanceFromNib())
                banner.show(on: self.navigationController)
              case .needPayment:
                  self.showPaygate()
                break
              case .timeOut:
                self.set(state: .noOne)
                break
              default:
                  break
              }
        }
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "pay" {
            guard let paygate: PaygateViewController = segue.destination as? PaygateViewController else {return}
            paygate.delegate = self
            set(state: .manualy)
            let config: ConfigBundle = sender as! ConfigBundle
            paygate.config(bundle: config)
        }
        
        if segue.identifier == "chat" {
    
            guard let metch: DKMatch = currentMatch else {
                return
            }
            let chatItem: ChatItem = ChatItem(chatID: metch.matchID, partnerName: metch.matchedUserName, avatarURL: metch.matchedAvatarString)
            let chatVC: ChatViewController = segue.destination as! ChatViewController
            chatVC.config(with: chatItem)
        }
    }
}

extension OldSearchViewController: PaygateViewDelegate {
    
    
    
    func purchaseWasEndet() {
        DatingKit.search.stopAll()
        set(state: .manualy)
    }
    
    
}
    

extension OldSearchViewController: MainViewControllerDelegate {
    
    func tapOnChats() {
        self.performSegue(withIdentifier: "pause", sender: nil)
    }
    
    func tapOnSearch() {
        
    }
    
}
