//
//  FirsGayCollectionViewCell.swift
//  FAWN
//
//  Created by Алексей Петров on 30/05/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import DatingKit


class FirsGayCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var videoView: VideoView!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    override func layoutSubviews() {
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        // Initialization code
    }
    
    func configScreen(with model: OnboardingCellModel) {
        super.layoutSubviews()
        subtitle.text = model.subtitle
        mainTitle.text = model.mainTitle
        continueButton.setTitle(model.buttonName, for: .normal)
        guard let path = Bundle.main.path(forResource: model.videoName, ofType:"mp4") else {
            debugPrint("video.m4v not found")
            return
        }
        var videoSize = CGSize(width: 0, height: 0)
        debugPrint(UIDevice.modelName)
        if UIDevice.modelName.contains("SE") || UIDevice.modelName.contains("5s")  {
            videoSize = CGSize(width: 260, height: 300)
        } else {
            videoSize = CGSize(width: 350, height: 500)
        }
        if UIDevice.modelName.contains("8") ||
           UIDevice.modelName.contains("6") ||
           UIDevice.modelName.contains("7")
        {
            videoSize = CGSize(width: 320, height: 400)
        }
        videoView.configure(url: path, with: videoSize)
        videoView.isLoop = true
        videoView.play()
    }

}
