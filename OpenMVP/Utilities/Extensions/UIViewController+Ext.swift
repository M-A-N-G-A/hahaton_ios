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
    

        class func instantiate<T: UIViewController>(appStoryboard: AppStoryboard) -> T {

            let storyboard = UIStoryboard(name: appStoryboard.rawValue, bundle: nil)
            let identifier = String(describing: self)
            return storyboard.instantiateViewController(withIdentifier: identifier) as! T
        }
    
//    static func instantiateFrom<T: UIViewController>(storyboard name: String) -> T {
//        let storyboard = UIStoryboard(name: name, bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: Utilities.classNameAsString(obj: T.self))
//        return vc as! T
//    }
    
    var appDelegate:AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var errorBinder: Binder<Error> {
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
    
    var messageBinder: Binder<String> {
        return Binder(self, binding: { (vc, message) in
            PKHUD.sharedHUD.contentView = PKHUDErrorView(title: NSLocalizedString("error", comment: "Error"), subtitle: message)
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.hide(afterDelay: 3.0) { success in
            }
        })
    }
    
    var successBinder: Binder<Void> {
        return Binder(self, binding: { (vc, _) in
            PKHUD.sharedHUD.contentView = PKHUDSuccessView()
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.hide(afterDelay: 1.0) { success in
            }
        })
    }
    
    var fetchingBinder: Binder<Bool> {
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
