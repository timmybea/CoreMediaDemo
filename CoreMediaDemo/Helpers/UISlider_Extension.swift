//
//  UISlider_Extension.swift
//  CoreMediaDemo
//
//  Created by Tim Beals on 2018-10-12.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit
import AVFoundation

extension UISlider {
    
    func setSliderValue(for player: AVPlayer, progress: CMTime) {
        guard let duration = player.currentItem?.duration else { return }
        let totalSeconds = CMTimeGetSeconds(duration)
        let progressSeconds = CMTimeGetSeconds(progress)
        self.value = Float(progressSeconds / totalSeconds)
    }
    
}
