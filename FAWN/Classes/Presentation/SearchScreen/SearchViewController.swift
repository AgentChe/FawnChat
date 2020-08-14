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
        
        AmplitudeAnalytics.shared.log(with: .searchScr)
        
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
        
        collectionView
            .changeItemsCount
            .distinctUntilChanged()
            .filter { $0 == 0 }
            .emit(onNext: { [weak self] count in
                self?.viewModel.downloadProposedInterlocutors.accept(Void())
            })
            .disposed(by: disposeBag)
        
        viewModel
            .step
            .drive(onNext: { [weak self] step in
                switch step {
                case .proposedInterlocutors(let proposedInterlocutors):
                    self?.collectionView.add(proposedInterlocutors: proposedInterlocutors)
                    
                    self?.collectionView.isHidden = proposedInterlocutors.isEmpty
                    self?.emptyView.isHidden = !proposedInterlocutors.isEmpty
                    
                    if proposedInterlocutors.isEmpty {
                        self?.emptyView.setup(type: .noProposedInterlocutors)
                    }
                case .needPayment:
                    self?.emptyView.isHidden = false
                    self?.emptyView.setup(type: .needPayment)
                    
                    self?.goToPaygateScreen()
                }
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
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: Private
    
    private func goToPaygateScreen() {
        let vc = PaygateViewController.make(delegate: self)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical

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
