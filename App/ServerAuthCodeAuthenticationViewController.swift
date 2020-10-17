//
//  ServerAuthCodeAuthenticationViewController.swift
//  App
//
//  Created by Luis Vasquez on 15/06/20.
//  Copyright © 2020 Cisco. All rights reserved.
//

import UIKit
import OpenRoaming
import AuthenticationServices

class ServerAuthCodeAuthenticationViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    @IBAction func onTouchUpAppleButton() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.requestedOperation = .operationLogin
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension ServerAuthCodeAuthenticationViewController: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential{
            let authorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)!
            self.onAuthorizationSuccess(authorizationCode: authorizationCode)
        }
    }
    
    private func onAuthorizationSuccess(authorizationCode: String) {
        OpenRoaming.associateUser(serverAuthCode: authorizationCode, serviceName: .apple, signingHandler: { error in

            if error == nil {
                OpenRoaming.installProfile(provisionProfileHandler: { error in
                    
                    if error == nil {
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "home", sender: self)
                        }
                    }
                    else{
                        self.showErrorAndGoBack(error: error!)
                    }
                })
            }
            else{
                self.showErrorAndGoBack(error: error!)
            }
        })
    }
}

extension ServerAuthCodeAuthenticationViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
