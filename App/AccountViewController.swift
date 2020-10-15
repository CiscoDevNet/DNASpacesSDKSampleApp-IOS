//
//  AccountViewController.swift
//  OpenRoaming
//
//  Created by Luis Vasquez on 23/06/20.
//  Copyright © 2020 Cisco. All rights reserved.
//

import UIKit
import NetworkExtension
import OpenRoaming

class AccountViewController: UITableViewController, UpdateUserViewControllerDelegate {

    @IBOutlet weak var serviceLogo: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userAge: UILabel!

    @IBOutlet weak var userPhone: UILabel!
    
    @IBOutlet weak var pushNotificationSwitch: UISwitch!
    @IBOutlet weak var privacySettingsSwitch: UISwitch!
    
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var deleteProfileButton: UIButton!
    
    var user: UserDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateButton.rounded()
        self.deleteAccountButton.rounded()
        self.deleteProfileButton.rounded()
        
        self.getUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func getUserData() {
        self.showLoader()
        
        OpenRoaming.getUserDetails(userDetailsHandler: { data, error in
            self.hideLoader()
            if error != nil {
                self.showError(error:  error!, closeHandler: {
                    self.navigationController?.popViewController(animated: true)
                })
                return
            }
            else {
                self.user = data
                self.showUserData()
                self.showPushNotificationData()
                self.getPrivacySettingsData()
            }
        })
    }
    
    func getPrivacySettingsData() {
        self.showLoader()
        OpenRoaming.getPrivacySettings(getPrivacySettingsHandler: { value, error in
            self.hideLoader()
            if error != nil {
                self.showError(error:  error!, closeHandler: {})
                return
            }
            else {
                DispatchQueue.main.async {
                    self.privacySettingsSwitch.isOn = value!
                }
            }
        })
    }
    
    @IBAction func touchUpDeleteAccountButton(_ sender: UIButton) {
        self.showLoader()
        OpenRoaming.deleteUser(deleteUserHandler: { error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.navigationController?.popToRootViewController(animated: true)
                self.hideLoader()
            }
        })
    }
    
    @IBAction func touchUpDeleteProfileButton(_ sender: UIButton) {
        self.showLoader()
        OpenRoaming.deleteProfile(deleteProfileHandler: { error in            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.navigationController?.popToRootViewController(animated: true)
                self.hideLoader()
            }
        })
    }
    
    func showUserData() {
        if let user = self.user {
            self.hideLoader()
            //self.serviceLogo.image = UIImage.init(named: "\(user.serviceName.rawValue)_logo")
            DispatchQueue.main.async {
                self.userEmail.text = user.email
                self.userAge.text = "\(user.age)"
                self.userPhone.text = user.phone
            }
        }
    }
    
    func showPushNotificationData(){
        DispatchQueue.main.async {
            self.pushNotificationSwitch.isOn = OpenRoaming.isPushAssociated()
        }
    }
    
    @IBAction func pushNotificationChanged(_ sender: UISwitch) {
        self.showLoader()
        if (sender.isOn == true) {
            associatePushIdentifier(pushIdentifier: NotificationHelper.pushIdentify!)
        }else{
            dissociatePushIdentifier()
        }
    }
    
    private func associatePushIdentifier(pushIdentifier : String) {
        OpenRoaming.associatePushIdentifier(pushIdentifier: pushIdentifier, associatePushHandler: { error in
            self.hideLoader()
            if error != nil {
                self.showError(error:  error!, closeHandler: {})
                self.pushNotificationSwitch.isOn = false
            }
            else {
                self.pushNotificationSwitch.isOn = true
            }
        })
    }
    
    private func dissociatePushIdentifier() {
        OpenRoaming.dissociatePushIdentifier(associatePushHandler: { error in
            self.hideLoader()
            if error != nil {
                self.showError(error:  error!, closeHandler: {})
                self.pushNotificationSwitch.isOn = true
                return
            }
            else{
                self.pushNotificationSwitch.isOn = false
            }
        })
    }
    
    @IBAction func privacySettingsChanged(_ sender: UISwitch) {
        self.showLoader()
        OpenRoaming.setPrivacySettings(acceptPrivacySettings: sender.isOn, privacySettingsHandler: { response, error in
            self.hideLoader()
            if error != nil {
                self.showError(error:  error!, closeHandler: {})
                return
            }
        })
    }
    
    @IBAction func updateButton(_ sender: UIButton) {
        performSegue(withIdentifier: "UpdateUserSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "UpdateUserSegue") {
            let displayVC = segue.destination as! UpdateUserViewController
            displayVC.delegate = self
        }
    }
    
    func displayUpdatedData(data: UserDetail) {
        self.userEmail.text = data.email
        self.userAge.text = "\(data.age)"
        self.userPhone.text = data.phone
    }
}
