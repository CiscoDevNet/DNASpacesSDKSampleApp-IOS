//
//  PrivacyTableViewCell.swift
//  OpenRoaming
//
//  Created by rajesh36 on 06/12/19.
//  Copyright © 2019 rajesh36. All rights reserved.
//

import UIKit
protocol DeleteButtonsDelegate{
    func deleteDevice(index:Int)
}

class DeviceTableViewCell: UITableViewCell {
    var deviceName: UILabel = UILabel()
    var deviceType: UILabel = UILabel()
    var deleteButton: UIButton = UIButton()
    var iconView: UIImageView = UIImageView.init()
    var token: String?
    var index: Int = 0
    var profileId: String = ""
    var delegate: DeleteButtonsDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Make it card-like
        contentView.setNeedsLayout()
        let frame = contentView.frame;
        deviceName.textColor = UIColor.black
        deviceName.textAlignment = .left
        deviceName.font = UIFont.systemFont(ofSize:18.0 )
        deviceName.frame = CGRect(x: 70, y: 14, width: frame.size.width - 90.0, height: 30)
        deviceType.textColor = UIColor.lightGray
        deviceType.textAlignment = .left
        deviceType.font = UIFont.systemFont(ofSize:14.0 )
        deviceType.frame = CGRect(x: 70, y: 32, width: frame.size.width - 80.0, height: 30)
        let phoneImage = UIImage.init(named: "phone")!
        iconView.image = phoneImage
        iconView.frame = CGRect(x: 30, y:40 - phoneImage.size.height/2, width: phoneImage.size.width, height: phoneImage.size.height)
        let deleteImage = UIImage.init(named: "delete")!
        deleteButton.setImage(deleteImage, for: .normal)
        deleteButton.addTarget(self, action:#selector(didTapDeleteButton),for:.touchUpInside)
        contentView.addSubview(deviceName)
        contentView.addSubview(deviceType)
        contentView.addSubview(deleteButton)
        deleteButton.frame = CGRect(x: frame.size.width, y: 40 - deleteImage.size.height/2, width: deleteImage.size.width, height: deleteImage.size.height)
        
        contentView.addSubview(iconView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }

    @objc func didTapDeleteButton() {
        delegate?.deleteDevice(index: self.index)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)        
        // Configure the view for the selected state
    }
    
}
