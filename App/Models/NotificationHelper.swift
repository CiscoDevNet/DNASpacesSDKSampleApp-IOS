//
//  NotificationHelper.swift
//  App
//
//  Created by Luis Vasquez on 23/06/20.
//  Copyright © 2020 Cisco. All rights reserved.
//

import Foundation

struct NotificationHelper {
    private static let TOKEN = "TOKEN"
    private static let ENABLED = "ENABLED"
    private static let NOTIFICATIONS = "NOTIFICATIONS"
    
    static func add(_ notification: Notification) {
        var list: Array<Notification> = self.list()
        
        if self.has(notification) {
            return
        }
        
        list.append(notification)
        if let encoded = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(encoded, forKey: NOTIFICATIONS)
        }
    }
    
    static func remove(_ notification: Notification) {
        var list = self.list()
        var removed = false
        for i in 0 ..< list.count {
            let n = list[i]
            if notification.id == n.id {
                list.remove(at: i)
                removed = true
                break
            }
        }
        
        if removed {
            if let encoded = try? JSONEncoder().encode(list) {
                UserDefaults.standard.set(encoded, forKey: NOTIFICATIONS)
            }
        }
    }

    static func list() -> Array<Notification> {
        if let data = UserDefaults.standard.data(forKey: NOTIFICATIONS) {
            if let decoded = try? JSONDecoder().decode(Array<Notification>.self, from: data) {
                return decoded
            }
        }
        return Array<Notification>()
    }
    
    static func has(_ notification: Notification) -> Bool {
        let list = self.list()
        for n in list {
            if notification.id == n.id {
                return true
            }
        }
        return false
    }
    
    static var isEnabled: NotificationEnable {
        get {
            let data = UserDefaults.standard.string(forKey: ENABLED)
            if data == nil || data == "undefined"{
                return .undefined
            }
            else if data == "enabled"{
                return .enabled
            }
            else {
                return .disabled
            }
        }
        set(value) { UserDefaults.standard.set(value.rawValue, forKey: ENABLED) }
    }
    
    static var pushIdentify: String? {
        get { UserDefaults.standard.string(forKey: TOKEN) }
        set(value) { UserDefaults.standard.set(value, forKey: TOKEN) }
    }
}

enum NotificationEnable : String {
    case enabled
    case disabled
    case undefined
}
