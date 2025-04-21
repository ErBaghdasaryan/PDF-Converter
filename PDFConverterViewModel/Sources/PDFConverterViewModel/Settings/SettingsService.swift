//
//  SettingsService.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 21.04.25.
//

import UIKit
import PDFConverterModel

public protocol ISettingsService {
    func getSettingsItems() -> [[SettingsItem]]
}

public class SettingsService: ISettingsService {
    public init() { }

    public func getSettingsItems() -> [[SettingsItem]] {
        [
            [
                SettingsItem(icon: UIImage(named: "share"), title: "Share with Friends", isSwitch: false, isVersion: false),
                SettingsItem(icon: UIImage(named: "likeUs"), title: "Like us, Rate us", isSwitch: false, isVersion: false)
            ],
            [
                SettingsItem(icon: UIImage(named: "notifications"), title: "Notification", isSwitch: true, isVersion: false),
                SettingsItem(icon: UIImage(named: "upgrade"), title: "Upgrade your plan", isSwitch: false, isVersion: false),
                SettingsItem(icon: UIImage(named: "restore"), title: "Restore Purchases", isSwitch: false, isVersion: false),
                SettingsItem(icon: UIImage(named: "cleare"), title: "Clear Cache", isSwitch: false, isVersion: false)
            ],
            [
                SettingsItem(icon: UIImage(named: "letter"), title: "Letter", isSwitch: false, isVersion: false),
                SettingsItem(icon: UIImage(named: "privacy"), title: "Policy Privacy", isSwitch: false, isVersion: false),
                SettingsItem(icon: UIImage(named: "terms"), title: "Terms & Conditions", isSwitch: false, isVersion: false),
                SettingsItem(icon: nil, title: "", isSwitch: false, isVersion: true)
            ]
        ]
    }
}
