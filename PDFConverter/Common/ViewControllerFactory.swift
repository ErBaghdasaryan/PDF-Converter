//
//  ViewControllerFactory.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 17.04.25.
//

import Foundation
import Swinject
import PDFConverterModel
import PDFConverterViewModel

final class ViewControllerFactory {
    private static let commonAssemblies: [Assembly] = [ServiceAssembly()]

    //MARK: Onboarding
    static func makeOnboardingViewController() -> OnboardingViewController {
        let assembler = Assembler(commonAssemblies + [OnboardingAssembly()])
        let viewController = OnboardingViewController()
        viewController.viewModel = assembler.resolver.resolve(IOnboardingViewModel.self)
        return viewController
    }

    //MARK: Notification
    static func makeNotificationViewController() -> NotificationViewController {
        let assembler = Assembler(commonAssemblies + [NotificationAssembly()])
        let viewController = NotificationViewController()
        viewController.viewModel = assembler.resolver.resolve(INotificationViewModel.self)
        return viewController
    }

    //MARK: Payment
    static func makePaymentViewController() -> PaymentViewController {
        let assembler = Assembler(commonAssemblies + [PaymentAssembly()])
        let viewController = PaymentViewController()
        viewController.viewModel = assembler.resolver.resolve(IPaymentViewModel.self)
        return viewController
    }

    //MARK: - TabBar
    static func makeTabBarViewController() -> TabBarViewController {
        let assembler = Assembler(commonAssemblies + [TabBarAssembly()])
        let viewController = TabBarViewController()
        viewController.viewModel = assembler.resolver.resolve(ITabBarViewModel.self)
        return viewController
    }

    //MARK: Generator
    static func makeMainViewController() -> MainViewController {
        let assembler = Assembler(commonAssemblies + [MainAssembly()])
        let viewController = MainViewController()
        viewController.viewModel = assembler.resolver.resolve(IMainViewModel.self)
        return viewController
    }

    //MARK: History
    static func makeHistoryViewController() -> HistoryViewController {
        let assembler = Assembler(commonAssemblies + [HistoryAssembly()])
        let viewController = HistoryViewController()
        viewController.viewModel = assembler.resolver.resolve(IHistoryViewModel.self)
        return viewController
    }

    //MARK: Select
    static func makeSelectViewController(navigationModel: SelectNavigationModel) -> SelectViewController {
        let assembler = Assembler(commonAssemblies + [SelectAssembly()])
        let viewController = SelectViewController()
        viewController.viewModel = assembler.resolver.resolve(ISelectViewModel.self, argument: navigationModel)
        return viewController
    }

    //MARK: Signature
    static func makeSignatureViewController(navigationModel: PDFUrlNavigationModel) -> SignatureViewController {
        let assembler = Assembler(commonAssemblies + [SignatureAssembly()])
        let viewController = SignatureViewController()
        viewController.viewModel = assembler.resolver.resolve(ISignatureViewModel.self, argument: navigationModel)
        return viewController
    }

    //MARK: PDFSignaturePlacementViewController
    static func makePDFSignaturePlacementViewControllerViewController(navigationModel: PDFSignaturePlacementServiceNavModel) -> PDFSignaturePlacementViewController {
        let assembler = Assembler(commonAssemblies + [PDFSignaturePlacementAssembly()])
        let viewController = PDFSignaturePlacementViewController()
        viewController.viewModel = assembler.resolver.resolve(IPDFSignaturePlacementViewModel.self, argument: navigationModel)
        return viewController
    }

    //MARK: Text
    static func makeTextViewController(navigationModel: PDFUrlNavigationModel) -> TextViewController {
        let assembler = Assembler(commonAssemblies + [TextAssembly()])
        let viewController = TextViewController()
        viewController.viewModel = assembler.resolver.resolve(ITextViewModel.self, argument: navigationModel)
        return viewController
    }

    //MARK: Split
    static func makeSplitViewController(navigationModel: PDFUrlNavigationModel) -> SplitViewController {
        let assembler = Assembler(commonAssemblies + [SplitAssembly()])
        let viewController = SplitViewController()
        viewController.viewModel = assembler.resolver.resolve(ISplitViewModel.self, argument: navigationModel)
        return viewController
    }

    //MARK: SplitAction
    static func makeSplitActionViewController(navigationModel: SplitActionNavigationModel) -> SplitActionViewController {
        let assembler = Assembler(commonAssemblies + [SplitActionAssembly()])
        let viewController = SplitActionViewController()
        viewController.viewModel = assembler.resolver.resolve(ISplitActionViewModel.self, argument: navigationModel)
        return viewController
    }

    //MARK: Settings
    static func makeSettingsViewController() -> SettingsViewController {
        let assembler = Assembler(commonAssemblies + [SettingsAssembly()])
        let viewController = SettingsViewController()
        viewController.viewModel = assembler.resolver.resolve(ISettingsViewModel.self)
        return viewController
    }

    //MARK: PrivacyPolicy
    static func makePrivacyViewController() -> PrivacyViewController {
        let viewController = PrivacyViewController()
        return viewController
    }

    //MARK: Terms
    static func makeTermsViewController() -> TermsViewController {
        let viewController = TermsViewController()
        return viewController
    }

    //MARK: ContactUs
    static func makeContactUsViewController() -> ContactUsViewController {
        let viewController = ContactUsViewController()
        return viewController
    }
}
