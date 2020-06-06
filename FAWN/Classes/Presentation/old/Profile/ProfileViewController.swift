//
//  ProfileViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 08/04/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import DatingKit


class ProfileViewController: UIViewController {
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isHidden = false
        
        DatingKit.user.show { (userShow, status) in
            if status == .succses {
                guard let user: UserShow = userShow else {
                    return
                }
                self.emailLabel.text = user.email
                self.nameLabel.text = user.name
                if let url: URL = URL(string: user.avatarURL) {
                    self.avatarImageView.af_setImage(withURL: url)
                }
            }
        }
    }
    
    func requestNotify() {
        let alertController = UIAlertController (title: "“FAWN” Would Like to Send You Notifications", message: "To manage push notifications you'll need to enable them in app's settings first", preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                    self.noOneScene.showSearchView()
                })
            }
        }
        
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.sectionFooterHeight = 25.0
//        tableView.sectionHeaderHeight = 20.0
    }
    
    
    @IBAction func tapOnMenu(_ sender: UIButton) {
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        actionSheet.addAction(UIAlertAction(title: "Clear Chat History", style: .default, handler: { (action) in
//
//        }))
        actionSheet.addAction(UIAlertAction(title: "Delete Account...", style: .destructive, handler: { [weak self] (action) in
            self?.performSegue(withIdentifier: "delete", sender: nil)

        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = sender
//            popoverController.sourceRect = sender.frame
        }
        present(actionSheet, animated: true, completion: nil)
    }
}


extension ProfileViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                let text: String = "Check out FAWN... the gay anonymous chat"
                if let myWebsite = NSURL(string: "https://apps.apple.com/us/app/fawn-gay-chat-anonymous/id1462068523") {
                    let objectsToShare = [text, myWebsite] as [Any]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    activityVC.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList]
                    activityVC.popoverPresentationController?.sourceView = tableView.cellForRow(at: indexPath)
                    self.present(activityVC, animated: true, completion: nil)
                }
            }
            
            if indexPath.row == 1 {
                activityView.isHidden = false
                UIView.animate(withDuration: 0.5) {
                    self.activityView.alpha = 1.0
                }
                PurchaseManager.shared.restore { (status) in
                    switch status {
                    case .failed:
                        let alert = UIAlertController(title: "ERROR", message: "Restore Failed", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                            UIView.animate(withDuration: 0.4, animations: {
                                self.activityView.alpha = 0.0
                            }, completion: { (fin) in
                                self.activityView.isHidden = false
                            })
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                    case .restored:
                        let alert = UIAlertController(title: "Seccsesful Restored", message: "", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                            UIView.animate(withDuration: 0.4, animations: {
                                self.activityView.alpha = 0.0
                            }, completion: { (fin) in
                                self.activityView.isHidden = false
                            })
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            
            if indexPath.row == 2 {
                guard let url = URL(string: GlobalDefinitions.TermsOfService.contactUrl) else { return }
                UIApplication.shared.open(url)
            }
            
            if indexPath.row == 3 {
                
                let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
                if isRegisteredForRemoteNotifications == false {
                    requestNotify()
                } else {
                    performSegue(withIdentifier: "notify", sender: nil)
                }
               
            }
            
        }
        
        if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                guard let url = URL(string: GlobalDefinitions.TermsOfService.termsUrl) else { return }
                UIApplication.shared.open(url)
            }
            
            if indexPath.row == 1 {
                guard let url = URL(string: GlobalDefinitions.TermsOfService.policyUrl) else { return }
                UIApplication.shared.open(url)
            }
            
        }
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 4
        }
        
         return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                cell.textLabel?.text = NSLocalizedString("sharing", comment: "")
            }
            if indexPath.row == 1 {
                cell.textLabel?.text = NSLocalizedString("restore", comment: "")
            }
            
            if indexPath.row == 2 {
                cell.textLabel?.text = NSLocalizedString("contact", comment: "")
            }
            
            if indexPath.row == 3 {
                cell.textLabel?.text  = NSLocalizedString("push", comment: "")
            }
            
        }
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.textLabel?.text = NSLocalizedString("terms", comment: "")
            }
            
            
            if indexPath.row == 1 {
                cell.textLabel?.text = NSLocalizedString("private_polisy", comment: "")
            }
        }
       
        
        
        return cell
    }
    
    
}


extension ProfileViewController: PaymentFlowDelegate {
    
    func paymentInfoWasLoad(config bundle: ConfigBundle) {
        
    }
    
    func paymentSuccses() {
        activityView.isHidden = true
        let alert: UIAlertController = UIAlertController(title: "Restore Succsesfull", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func error() {
        activityView.isHidden = true
        let alert: UIAlertController = UIAlertController(title: "Restore Failed", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func purchase() {
        activityView.isHidden = true
        let alert: UIAlertController = UIAlertController(title: "Purchased", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
}

// MARK: Make

extension ProfileViewController {
    static func make() -> ProfileViewController {
        UIStoryboard(name: "Profile", bundle: .main).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
    }
}
