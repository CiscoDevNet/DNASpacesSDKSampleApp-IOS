//
//  Notification.swift
//  App
//
//  Created by Luis Vasquez on 23/06/20.
//  Copyright © 2020 Cisco. All rights reserved.
//

import Foundation

struct Notification {
    var id: String
    var title: String?
    var body: String
    
    init(id: String, title: String?, body: String){
        self.id = id
        self.title = title
        self.body = body
    }
    
    static func fromUserInfo(_ userInfo: [AnyHashable : Any]) -> Notification?{
        print(userInfo)
        if let id = userInfo["gcm.message_id"] as? String {
            if let aps = userInfo["aps"] as? NSDictionary {
                if let alert = aps["alert"] as? NSDictionary {
                    if let body = alert["body"] as? String {
                        let title = alert["title"] as? String
                        return Notification(id: id, title: title, body: body)
                    }
                }
            }
        }
        return nil
    }
}

extension Notification {
    
}

extension Notification : Encodable, Decodable {
    private enum Key: String, CodingKey {
        case id = "id"
        case title = "title"
        case body = "body"
    }
    
    //Decodeble
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let id: String = try container.decode(String.self, forKey: .id)
        let title: String? = try container.decode(String?.self, forKey: .title)
        let body: String = try container.decode(String.self, forKey: .body)

        self.id = id
        self.title = title
        self.body = body
    }
    
    //Encodable
    func encode(to enconder: Encoder) throws {
        var container = enconder.container(keyedBy: Key.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(body, forKey: .body)
    }
}
