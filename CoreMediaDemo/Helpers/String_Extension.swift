//
//  String_Extension.swift
//  CoreMediaDemo
//
//  Created by Tim Beals on 2018-10-12.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import Foundation
import AVFoundation

//MARK: String Extensions
extension String {
    
    static func duration(from time: CMTime) -> String {
        let totalSeconds = CMTimeGetSeconds(time)
        let secondsText = String(format: "%02d", Int(totalSeconds) % 60)
        let minutesText = String(format: "%02d", Int(totalSeconds) / 60)
        return  "\(minutesText):\(secondsText)"
    }
    
}
