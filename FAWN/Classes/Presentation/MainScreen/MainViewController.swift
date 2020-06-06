//
//  MainViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 26/03/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift

protocol MainViewControllerDelegate: class {
    func tapOnChats()
    func tapOnSearch()
}

final class MainViewController: UIViewController {
    var mainView = MainView()
    lazy var profileItem = makeProfileBarButtonItem()
    
    weak var delegate: MainViewControllerDelegate?
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPagesController()
        updateViews(isSearchSelected: true)
        
        mainView.searchButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.updateViews(isSearchSelected: true)
                
                self?.delegate?.tapOnSearch()
            })
            .disposed(by: disposeBag)
        
        mainView.chatsButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.updateViews(isSearchSelected: false)
                
                self?.delegate?.tapOnChats()
            })
            .disposed(by: disposeBag)
        
        profileItem.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.pushViewController(ProfileViewController.make(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "page" {
            delegate = segue.destination as! PageViewController
        }
    }
}

// MARK: Make

extension MainViewController {
    static func make() -> UIViewController {
        FAWNNavigationController(rootViewController: MainViewController(nibName: nil, bundle: .main))
    }
}

// MARK: Private

private extension MainViewController {
    func addPagesController() {
        let vc = PageViewController.make()
        addChild(vc)
        
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.pageContainerView.addSubview(vc.view)
        
        NSLayoutConstraint.activate([
            vc.view.leadingAnchor.constraint(equalTo: mainView.pageContainerView.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: mainView.pageContainerView.trailingAnchor),
            vc.view.topAnchor.constraint(equalTo: mainView.pageContainerView.topAnchor),
            vc.view.bottomAnchor.constraint(equalTo: mainView.pageContainerView.bottomAnchor)
        ])
        
        delegate = vc
    }
    
    func updateViews(isSearchSelected: Bool) {
        profileItem.image = isSearchSelected ? nil : UIImage(named: "profile_icon")
        profileItem.isEnabled = !isSearchSelected
        mainView.searchButton.setImage(UIImage(named: isSearchSelected ? "search_btn_hight" : "search_btn"), for: .normal)
        mainView.chatsButton.setImage(UIImage(named: isSearchSelected ? "chat_btn" : "chat_btn_hight"), for: .normal)
    }
}

// MARK: Lazy initializatioon

private extension MainViewController {
    func makeProfileBarButtonItem() -> UIBarButtonItem {
        let view = UIBarButtonItem()
        view.tintColor = .white 
        navigationItem.rightBarButtonItem = view
        return view
    }
}
