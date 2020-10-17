//
//  UIViewControllerExtension.swift
//  App
//
//  Created by Luis Vasquez on 23/06/20.
//  Copyright © 2020 Cisco. All rights reserved.
//

import UIKit
import OpenRoaming

extension UIViewController {
    func showLoader() {
        DispatchQueue.main.async  {
            let  activityIndicatorFrame = CGRect(x: (self.view.frame.size.width - 140.0) / 2, y: (self.view.frame.size.height - 150.0)/2, width: 80.0, height: 80.0)
            let  bgView = UIView.init(frame: activityIndicatorFrame)
            bgView.tag = -11;
            bgView.backgroundColor = UIColor.init(white: 0.5, alpha: 0.8)
            bgView.layer.cornerRadius = 5.0;
            bgView.center = self.view.center
            let activityIndicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
            activityIndicator.color = UIColor.white
            var newFrame = activityIndicator.frame
            newFrame.origin.y = 20.0
            newFrame.origin.x = 20.0
            activityIndicator.frame = newFrame
            activityIndicator.startAnimating()
            bgView.addSubview(activityIndicator)
            self.view.addSubview(bgView)
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async  {
            if let viewWithTag = self.view.viewWithTag(-11) {
                viewWithTag.removeFromSuperview()
            } else { }
        }
    }
    
    func showNetworkError(action: ((UIAlertAction) -> Void)? = nil){
        let alert = UIAlertController(title: "Network Error", message: "Not able to access the internet. Please check your network connectivity", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: action != nil ? action : nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showError(error: OpenRoamingError, closeHandler: @escaping () -> Void) {
        self.showMessage(message: error.message, closeHandler: closeHandler)
    }
    
    func showErrorAndGoBack(error: OpenRoamingError) {
        self.showMessage(message: error.message, closeHandler: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func showMessage(message: String, closeHandler: @escaping () -> Void) {
        DispatchQueue.main.async  {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel, handler: { _ in
                closeHandler()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
