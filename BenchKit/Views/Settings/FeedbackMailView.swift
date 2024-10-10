//
//  FeedbackMailView.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import SwiftUI
#if !os(macOS)
import MessageUI

struct FeedbackMailView: UIViewControllerRepresentable {
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<FeedbackMailView>) -> MFMailComposeViewController {
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = context.coordinator
        viewController.setSubject("Feedback (BenchKit)")
        viewController.setMessageBody("\n\nApp: BenchKit (v\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String))\nLanguage: \(Locale.current.identifier)\nDevice: \(getDeviceModelVersion()) (\(UIDevice.current.systemName) \(UIDevice.current.systemVersion))\nTimestamp: \(Date.now.ISO8601Format())", isHTML: false)
        viewController.setToRecipients(["support@kubamilcarz.com"])
        return viewController
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<FeedbackMailView>) {
    }
    
    
    private func getDeviceModelVersion() -> String {
        var size: size_t = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)

        var machine = [CChar](repeating: 0, count: Int(size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)

        return String(cString: machine)
    }
}
#endif
