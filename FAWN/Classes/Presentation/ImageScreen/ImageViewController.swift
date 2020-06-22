//
//  ImageViewController.swift
//  RACK
//
//  Created by Andrey Chernyshev on 15/03/2020.
//  Copyright © 2020 fawn.team. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift

final class ImageViewController: UIViewController {
    private lazy var imageView = makeImageView()
    
    private var url: URL!
    
    private let disposeBag = DisposeBag()
    
    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        
        self.url = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        makeConstraints()
        
        imageView.kf.setImage(with: url)
    }
}

// MARK: Make

extension ImageViewController {
    static func make(imageUrl: URL) -> ImageViewController {
        ImageViewController(url: imageUrl)
    }
}

// MARK: Make constraints

private extension ImageViewController {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension ImageViewController {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }
}
