//
//  ReviewManager.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 16.05.25.
//

import StoreKit

class ReviewManager {

    static let shared = ReviewManager()

    func requestReviewOrRedirect() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
            UserDefaults.standard.set(true, forKey: "hasRatedKey")

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.openAppStoreReview()
            }
        } else {
            openAppStoreReview()
        }
    }

    private func openAppStoreReview() {
        guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id6745167202?action=write-review") else { return }
        UIApplication.shared.open(writeReviewURL)
    }
}
