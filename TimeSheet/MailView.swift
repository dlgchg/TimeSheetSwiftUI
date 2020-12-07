//
//  MailView.swift
//  TimeSheet
//
//  Created by 李伟 on 2020/11/26.
//

import UIKit
import MessageUI
import SwiftUI

struct MailView: UIViewControllerRepresentable {
    typealias UIViewControllerType = MFMailComposeViewController
    
    
    @Binding var isShowing: Sheet?
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        @Binding var isShowing: Sheet?
        @Binding var result: Result<MFMailComposeResult, Error>?
        
        init(isShowing: Binding<Sheet?>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _isShowing = isShowing
            _result = result
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                isShowing = nil
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing,
                           result: $result)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setSubject("\(NSLocalizedString("CFBundleDisplayName", comment: "")) \(NSLocalizedString("feedback", comment: ""))")
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        vc.setMessageBody("\n\n\(UIDevice.current.localizedModel):\(UIDevice.current.systemVersion)\nAppVersion: \(appVersion!.description)", isHTML: false)
        vc.setToRecipients(["curmido@gmail.com"])
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {
        
    }
}
