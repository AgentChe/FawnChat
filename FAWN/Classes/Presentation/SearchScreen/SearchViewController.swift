//
//  SearchViewController.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 22/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    static func make() -> UIViewController {
        SearchViewController(nibName: nil, bundle: nil)
    }
    
    private lazy var collectionView = makeCollectionView()
    private lazy var emptyView = makeEmptyView()
    
    private let viewModel = SearchViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeConstraints()
        bind()
    }
    
    // MARK: Bind
    
    private func bind() {
        collectionView
            .report
            .emit(onNext: { [weak self] proposedInterlocutor in
                self?.goToReportScreen(proposedInterlocutor: proposedInterlocutor)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .proposedInterlocutors
            .map { !$0.isEmpty }
            .drive(emptyView.rx.isHidden)
            .disposed(by: disposeBag)
        
        collectionView
            .changeItemsCount
            .emit(onNext: { [weak self] count in
                let isEmpty = count == 0
            
                self?.collectionView.isHidden = isEmpty
                self?.emptyView.isHidden = !isEmpty
            })
            .disposed(by: disposeBag)
        
        viewModel
            .proposedInterlocutors
            .drive(onNext: { [weak self] proposedInterlocutors in
                self?.collectionView.add(proposedInterlocutors: proposedInterlocutors)
            })
            .disposed(by: disposeBag)
        
        Signal
            .merge(viewModel.likeWasPut,
                   viewModel.dislikeWasPut)
            .emit(onNext: { [weak self] proposedInterlocutor in
                self?.collectionView.remove(proposedInterlocutor: proposedInterlocutor)
            })
            .disposed(by: disposeBag)
        
        collectionView
            .like
            .emit(to: viewModel.like)
            .disposed(by: disposeBag)
        
        collectionView
            .dislike
            .emit(to: viewModel.dislike)
            .disposed(by: disposeBag)
        
        viewModel
            .needPayment
            .emit(onNext: { [weak self] in
                self?.goToPaygateScreen()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Lazy initialization
    
    private func makeCollectionView() -> ProposedInterlocutorsCollectionView {
        let view = ProposedInterlocutorsCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }
    
    private func makeEmptyView() -> NoProposedInterlocutorsView {
        let view = NoProposedInterlocutorsView()
        view.backgroundColor = .clear
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        
        view.newSearchTapped = { [weak self] in
            self?.emptyView.isHidden = true
            self?.viewModel.downloadProposedInterlocutors.accept(Void())
        }
        
        return view
    }
    
    // MARK: Make constraints
    
    private func makeConstraints() {
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        emptyView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // MARK: Private
    
    private func goToPaygateScreen() {
        let vc = PaygateViewController.make()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        vc.delegate = self

        present(vc, animated: true)
    }
    
    private func goToReportScreen(proposedInterlocutor: ProposedInterlocutor) {
        let vc = ReportViewController(on: .proposedInterlocutor(proposedInterlocutor))
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        
        present(vc, animated: true)
    }
}

extension SearchViewController: PaygateViewControllerDelegate {
    func wasPurchased() {
        viewModel.downloadProposedInterlocutors.accept(Void())
    }
    
    func wasRestored() {
        viewModel.downloadProposedInterlocutors.accept(Void())
    }
}

extension SearchViewController: ReportViewControllerDelegate {
    func reportWasCreated(reportOn: ReportViewController.ReportOn) {
        if case let .proposedInterlocutor(proposedInterlocutor) = reportOn {
            collectionView.remove(proposedInterlocutor: proposedInterlocutor)
        }
    }
}
