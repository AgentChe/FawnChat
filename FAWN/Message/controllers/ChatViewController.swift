//
//  ChatViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 09/04/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import NextGrowingTextView
import ReverseExtension
import Amplitude_iOS
import DatingKit
import TKImageShowing


class ChatViewController: UIViewController, ChatViewProtocol {
    
    var menuView: MenuViewProtocol = DKMenuCell()
    
    var noView: ChatNoViewProtocol = NoView()
    
    var presenter: ChatPresenterProtocol?
    
    var tableView: UITableView = UITableView()
    
    var textInputView: DKChatBottomView = DKChatBottomView()
    
    var configurator: ChatConfiguratorProtocol = DKChatConfigurator()
    
   
    @IBOutlet var navView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var partnerImageView: UIImageView!
    @IBOutlet weak var menu: DKMenuCell!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var noMessageView: UIView!
    @IBOutlet weak var noMessagesTitleLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var noInternetView: UIView!
    @IBOutlet weak var noInternetHeight: NSLayoutConstraint!
    @IBOutlet weak var inputContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var inpput: DKChatBottomView!
    
    private var barItem: UIBarButtonItem?
    private var image: UIImage!
    private var currentChat: ChatItem!
    private let imagePicker = UIImagePickerController()
    
    let tkImageVC = TKImageShowing()
    private var userData: UserShow?
        
    // MARK: - life cycle
    
    func config(with chat: ChatItem) {
        currentChat = chat
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
                
        NotificationCenter.default.addObserver(self, selector: #selector(self.close), name: ReportViewController.reportNotify, object: nil)
                   
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                   
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tableView = table
        tableView.register(UINib(nibName: "ChatTableViewCell", bundle: .main),
                           with: .userTextMessage)
        tableView.register(UINib(nibName: "ChatPartnerTableViewCell", bundle: .main),
                           with: .partnerTextMessage)
        tableView.register(UINib(nibName: "MyImageTableViewCell", bundle: .main),
                           with: .userImageMessage)
        
        tableView.register(UINib(nibName: "PattnerImageTableViewCell", bundle: .main),
                           with: .partnerImageMessage)
        
        menuView = menu
        
        textInputView = inpput
        textInputView.keyboadAppirance = .dark
        configurator.configurate(view: self)
        guard presenter != nil else { return }
        textInputView.sendButton.addTarget(self, action: #selector(tapOnSend), for: .touchUpInside)
        tableView.re.delegate = self
        tableView.re.dataSource = presenter?.tableDataSource

        barItem = UIBarButtonItem(image: #imageLiteral(resourceName: "report_btn"), style: .plain, target: self, action: #selector(showUnmachAndReport))

        DispatchQueue.main.async { [weak self] in
            self!.navigationItem.setRightBarButton(self!.barItem, animated: true)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            
        Amplitude.instance()?.log(event: .chatScr, with: ["user_id" : String(DatingKit.user.userData!.id),
                                                          "user_email" : DatingKit.user.userData!.email,
                                                          "companion_id" : currentChat.chatID])
            
        ScreenManager.shared.chatItemOnScreen = currentChat
        guard presenter != nil else { return }
        guard currentChat != nil else { return }
        presenter?.configure(chat: currentChat)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        noMessagesTitleLabel.text = "You matched with " + currentChat.partnerName

        guard let urlPartner: URL = URL(string: currentChat.partnerAvatarString) else {return}
        userImageView.af_setImage(withURL: urlPartner)
            
       
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.disconnect()
        ScreenManager.shared.chatItemOnScreen = nil
    }
    
    // MARK: - Actions
        
    @IBAction func tapOnPhoto(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        view.endEditing(true)
        present(imagePicker, animated: true, completion: nil)
    }
        
    func checkOnSpases(string: String) -> Bool {
        let whitespaceSet = NSCharacterSet.whitespaces
        let range = string.rangeOfCharacter(from: whitespaceSet)
        if let _ = range {
            return false
        } else {
            return true
        }
    }
    
    
    func showUnmatchAlert() {
        let action: UIAlertController = UIAlertController(title: "UNMATCH", message: "Your chat history will disappear as if nothing happened", preferredStyle: .alert)
        action.addAction(UIAlertAction(title: "Unmatch", style: .default, handler: { (action) in
            ReportManager.shared.unmatch(in: Double(self.currentChat!.chatID), with: { (succses) in
                self.navigationController?.popViewController(animated: true)
            })
        }))
        
        action.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        
        present(action, animated: true, completion: nil)
    }
    
    
    @objc func showUnmachAndReport() {
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Unmatch", style: .default, handler: { (action) in
            self.showUnmatchAlert()
        }))
        actionSheet.addAction(UIAlertAction(title: "Report", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "report", sender: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
        actionSheet.view.tintColor = #colorLiteral(red: 1, green: 0.3303741813, blue: 0.3996370435, alpha: 1)
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.barButtonItem = barItem
        }
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func showMenuView(_ sender: DKChatMenuView) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
        
    @objc func tapOnSend() {
        guard presenter != nil else {return}
        guard let user: UserShow = presenter?.user else {return}
        guard currentChat != nil else {return}
        if textInputView.text.trimmingCharacters(in: .whitespaces).isEmpty {
            return
        }
                
        presenter?.send(message: Message(text: textInputView.text, sender: user.id, matchID: currentChat.chatID))
        textInputView.text = ""
    }
        
    
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
       
        
        
    @objc func keyboardWillHide(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if var keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                   debugPrint(UIDevice.modelName.contains("X"))
                   if UIDevice.modelName.contains("X") {
                       keyboardHeight = keyboardHeight - 35
                   }
       
                   self.inputContainerViewBottom.constant = 0
                   UIView.animate(withDuration: 0.25, animations: { () -> Void in
                       self.view.layoutIfNeeded()
                   })
               }
        }
    }
        
        
    @objc func keyboardWillShow(_ sender: Notification) {
            
        if let userInfo = (sender as NSNotification).userInfo {
            if var keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                debugPrint(UIDevice.modelName.contains("X"))
                if UIDevice.modelName.contains("X") {
                    keyboardHeight = keyboardHeight - 35
                }
                self.inputContainerViewBottom.constant = -keyboardHeight
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
        
    
    //MARK: - DK Chat view protocol
    
    func reload() {
        tableView.reloadData()
    }
       
    func openPaygate() {
        PurchaseManager.shared.loadProducts { (config) in
            self.performSegue(withIdentifier: "paygate", sender: config)
        }
    }
       
    func setScreen() {
        nameLabel.text = currentChat.partnerName
        guard let urlPartner: URL = URL(string: currentChat.partnerAvatarString) else {return}
        partnerImageView.af_setImage(withURL: urlPartner)
        navigationItem.titleView = navView
    }
       
    func showNoView(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.noMessageView.alpha = show ? 1.0 : 0.0
        }
    }
       
    func addMessage(at indexPath: IndexPath) {
        self.tableView.beginUpdates()
        self.tableView.re.insertRows(at: [indexPath], with: .top)
        self.tableView.endUpdates()
    }
       
    func deleteMessage(at indexPath: IndexPath) {
           
    }
       
    func showNoInternetConnection(_ show: Bool) {
        if show {
            noInternetView.isHidden = false
            noInternetHeight.constant = 57.0
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
        } else {
            noInternetHeight.constant = 0.0
            UIView.animate(withDuration: 0.4, animations: {
                 self.view.layoutIfNeeded()
            }) { (fin) in
                self.noInternetView.isHidden = true
            }
        }
    }
       
    func showError(with message: Message) {
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: "Your message was not sent. Tap “Try Again” to send this message.", preferredStyle:.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Try again", style: .destructive, handler: { [weak self] (action) in
            self?.presenter?.send(message: message)
        }))
            
