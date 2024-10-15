//
//  Message.swift
//  ChatApp
//
//  Created by Albert Mnatsakanyan on 10/14/24.
//

import Foundation

struct Message {
    enum Sender {
        case current
        case other
    }
    
    let text: String
    let owner: Sender

    init(owner: Sender, text: String) {
        self.owner = owner
        self.text = text
    }
}
