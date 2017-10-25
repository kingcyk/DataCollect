//
//  Common.swift
//  DataCollect
//
//  Created by kingcyk on 22/10/2017.
//  Copyright © 2017 kingcyk. All rights reserved.
//

import UIKit

let tintColor = UIColor(red: 80 / 255, green: 227 / 255, blue: 194 / 255, alpha: 1)
let inactiveColor = UIColor(red: 80 / 255, green: 227 / 255, blue: 194 / 255, alpha: 0.43)
let pulseActiveColor = UIColor(red: 184 / 255, green: 233 / 255, blue: 134 / 255, alpha: 0.64)
let pulseNormalColor = UIColor(red: 74 / 255, green: 74 / 255, blue: 74 / 255, alpha: 0.54)

let deviceName = UIDevice.current.name

let dateFormatter = DateFormatter()

func roundView(_ view: UIView, withCornerRadius cornerRadius: CGFloat) {
    view.layer.cornerRadius = cornerRadius
    view.layer.masksToBounds = true
}
