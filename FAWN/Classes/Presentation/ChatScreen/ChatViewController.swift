//
//  ChatViewController.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 07/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift

final class ChatViewController: UIViewController {
    private lazy var tableView = makeTableView()
    private lazy var chatInputView = makeChatInputView()
    private lazy var menuItem = makeMenuBarButtonItem()
    
    private var attachView: ChatAttachView?
    
    private var chatInputViewBottomConstraint: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()
    private var detectAttachViewTappedDisposable: Disposable?
    
    private var chat: Chat!
    private var viewModel: ChatViewModel!
    
    private lazy var imagePicker = makeImagePicker()
    
    init(chat: Chat) {
        self.chat = chat
        self.viewModel = ChatViewModel(chat: chat)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 33 / 255, green: 33 / 255, blue: 33 / 255, alpha: 1)
        
        makeConstraints()
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.connect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.disconnect()
    }
}

// MARK: Make

extension ChatViewController {
    static func make(with chat: Chat) -> ChatViewController {
        ChatViewController(chat: chat)
    }
}

// MARK: ImagePickerDelegate

extension ChatViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        
        viewModel.sendImage.accept(image)
    }
}

// MARK: Private

private extension ChatViewController {
    func bind() {
        viewModel
            .chatRemoved()
            .emit(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.sender()
            .subscribe()
            .disposed(by: disposeBag)
        
        view.rx.keyboardHeight
            .subscribe(onNext: { [weak self] keyboardHeight in
                var inset = keyboardHeight
                
                if inset > 0, UIDevice.current.hasBottomNotch {
                    inset -= 35
                }
                self?.chatInputViewBottomConstraint.constant = -inset
                
                UIView.animate(withDuration: 0.25, animations: { [weak self] in
                    self?.view.layoutIfNeeded()
                })
            })
            .disposed(by: disposeBag)
        
        tableView.reachedTop
            .bind(to: viewModel.nextPage)
            .disposed(by: disposeBag)
        
        tableView.viewedMessage
            .bind(to: viewModel.viewedMessage)
            .disposed(by: disposeBag)
        
        viewModel.newMessages
            .drive(onNext: { [weak self] newMessages in
                self?.tableView.add(messages: newMessages)
            })
            .disposed(by: disposeBag)
            
        let hideKeyboardGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(hideKeyboardGesture)
        
        hideKeyboardGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        chatInputView.sendTapped
            .asObservable()
            .withLatestFrom(chatInputView.text)
            .subscribe(onNext: { [weak self] text in
                guard let message = text?.trimmingCharacters(in: .whitespaces), !message.isEmpty else {
                    return
                }
                
                self?.viewModel.sendText.accept(message)
                self?.chatInputView.set(text: "")
            })
            .disposed(by: disposeBag)
        
        chatInputView
            .attachTapped
            .emit(onNext: { [weak self] state in
                self?.attachTapped(state: state)
            })
            .disposed(by: disposeBag)
        
        menuItem.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.menuTapped()
            })
            .disposed(by: disposeBag)
    }
    
    func attachTapped(state:  ChatAttachButton.State) {
        switch state {
        case .attach:
            guard attachView == nil else {
                return
            }
            
            let attachView = ChatAttachView(frame: CGRect(x: 8,
                                                          y: self.chatInputView.frame.origin.y - self.chatInputView.frame.height - 10,
                                                          width: 260,
                                                          height: 60))
            self.attachView = attachView
            view.addSubview(attachView)
            
            detectAttachViewTapped()
        case .close:
            attachView?.removeFromSuperview()
            attachView = nil
        }
    }
    
    func menuTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let reportAction = UIAlertAction(title: "Chat.Menu.Report".localized, style: .default) { [unowned self] _ in
            let vc = ReportViewController(on: .chatInterlocutor(self.chat))
            self.present(vc, animated: true)
        }

        let doneAction = UIAlertAction(title: "Chat.Menu.Done".localized, style: .cancel)

        actionSheet.addAction(reportAction)
        actionSheet.addAction(doneAction)

        present(actionSheet, animated: true)
    }
    
    func detectAttachViewTapped() {
        detectAttachViewTappedDisposable?.dispose()
        
        detectAttachViewTappedDisposable = attachView?.caseTapped
            .emit(onNext: { [weak self] tapped in
                guard let `self` = self else {
                    return
                }
                
                switch tapped {
                case .photo:
                    self.attachView?.removeFromSuperview()
                    self.attachView = nil
                    
                    self.chatInputView.set(attachState: .attach)
                    
                    self.imagePicker.present(from: self.view)
                }
            })
    }
    
//    private func addInterlocutorGalleryImages() {
//        guard !chat.interlocutorGalleryPhotos.isEmpty else {
//            return
//        }
//
//        let photosCount: CGFloat = CGFloat(chat.interlocutorGalleryPhotos.count)
//
//        let size: CGFloat = SizeUtils.value(largeDevice: 48, smallDevice: 44, verySmallDevice: 40)
//        let indent: CGFloat = 4
//
//        let titleView = UIView()
//        titleView.frame.size = CGSize(width: photosCount * size + (photosCount - 1) * indent,
//                                      height: size)
//
//        var x: CGFloat = 0
//
//        for url in chat.interlocutorGalleryPhotos {
//            let imageView = UIImageView(frame: CGRect(x: x,
//                                                      y: 0,
//                                                      width: size,
//                                                      height: size))
//
//            imageView.contentMode = .scaleAspectFit
//            imageView.clipsToBounds = true
//            imageView.isUserInteractionEnabled = true
//            imageView.kf.setImage(with: url)
//
//            titleView.addSubview(imageView)
//
//            x += size + indent
//
//            let tapGesture = UITapGestureRecognizer()
//            imageView.addGestureRecognizer(tapGesture)
//
//            tapGesture.rx.event
//                .map { _ in url }
//                .subscribe(onNext: { [weak self] url in
//                    let vc = ImageViewController(url: url)
//                    self?.navigationController?.pushViewController(vc, animated: true)
//                })
//                .disposed(by: disposeBag)
//        }
//
//        navigationItem.titleView = titleView
//    }
}

// MARK: Make constraints

private extension ChatViewController {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: chatInputView.topAnchor)
        ])
        
        chatInputViewBottomConstraint = chatInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([
            chatInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatInputViewBottomConstraint
        ])
    }
}

// MARK: Lazy initialization

private extension ChatViewController {
    func makeTableView() -> ChatTableView {
        let view = ChatTableView()
        view.separatorStyle = .none
        view.allowsSelection = false
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }
    
    func makeChatInputView() -> ChatInputView {
        let view = ChatInputView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }
    
    func makeImagePicker() -> ImagePicker {
        ImagePicker(presentationController: self, delegate: self)
    }
    
    func makeMenuBarButtonItem() -> UIBarButtonItem {
        let view = UIBarButtonItem()
        view.tintColor = .white
        view.image = UIImage(named: "report_btn")
        navigationItem.rightBarButtonItem = view
        return view
    }
}
