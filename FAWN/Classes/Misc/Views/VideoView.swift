//
//  OnboardingVideoView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 19/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import AVKit

final class VideoView: UIView {
    deinit {
        removeObserverForLooping()
    }
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    private var playerObserver: Any?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer?.frame = bounds
    }
    
    func resume() {
        player?.play()
    }
    
    func play(localVideoUrl: URL) {
        if player == nil || playerLayer == nil {
            let asset = AVURLAsset(url: localVideoUrl)
            let playerItem = AVPlayerItem(asset: asset)
            
            player = AVPlayer(playerItem: playerItem)
            
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = bounds
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.needsDisplayOnBoundsChange = true
            playerLayer.cornerRadius = 21
            self.playerLayer = playerLayer
            layer.insertSublayer(playerLayer, at: 0)
        }
        
        removeObserverForLooping()
        addObserverForLooping()
        
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        
        player = nil
        playerLayer = nil
        
        removeObserverForLooping()
    }
    
    // MARK: Private
    
    private func addObserverForLooping() {
        guard let player = self.player else {
            return
        }
        
        let resetPlayer = {
            player.seek(to: CMTime.zero)
            player.play()
        }
        
        playerObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                                object: player.currentItem,
                                                                queue: nil) { notification in
            resetPlayer()
        }
    }
    
    private func removeObserverForLooping() {
        if let playerObserver = self.playerObserver {
            NotificationCenter.default.removeObserver(playerObserver)
        }
    }
}
