//
//  Utils.swift
//  App
//
//  Created by Luis Vasquez on 19/05/20.
//  Copyright © 2020 Cisco. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    static func showAlert(controller: UIViewController, title: String, message: String){
        let alert = UIAlertController(title: "Network Error", message: "Not able to access the internet. Please check your network connectivity", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
    static func showNetworkAlertError(controller: UIViewController){
        showAlert(controller: controller, title: "Network Error", message: "Not able to access the internet. Please check your network connectivity")
    }

}
