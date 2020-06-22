//
//  SearchService.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 22/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift

final class SearchService {}

// MARK: Proposed interlocutor

extension SearchService {
    static func proposedInterlocuters() -> Single<[ProposedInterlocutor]> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .just([]) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody: GetProposedInterlocutorsRequest(userToken: userToken))
            .map { try CheckResponseForError.letThroughError(response: $0) }
            .map { ProposedInterlocutorTransformation.from(response: $0) }
    }
}

// MARK: Match

extension SearchService {
    static func likeProposedInterlocutor(with id: Int) -> Single<Void> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .error(SignError.tokenNotFound) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody: LikeProposedInterlocutorRequest(userToken: userToken, proposedInterlocutorId: id))
            .map { try CheckResponseForError.throwIfError(response: $0) }
    }
    
    static func dislikeProposedInterlocutor(with id: Int) -> Single<Void> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .error(SignError.tokenNotFound) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody: DislikeProposedInterlocutorRequest(userToken: userToken, proposedInterlocutorId: id))
            .map { try CheckResponseForError.throwIfError(response: $0) }
    }
    
    static func unmatch(chatId: String) -> Single<Void> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .error(SignError.tokenNotFound) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody: UnmatchRequest(userToken: userToken, chatId: chatId))
            .map { _ in Void() }
    }
}

// MARK: Report

extension SearchService {
    static func createReportOnChatInterlocutor(chatId: String, report: ReportViewController.Report) -> Single<Void> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .error(SignError.tokenNotFound) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody:  CreateReportOnChatInterlocutorRequest(userToken: userToken,
                                                                               chatId: chatId,
                                                                               report: report))
            .map { _ in Void() }
    }
    
    static func createReportOnProposedInterlocutor(proposedInterlocutorId: Int, report: ReportViewController.Report) -> Single<Void> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .error(SignError.tokenNotFound) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody: CreateReportOnProposedInterlocutorRequest(userToken: userToken,
                                                                                  proposedInterlocutorId: proposedInterlocutorId,
                                                                                  report: report))
            .map { try CheckResponseForError.throwIfError(response: $0) }
    }
}
