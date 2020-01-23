//
//  NotifyViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 02/07/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import UserNotifications
import DatingKit

class NotifyViewController: UIViewController {

    @IBOutlet weak var lastLabelView: UIView!
    @IBOutlet weak var firstLabelView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: NotificationManager.kWasShow)   //bool(forKey: NotificationManager.kWasShow) = true
        NotificationManager.shared.startManagment()
        NotificationManager.shared.delegate = self
        NotificationManager.shared.requestAccses()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pay" {
            let paygate: PaygateViewController = segue.destination as! PaygateViewController
            let config: ConfigBundle = sender as! ConfigBundle
//            PurchaseManager.shared.loadProducts()
            paygate.delegate = self
            paygate.config(bundle: config)
        }
    }

}

extension NotifyViewController: PaygateViewDelegate {
    
    func purchaseWasEndet() {
        self.performSegue(withIdentifier: "manualyStart", sender: nil)
    }
    
}

extension NotifyViewController: NotificationDelegate {
    
    func notificationRequestWasEnd(succses: Bool) {
//        dismiss(animated: true, completion: nil)
        UIView.animate(withDuration: 0.4, animations: {
            self.firstLabelView.alpha = 0.0
            self.lastLabelView.alpha = 0.0
        }) { (succses) in
            debugPrint(PurchaseManager.shared.showUponLogin )
            if PurchaseManager.shared.showUponLogin {
                PurchaseManager.shared.loadProducts { (config) in
                    self.performSegue(withIdentifier: "pay", sender: config)
                    return
                }
                return
            }

            self.performSegue(withIdentifier: "start_new", sender: nil)
//            ScreenManager.shared.showMian()
        }
     
    }
    
}
