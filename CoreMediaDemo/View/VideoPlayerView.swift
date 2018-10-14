//
//  VideoPlayerView.swift
//  CoreMediaDemo
//
//  Created by Tim Beals on 2018-10-12.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    //MARK: Properties
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    private var gradientLayer: CAGradientLayer?
    
    private var isSettingPlay = true
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()

    private let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    var videoLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(handleSliderChangedValue), for: .valueChanged)
        return slider
    }()
    
    init(withFrame frame: CGRect, videoURLString: String) {
        super.init(frame: frame)
        
        setupGradientLayer()
        backgroundColor = UIColor.black
        
        setupVideoPlayer(with: videoURLString)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleTapGesture() {
    
        if isSettingPlay {
            player?.pause()
        } else {
            player?.play()
        }
        isSettingPlay = !isSettingPlay
    }
    
    @objc private func handleSliderChangedValue() {
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            
            let value = Float64(slider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            player?.seek(to: seekTime, completionHandler: { (_) in })
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard keyPath == AVPlayer.observableKey.loadedTimeRanges.rawValue else { return }
        
        activityIndicatorView.stopAnimating()
        controlsContainerView.backgroundColor = UIColor.clear
        
        guard let duration = player?.currentItem?.duration else { return }
        videoLengthLabel.text = String.duration(from: duration)
    }
    
}

//MARK: UI Layout
extension VideoPlayerView {
    
    private func setupGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = bounds
        gradientLayer?.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer?.locations = [0.9, 1.6]
        controlsContainerView.layer.addSublayer(gradientLayer!)
    }
    
    private func setupSubviews() {
        
        controlsContainerView.frame = self.bounds
        self.addSubview(controlsContainerView)
        
        controlsContainerView.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))

        controlsContainerView.addSubview(videoLengthLabel)
        NSLayoutConstraint.activate([
            videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            videoLengthLabel.widthAnchor.constraint(equalToConstant: 45),
            videoLengthLabel.heightAnchor.constraint(equalToConstant: 22)
            ])
        
        controlsContainerView.addSubview(currentTimeLabel)
        NSLayoutConstraint.activate([
            currentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            currentTimeLabel.widthAnchor.constraint(equalToConstant: 45),
            currentTimeLabel.heightAnchor.constraint(equalToConstant: 22)
            ])
        
        controlsContainerView.addSubview(slider)
        NSLayoutConstraint.activate([
            slider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor),
            slider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            slider.heightAnchor.constraint(equalToConstant: 24)
            ])
    }
}

//MARK: Player logic
extension VideoPlayerView {
    
    private func setupVideoPlayer(with path: String) {
        addPlayer(with: path)
        player?.play()
        
        player?.addObserver(self, forKeyPath: AVPlayer.observableKey.loadedTimeRanges.rawValue, options: .new, context: nil)
        
        trackVideoProgress()
    }
    
    private func addPlayer(with urlPath: String) {
        let videoURL = URL(fileURLWithPath: urlPath)
        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        
        self.layer.addSublayer(playerLayer!)
        playerLayer?.frame = self.bounds
    }
    
    private func trackVideoProgress() {
        let interval = CMTime(value: 1, timescale: 2) //value/timescale = seconds (0.5 seconds)
        player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            self.currentTimeLabel.text = String.duration(from: progressTime)
            if let player = self.player {
                self.slider.setSliderValue(for: player, progress: progressTime)
            }
        })
    }
}
