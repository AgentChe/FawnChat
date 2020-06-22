//
//  ProposedCollectionView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 23/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ProposedInterlocutorsCollectionView: UICollectionView {
    private(set) lazy var like: Signal = _like.asSignal()
    private let _like = PublishRelay<ProposedInterlocutor>()
    
    private(set) lazy var dislike: Signal = _dislike.asSignal()
    private let _dislike = PublishRelay<ProposedInterlocutor>()
    
    private(set) lazy var report: Signal = _report.asSignal()
    private let _report = PublishRelay<ProposedInterlocutor>()
    
    private(set) lazy var changeItemsCount = _changeItemsCount.asSignal()
    private let _changeItemsCount = PublishRelay<Int>()
    
    private var elements: [ProposedInterlocutor] = [] {
        didSet {
            _changeItemsCount.accept(elements.count)
        }
    }
    
    private let queue = DispatchQueue(label: "proposed_interlocutor_table_queue")
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = SizeUtils.value(largeDevice: 24, smallDevice: 19)
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - SizeUtils.value(largeDevice: 56, smallDevice: 48),
                                 height: SizeUtils.value(largeDevice: 585, smallDevice: 481))
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(proposedInterlocutors: [ProposedInterlocutor]) {
        queue.sync { [weak self] in
            self?.elements.append(contentsOf: proposedInterlocutors)
        
            self?.reloadData()
        }
    }
    
    func remove(proposedInterlocutor: ProposedInterlocutor) {
        queue.sync { [weak self] in
            guard let index = self?.elements.firstIndex(where: { $0.id == proposedInterlocutor.id }) else {
                return
            }
            
            self?.elements.remove(at: index)
            
            self?.deleteItems(at: [IndexPath(row: index, section: 0)])
        }
    }
    
    // MARK: Private
    
    private func configure() {
        backgroundColor = .clear
        alwaysBounceVertical = false
        
        register(ProposedInterlocutorCollectionCell.self, forCellWithReuseIdentifier: String(describing: ProposedInterlocutorCollectionCell.self))
        
        dataSource = self
    }
}

// MARK: UICollectionViewDataSource

extension ProposedInterlocutorsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let proposedInterlocutor = elements[indexPath.row]
        
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: ProposedInterlocutorCollectionCell.self), for: indexPath) as! ProposedInterlocutorCollectionCell
        cell.setup(proposedInterlocutor: proposedInterlocutor)
        
        cell.likeTapped = { [weak self] in
            self?._like.accept(proposedInterlocutor)
        }
        
        cell.dislikeTapped = { [weak self] in
            self?._dislike.accept(proposedInterlocutor)
        }
        
        cell.reportTapped = { [weak self] in
            self?._report.accept(proposedInterlocutor)
        }
        
        return cell
    }
}
