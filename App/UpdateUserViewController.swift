//
//  UpdateUserViewController.swift
//  App
//
//  Created by Fabiana Garcia on 6/18/20.
//  Copyright © 2020 Cisco. All rights reserved.
//

import Foundation
import UIKit
import OpenRoaming

struct UpdateUserData {
    var name: String?
    var email: String?
    var phone: String?
    var age: Int64?
    var zipCode: String?
    
    var dictionary: [String: Any] {
        return ["name": name ?? "",
                "email": email ?? "",
                "phone": phone ?? "",
                "age": age ?? 0,
                "zip": zipCode ?? ""
        ]
    }
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}

protocol UpdateUserViewControllerDelegate: NSObjectProtocol {
    func displayUpdatedData(data: UserDetail)
}

class UpdateUserViewController: UITableViewController {
 
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var updateUserButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    weak var delegate: AccountViewController?
    
    var userData: UpdateUserData?
    var userDetail: UserDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        updateUserButton.rounded()
        updateUserButton.isHidden = false
        cancelButton.rounded()
        cancelButton.isHidden = false
        
        if NetworkUtils.isConnectedToNetwork() {
            self.getUserData()
        } else {
            showNetworkError(action: { _ in
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    func getUserData() {
        self.showLoader()
        
        OpenRoaming.getUserDetails(userDetailsHandler: { data, error in
            if error != nil {
                self.showError(error:  error!, closeHandler: {
                    self.navigationController?.popViewController(animated: true)
                })
                self.hideLoader()
                return
            }
            else {
                guard let data = data else { return }
                
                self.userDetail = data
                self.updateUserDetails()
            }
        })
    }
    
    func updateUserDetails() {
        DispatchQueue.main.async {
            self.nameTextField.text = self.userDetail?.name
            self.phoneTextField.text = self.userDetail?.phone
            self.zipCodeTextField.text = self.userDetail?.zipCode
            self.ageTextField.text = "\(self.userDetail?.age ?? 0)"

            self.hideLoader()
        }
    }
    
    @IBAction func updateUser() {
        self.showLoader()
        self.userDetail?.name = self.nameTextField.text ?? ""
        self.userDetail?.phone = self.phoneTextField.text ?? ""
        self.userDetail?.zipCode = self.zipCodeTextField.text ?? ""
        self.userDetail?.age = Int64(self.ageTextField.text ?? "") ?? 0
        
        OpenRoaming.updateUserDetails(userDetail: self.userDetail!, updateUserHandler: { error in
            if error != nil {
                self.showError(error: error!, closeHandler: {
                    DispatchQueue.main.async { self.dismiss(animated: true, completion: nil) }
                })
                return
            } else {
                self.getUserData()
                DispatchQueue.main.async {
                    if let delegate = self.delegate {
                        delegate.displayUpdatedData(data: self.userDetail!)
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    
    @IBAction func cancelUpdate() {
        DispatchQueue.main.async { self.dismiss(animated: true, completion: nil) }
    }

}
