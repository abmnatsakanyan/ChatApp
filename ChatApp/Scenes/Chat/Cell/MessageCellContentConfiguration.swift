//
//  MessageCellContentConfiguration.swift
//  ChatApp
//
//  Created by Albert Mnatsakanyan on 10/14/24.
//

import UIKit

struct MessageCellContentConfiguration: UIContentConfiguration, Hashable {
    private let identifier = UUID()
    let text: String
    let isOwner: Bool

    init(text: String, isOwner: Bool) {
        self.text = text
        self.isOwner = isOwner
    }
    
    static func == (lhs: MessageCellContentConfiguration, rhs: MessageCellContentConfiguration) -> Bool {
        lhs.identifier == rhs.identifier
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    func makeContentView() -> UIView & UIContentView {
        return MessageCell(self)
    }

    func updated(for state: UIConfigurationState) -> MessageCellContentConfiguration {
        return self
    }
}
