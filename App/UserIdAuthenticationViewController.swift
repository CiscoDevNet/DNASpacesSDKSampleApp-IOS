//
//  UserIdAuthenticationViewController.swift
//  App
//
//  Created by Luis Vasquez on 15/06/20.
//  Copyright © 2020 Cisco. All rights reserved.
//

import UIKit
import OpenRoaming

class UserIdAuthenticationViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var continueButton: UIButton!

    var pickerData: [IdType] = IdType.allCases

    override func viewDidLoad() {
        super.viewDidLoad()

        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.continueButton.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func onEditingChangedTextField(_ sender: UITextField) {
        self.continueButton.isEnabled = sender.text?.count ?? 0 > 0
    }
    @IBAction func onPrimaryActionTriggeredTextField(_ sender: UITextField) {
        sender.endEditing(true)
    }

    @IBAction func onTouchUpContinueButton(_ sender: UIButton) {
        self.showLoader()
        let id = self.textField.text!
        let idType = self.pickerData[self.pickerView.selectedRow(inComponent: 0)]
                
        OpenRoaming.associateUser(idType: idType, id: id, signingHandler: { error in
               if error == nil {
                    OpenRoaming.installProfile (provisionProfileHandler: { err in
                       if err == nil {
                           DispatchQueue.main.async {
                               self.performSegue(withIdentifier: "home", sender: self)
                                self.hideLoader()
                           }
                       }
                       else {
                           self.showErrorAndGoBack(error: err!)
                       }
                   })
               }
               else{
                   self.showErrorAndGoBack(error: error!)
               }
            }
        )
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].rawValue.capitalized.replacingOccurrences(of: "_", with: " ")
    }
}
