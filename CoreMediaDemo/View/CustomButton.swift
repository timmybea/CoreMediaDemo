//
//  CustomButton.swift
//  CoreMediaDemo
//
//  Created by Tim Beals on 2018-10-12.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    enum Option: String {
        case begin = "Begin"
        case playMovie = "Play Movie"
        case closeMovie = "Close Movie Player"
    }

    var option: Option {
        didSet {
            self.setTitle(option.rawValue, for: .normal)
        }
    }

    override init(frame: CGRect) {
        self.option = .begin
        super.init(frame: frame)
        self.setTitle(self.option.rawValue, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
