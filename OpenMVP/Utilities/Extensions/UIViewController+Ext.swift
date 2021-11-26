//
//  UIViewController+Ext.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import PKHUD

extension UIViewController {
    
    var appDelegate:AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var errorBinding: Binder<Error> {
        return Binder(self, binding: { (vc, error) in
            Log.debug(error)
            Log.error(error.localizedDescription)
            let errorMessage = error.localizedDescription
            PKHUD.sharedHUD.contentView = PKHUDErrorView(title: NSLocalizedString("error", comment: "Error"), subtitle: errorMessage)
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.hide(afterDelay: 2.0) { success in
                // Completion Handler
            }
        })
    }
    
    var messageBinding: Binder<String> {
        return Binder(self, binding: { (vc, message) in
            PKHUD.sharedHUD.contentView = PKHUDErrorView(title: NSLocalizedString("error", comment: "Error"), subtitle: message)
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.hide(afterDelay: 3.0) { success in
            }
        })
    }
    
    var successBinding: Binder<Void> {
        return Binder(self, binding: { (vc, _) in
            PKHUD.sharedHUD.contentView = PKHUDSuccessView()
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.hide(afterDelay: 1.0) { success in
            }
        })
    }
    
    var fetchingBinding: Binder<Bool> {
        return Binder(self, binding: { (vc, valid) in
            if (valid == true) {
                PKHUD.sharedHUD.contentView = PKHUDProgressView()
                PKHUD.sharedHUD.show()
            } else if let _ = PKHUD.sharedHUD.contentView as? PKHUDProgressView {
                PKHUD.sharedHUD.hide()
            }
        })
    }
}

extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Void> {
        return ControlEvent<Void>(events: base.rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).mapToVoid())
    }
}
