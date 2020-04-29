//
//  SearchViewModel.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 22/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import RxCocoa

final class SearchViewModel {
    enum Step {
        case proposedInterlocutors([ProposedInterlocutor])
        case needPayment
    }
    
    let like = PublishRelay<ProposedInterlocutor>()
    private(set) lazy var likeWasPut = createLikeComplete()
    
    let dislike = PublishRelay<ProposedInterlocutor>()
    private(set) lazy var dislikeWasPut = createDislikeComplete()
    
    let downloadProposedInterlocutors = PublishRelay<Void>()
    private(set) lazy var step = createStep()
    
    private func createStep() -> Driver<Step> {
        downloadProposedInterlocutors
            .startWith(Void())
            .flatMapLatest {
                SearchService
                    .proposedInterlocuters()
                    .map { (false, $0) }
                    .catchError { error in
                        if let paymentError = error as? PaymentError, paymentError == .needPayment {
                            return .just((true, []))
                        } else {
                            return .just((false, []))
                        }
                    }
            }
            .map {
                $0 ? Step.needPayment : Step.proposedInterlocutors($1)
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    private func createLikeComplete() -> Signal<ProposedInterlocutor> {
        like
            .flatMap { prposedInterlocutor in
                SearchService
                    .likeProposedInterlocutor(with: prposedInterlocutor.id)
                    .map { prposedInterlocutor }
                    .catchError { _ in .never() }
                }
            .asSignal(onErrorSignalWith: .never())
    }
    
    private func createDislikeComplete() -> Signal<ProposedInterlocutor> {
        dislike
            .flatMap { prposedInterlocutor in
                SearchService
                    .dislikeProposedInterlocutor(with: prposedInterlocutor.id)
                    .map { prposedInterlocutor }
                    .catchError { _ in .never() }
                }
            .asSignal(onErrorSignalWith: .never())
    }
}
