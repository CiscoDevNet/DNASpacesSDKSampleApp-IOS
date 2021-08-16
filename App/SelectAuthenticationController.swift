//
//  SelectAuthenticationController.swift
//  OpenRoaming
//
//  Created by rajesh36 on 04/12/19.
//  Copyright © 2019 rajesh36. All rights reserved.
//

import UIKit
import OpenRoaming

class SelectAuthenticationController: UIViewController {

    @IBOutlet weak var userIdButton: UIButton!
    @IBOutlet weak var serverAuthCodeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userIdButton.rounded()
        self.serverAuthCodeButton.rounded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        if !OpenRoaming.isSdkRegistered() {
            showLoader()
            OpenRoaming.registerSdk(appId: appId, dnaSpacesKey: dnaSpacesKey,region:Region.US ,registerSdkHandler: {
                signingState, error in
                self.hideLoader()
                
                if error != nil {
                    self.showError(error: error!, closeHandler: {})
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if !NetworkUtils.isConnectedToNetwork() {
            Utils.showNetworkAlertError(controller: self)
            return
        }
        
        if segue.identifier == "google" || segue.identifier == "apple"{
            let controller = segue.destination as! LoginViewController
            if segue.identifier == "google" {
                controller.authType = "google"
                controller.title = "Google Authentication"
            }
            else {
                controller.authType = "apple"
                controller.title = "Apple Authentication"
            }
        }
    }
}
