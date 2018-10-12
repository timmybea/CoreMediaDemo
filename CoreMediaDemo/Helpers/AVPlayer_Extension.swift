//
//  AVPlayer_Extension.swift
//  CoreMediaDemo
//
//  Created by Tim Beals on 2018-10-12.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import Foundation
import AVFoundation

extension AVPlayer {
    
    enum observableKey: String {
        case loadedTimeRanges = "currentItem.loadedTimeRanges"
    }
    
}
