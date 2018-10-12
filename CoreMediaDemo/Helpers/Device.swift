//
//  Device.swift
//  CoreMediaDemo
//
//  Created by Tim Beals on 2018-10-12.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit

struct Device {
    
    static var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    
}
