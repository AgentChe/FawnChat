//
//  PaygateViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 01/06/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import Amplitude_iOS
import DatingKit


protocol PaygateViewDelegate: class {
    func purchaseWasEndet()
}

class PaygateViewController: UIViewController {

    @IBOutlet weak var lineImageView: UIImageView!
    
    @IBOutlet weak var privacyButton: UIButton!
    
    @IBOutlet weak var termsButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var restoreButton: UIButton!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var activityView: UIView!
    
    private var configBundle: ConfigBundle!
    
    private var currentID: String = ""
    
    weak var delegate: PaygateViewDelegate!
    
//    var trial: ConfigTrial!
    
    func config(bundle: ConfigBundle) {
        configBundle = bundle
        currentID = bundle.priceBundle.centralPriceTag.id
    }
    
    override func viewDidLayoutSubviews() {
        
//        closeButton.isHidden = !configBundle.isShowTrial
        navigationController?.setNavigationBarHidden(true, animated: true)
        if UIDevice.modelName.contains("SE") || UIDevice.modelName.contains("5s")  {
            headerView.frame.size = CGSize(width: headerView.frame.size.width, height: 160)
        } else {
            headerView.frame.size = CGSize(width: headerView.frame.size.width, height: 350)
        }
        if UIDevice.modelName.contains("8") ||
            UIDevice.modelName.contains("6") ||
            UIDevice.modelName.contains("7")
        {
            headerView.frame.size = CGSize(width: headerView.frame.size.width, height: 200)
        }
        
        if  UIDevice.modelName.contains("iPad") {
            headerView.frame.size = CGSize(width: headerView.frame.size.width, height: 500)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Amplitude.instance()?.log(event: .paygateScr)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.isHidden = true
        navigationController?.setToolbarHidden(true, animated: true)
        tableView.register(UINib(nibName: "MensCountTableViewCell", bundle: .main), forCellReuseIdentifier: "MensCountTableViewCell")
        tableView.register(UINib(nibName: "BundleTableViewCell", bundle: .main), forCellReuseIdentifier: "BundleTableViewCell")
        tableView.register(UINib(nibName: "ButtonTableViewCell", bundle: .main), forCellReuseIdentifier: "ButtonTableViewCell")
        tableView.register(UINib(nibName: "TermsTableViewCell", bundle: .main), forCellReuseIdentifier: "TermsTableViewCell")
        privacyButton.titleLabel?.numberOfLines = 0
        privacyButton.titleLabel?.textAlignment = .center
        termsButton.titleLabel?.numberOfLines = 0
        termsButton.titleLabel?.textAlignment = .center
        restoreButton.titleLabel?.numberOfLines = 0
        restoreButton.titleLabel?.textAlignment = .center
    }
    
    
    func buy(id: String) {
        if id.count > 0 {
           activityView.alpha = 0.0
           activityView.isHidden = false
            
            UIView.animate(withDuration: 0.4) {
                 self.activityView.alpha = 1.0
            }
            
            PurchaseManager.shared.buy(productID: id) { (status) in
                switch status {
                    
                case .succes:
                    self.delegate.purchaseWasEndet()
                    self.activityView.isHidden = true
                    self.dismiss(animated: true, completion: nil)
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
                        self.activityView.isHidden = false
                    }))
                    self.present(alert, animated: true, completion: nil)
                @unknown default:
                    let alert = UIAlertController(title: "ERROR", message: "Something went wrong", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                        self.activityView.isHidden = false
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func tapOnPay(_ sender: UIButton) {
        
        buy(id: currentID)
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
                self.delegate.purchaseWasEndet()
                self.activityView.isHidden = true
                self.dismiss(animated: true, completion: nil)
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
        if configBundle.isShowTrial {
            performSegue(withIdentifier: "trial", sender: nil)
        } else {
            dismiss(animated: true) {
                 self.delegate.purchaseWasEndet()
            }
        }
        
        
    }
    
    @objc func tapOnLeft() {
       currentID = configBundle.priceBundle.leftPriceTag.id
    }
    
    @objc func tapOnCenter() {
        currentID = configBundle.priceBundle.centralPriceTag.id
    }
    
    @objc func tapOnRight() {
        currentID = configBundle.priceBundle.reightPriceTag.id
    }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "trial" {
            tableView.isHidden = true
            closeButton.isHidden = true
            lineImageView.isHidden = true
            let trial: TrialViewController = segue.destination as! TrialViewController
            trial.delegate = self
            trial.config(configBundle.configTrial!)
        }
    }
}

extension PaygateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: MensCountTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MensCountTableViewCell", for: indexPath) as! MensCountTableViewCell
            cell.config(bundle: configBundle.mensCounterBundle)
            return cell
        }
        if indexPath.row == 1 {
            let cell: BundleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BundleTableViewCell", for: indexPath) as! BundleTableViewCell
            cell.leftButton.addTarget(self, action: #selector(tapOnLeft), for: .touchUpInside)
            cell.centralButton.addTarget(self, action: #selector(tapOnCenter), for: .touchUpInside)
            cell.rightButton.addTarget(self, action: #selector(tapOnRight), for: .touchUpInside)
            cell.config(with: configBundle.priceBundle)
            return cell
        }
        if indexPath.row == 2 {
            let cell: ButtonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell", for: indexPath) as! ButtonTableViewCell
            cell.continueButton.addTarget(self, action: #selector(tapOnPay(_:)), for: .touchUpInside)
            cell.startAnimation()
            return cell
        }
        if indexPath.row == 3 {
            let cell: TermsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TermsTableViewCell", for: indexPath) as! TermsTableViewCell
            return cell
        }
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
    
}

extension PaygateViewController: ModalHandler {
    
    func modalDismissed() {
      
        dismiss(animated: true) {
            self.delegate.purchaseWasEndet()
        }
    }
    
}

extension PaygateViewController: UITableViewDelegate {
    
}

extension PaygateViewController: PaymentFlowDelegate {
    
    func purchase() {
         activityView.isHidden = true
    }
    
    func paymentSuccses() {
        delegate.purchaseWasEndet()
        activityView.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func paymentInfoWasLoad(config bundle: ConfigBundle) {
        tableView.reloadData()
    }
    
    func error() {
        activityView.isHidden = true
    }
    
    func purchaseWasCanseled() {
        activityView.isHidden = true
    }

}
