//
//  VideoPlayerView.swift
//  iOSPhotos
//
//  Created by Chan on 9/1/24.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?

    let playPauseButton = UIButton()
    let rewindButton = UIButton()
    let forwardButton = UIButton()
    let timeSlider = UISlider()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayer()
        setupControls()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupPlayer() {
        player = AVPlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = bounds
        if let layer = playerLayer {
            self.layer.addSublayer(layer)
        }
    }

    private func setupControls() {
        playPauseButton.addTarget(self, action: #selector(togglePlayPause), for: .touchUpInside)
        rewindButton.addTarget(self, action: #selector(rewind), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(forward), for: .touchUpInside)
    }

    @objc func togglePlayPause() {
        if player?.rate == 0 {
            player?.play()
        } else {
            player?.pause()
        }
    }

    @objc func rewind() {
        if let currentTime = player?.currentTime() {
            var newTime = CMTimeGetSeconds(currentTime) - 10.0
            if newTime < 0 { newTime = 0 }
            player?.seek(to: CMTimeMake(value: Int64(newTime * 1000), timescale: 1000))
        }
    }

    @objc func forward() {
        if let currentTime = player?.currentTime(), let duration = player?.currentItem?.duration {
            var newTime = CMTimeGetSeconds(currentTime) + 10.0
            let durationSeconds = CMTimeGetSeconds(duration)
            if newTime > durationSeconds { newTime = durationSeconds }
            player?.seek(to: CMTimeMake(value: Int64(newTime * 1000), timescale: 1000))
        }
    }

    func configure(with url: URL) {
        player?.replaceCurrentItem(with: AVPlayerItem(url: url))
    }
}
