//
//  UsageViewController.swift
//  OpenRoaming
//
//  Created by rajesh36 on 03/12/19.
//  Copyright © 2019 rajesh36. All rights reserved.
//

import UIKit
import OpenRoaming

private func firstDayOfTheMonth(date: Date) -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month], from: date)
    return calendar.date(from: components)!
}

private func parseDate(_ str : String) -> Date {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = standardDateFormat
    return dateFormat.date(from: str)!
}

class UsageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usageEmptyMessage: UILabel!
    @IBOutlet weak var usageEmptyInfo: UILabel!
    @IBOutlet weak var emptyView: UIView!
    
    var sectionValue: Array<String> = []
    var usageStatistics: UsageStatistics?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.emptyView.isHidden = true
        self.tableView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoader()
        
        if NetworkUtils.isConnectedToNetwork() {
            OpenRoaming.getUsageStatistics(usageStatisticsHandler: { data, error in
                if error != nil {
                    self.showError(error:  error!, closeHandler: {
                        self.navigationController?.popViewController(animated: true)
                    })
                    return
                }
                self.usageStatistics = data
                if self.usageStatistics!.usageStatistics.count > 0 {
                    DispatchQueue.main.async {
                       self.emptyView.isHidden = true
                       self.tableView.isHidden = false
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.emptyView.isHidden = false
                        self.tableView.isHidden = true
                    }
                }

                DispatchQueue.main.async  {
                    self.hideLoader()
                    self.tableView.reloadData()
                }
            })
        }
        else {
            self.emptyView.isHidden = false
            self.tableView.isHidden = true
            
            self.showNetworkError()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Usage Statistics"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usageStatistics?.usageStatistics.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UsageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "usageCell", for: indexPath) as! UsageTableViewCell
        let usageStatistics = self.usageStatistics!.usageStatistics[indexPath.row]
        
        cell.ssidLabel.text = usageStatistics.ssid
        cell.deviceUsedLabel.text = usageStatistics.device
        
        let formattedDate = parseDate(usageStatistics.dateTime)
        cell.dateLabel.text = newDateformat(date: formattedDate)
        
        cell.durationLabel.text = getDurationAsString(duration: Int(usageStatistics.duration))
       
        return cell
    }
    
    func newDateformat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date)
        let day = components.day ?? 0
        if Int(day/10) == 1 {
            dateFormatter.dateFormat = "d'th' MMM yyyy"
        } else {
            switch day%10 {
            case 1:
                dateFormatter.dateFormat = "d'st' MMM yyyy"
            case 2:
                dateFormatter.dateFormat = "d'2nd' MMM yyyy"
            case 3:
                dateFormatter.dateFormat = "d'rd' MMM yyyy"
            default :
                dateFormatter.dateFormat = "d'th' MMM yyyy"
            }
        }
        let dateValue = dateFormatter.string(from:date)
        return dateValue
    }

    func getDurationAsString(duration:Int) -> String {
        var minutes = duration / 1000 / 60
        let seconds = duration / 1000 % 60
        var hour: Int = 0
        var hourString: String
        var minutesString: String
        var secondsString: String
        
        if(minutes >= 60) {
            hour = minutes / 60
            minutes %= 60
        }
        
        if(hour < 10) {
            hourString = "0" + String(hour) + "hr "
        } else {
            hourString = String(hour) + "hr "
        }
        
        if(minutes < 10) {
            minutesString = "0" + String(minutes) + "min "
        } else {
            minutesString = String(minutes) + "min "
        }
        
        if(seconds < 10) {
            secondsString = "0" + String(seconds) + "ss "
        } else {
            secondsString = String(seconds) + "ss "
        }
        
        return hourString + minutesString + secondsString
    }
}