        actionSheet.addAction(UIAlertAction(title: "Delete Message", style: .destructive, handler: { [weak self] (action) in
            self?.presenter?.deleteUnsendet(message: message)
        }))
                
            
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
        }
        present(actionSheet, animated: true, completion: nil)
    }
       
        
      
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "report" {
            let reportController: ReportViewController = segue.destination as! ReportViewController
            reportController.config(chat: currentChat)
        }
        

        if segue.identifier == "paygate" {
            guard let paygate: PaygateViewController = segue.destination as? PaygateViewController else {return}
            paygate.delegate = self
            let config: ConfigBundle = sender as! ConfigBundle
            paygate.config(bundle: config)
    
        }
        
    }
        
}

 extension ChatViewController: PaygateViewDelegate {
        
    func purchaseWasEndet() {
            
    }
        
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
          
        return .none
    }
      
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard presenter != nil else { return }
        
        presenter?.pagintaion(for: indexPath)
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                   
            guard presenter != nil else { return }
            guard let user: UserShow = presenter?.user else {
                return
            }
                        
            var newMessage: Message = Message(image: pickedImage, forSender: user.id, matchID: currentChat.chatID)
            newMessage.base64Image = pickedImage.ConvertImageToBase64String()
            newMessage.sendetImage = pickedImage
            presenter?.send(message: newMessage)
          
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
    }
    
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


class NoView: UIView, ChatNoViewProtocol {
  
    var icon: UIImage = UIImage()
    
    var title: String = ""
    
    var subTitle: String = ""
    
    
}
