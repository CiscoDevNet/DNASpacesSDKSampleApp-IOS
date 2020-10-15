//
//  NotificationsViewController.swift
//  App
//
//  Created by Luis Vasquez on 23/06/20.
//  Copyright © 2020 Cisco. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UILabel!
    let notifications = NotificationHelper.list()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false

        if notifications.count == 0 {
            self.tableView.isHidden = true
        }
        else {
            self.label.isHidden = true
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let view = UITableViewCell()
        view.textLabel?.text = self.notifications[indexPath.item].body
        return view
    }

}
