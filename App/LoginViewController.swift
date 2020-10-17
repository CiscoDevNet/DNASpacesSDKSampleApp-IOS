//
//  LoginViewController.swift
//  OpenRoaming
//
//  Created by rajesh36 on 03/12/19.
//  Copyright © 2019 rajesh36. All rights reserved.
//

import UIKit
import OpenRoaming

class LoginViewController: UIViewController {
    var authType: String!
    var emailSharing: Bool!
    @IBOutlet weak var signingView:SigningView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showLoginPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func showLoginPage(){
        OpenRoaming.associateUser(signingView: signingView, serviceName: authType, signingHandler: { error in
                
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
            }
        )
    }
}
