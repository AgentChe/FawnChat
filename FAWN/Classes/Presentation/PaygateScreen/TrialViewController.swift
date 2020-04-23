//
//  TrialViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 06/06/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import Amplitude_iOS
import DatingKit


protocol ModalHandler: class {
    func modalDismissed()
}

class TrialViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityView: UIView!
    
    
    var config: ConfigTrial!
    var reasons: [Reason]!
    
    weak var delegate: ModalHandler!
    
    func config(_ trialInfo: ConfigTrial)  {
        reasons = trialInfo.reasons
        config = trialInfo
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Amplitude.instance()?.log(event: .trialScr)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.isHidden = true
        titleLabel.text = config.title
        tableView.register(UINib(nibName: "ReasonTableViewCell", bundle: .main), forCellReuseIdentifier: "ReasonTableViewCell")
        tableView.register(UINib(nibName: "TermsTableViewCell", bundle: .main), forCellReuseIdentifier: "TermsTableViewCell")
        tableView.register(UINib(nibName: "SubtitleButtonTableViewCell", bundle: .main), forCellReuseIdentifier: "SubtitleButtonTableViewCell")
        //SubtitleButtonTableViewCell
    }
    
    @IBAction func tapOnTerms(_ sender: Any) {
        guard let url = URL(string: GlobalDefinitions.TermsOfService.termsUrl) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func tapOnPrivacy(_ sender: Any) {
        guard let url = URL(string: GlobalDefinitions.TermsOfService.policyUrl) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func tapOnRestore(_ sender: Any) {
        activityView.isHidden = false
        PurchaseManager.shared.restore { (status) in
            switch status {
                
            case .restored:
                self.activityView.isHidden = true
                self.dismiss(animated: true) { [weak self] in
                    self!.delegate.modalDismissed()
                }
            case .failed:
                let alert = UIAlertController(title: "ERROR", message: "Restore Failed", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                    self.activityView.isHidden = false
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func tapOnClose(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            self!.delegate.modalDismissed()
        }
    }
    
    @objc func tapOnPay() {
        activityView.isHidden = false
        PurchaseManager.shared.buy(productID: config.productID) { (status) in
            switch status {
                
            case .succes:
                self.activityView.isHidden = true
                self.dismiss(animated: true) { [weak self] in
                    self!.delegate.modalDismissed()
                }
            case .error:
                let alert = UIAlertController(title: "ERROR", message: "Something went wrong", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                    self.activityView.isHidden = true
                }))
                self.present(alert, animated: true, completion: nil)
            case .unknown:
                let alert = UIAlertController(title: "ERROR", message: "Something went wrong", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                    self.activityView.isHidden = true
                }))
                self.present(alert, animated: true, completion: nil)
            case .clientInvalid:
                let alert = UIAlertController(title: "ERROR", message: "Client invalid", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                    self.activityView.isHidden = true
                }))
                self.present(alert, animated: true, completion: nil)
            case .paymentCancelled:
                self.activityView.isHidden = true
            case .paymentInvalid:
                let alert = UIAlertController(title: "ERROR", message: "Payment invalid", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                    self.activityView.isHidden = true
                }))
                self.present(alert, animated: true, completion: nil)
            case .paymentNotAllowed:
                let alert = UIAlertController(title: "ERROR", message: "Payment not allowed", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                    self.activityView.isHidden = true
                }))
                self.present(alert, animated: true, completion: nil)
            case .storeProductNotAvailable:
                let alert = UIAlertController(title: "ERROR", message: "Product not avilable", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                    self.activityView.isHidden = true
                }))
                self.present(alert, animated: true, completion: nil)
            case .cloudServicePermissionDenied:
                let alert = UIAlertController(title: "ERROR", message: "Cloud server Permishn Denaided", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                    self.activityView.isHidden = true
                }))
                self.present(alert, animated: true, completion: nil)
            case .cloudServiceNetworkConnectionFailed:
                let alert = UIAlertController(title: "ERROR", message: "Network connection failed", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                    self.activityView.isHidden = true
                }))
                self.present(alert, animated: true, completion: nil)
            case .cloudServiceRevoked:
                let alert = UIAlertController(title: "ERROR", message: "servise revoked", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                    self.activityView.isHidden = true
                }))
                self.present(alert, animated: true, completion: nil)
            @unknown default:
                let alert = UIAlertController(title: "ERROR", message: "Something went wrong", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                    self.activityView.isHidden = true
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
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

extension TrialViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return reasons.count
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: ReasonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ReasonTableViewCell", for: indexPath) as! ReasonTableViewCell
            var icon: UIImage = UIImage()
            if indexPath.row == 0 {
                icon = #imageLiteral(resourceName: "first_icon")
            }
            if indexPath.row == 1 {
                icon = #imageLiteral(resourceName: "second_icon")
            }
            if indexPath.row == 2 {
                icon = #imageLiteral(resourceName: "3_icon")
            }
            cell.config(reason: reasons[indexPath.row], icon: icon)
            return cell
        }
        if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                let cell: SubtitleButtonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SubtitleButtonTableViewCell", for: indexPath) as! SubtitleButtonTableViewCell
                cell.config(button: config.button)
                cell.button.addTarget(self, action: #selector(tapOnPay), for: .touchUpInside)
                return cell
            }
            
            if indexPath.row == 1 {
                let cell: TermsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TermsTableViewCell", for: indexPath) as! TermsTableViewCell
                return cell
            }
            
        }
        return UITableViewCell()
    }
    
    
}

extension TrialViewController: UITableViewDelegate {
    
}

extension TrialViewController: PaymentFlowDelegate {
    
    func paymentInfoWasLoad(config bundle: ConfigBundle) {
        
    }
    
    func paymentSuccses() {
        activityView.isHidden = true
        dismiss(animated: true) { [weak self] in
            self!.delegate.modalDismissed()
        }
    }
    
    func error() {
        activityView.isHidden = true
    }
    
    func purchase() {
        
    }
    
}
