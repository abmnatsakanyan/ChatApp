//
//  ChatInterfaces.swift
//  ChatApp
//
//  Created by Albert Mnatsakanyan on 10/14/24.
//

import Foundation

protocol ChatViewProtocol: AnyObject {
    func updateMessages(_ messages: [MessageCellContentConfiguration])
    func onReceiveError(_ error: String)
}

protocol ChatInteractorProtocol: AnyObject {
    func fetchMessages() throws
    func sendMessage(_ message: String) throws
}

protocol ChatPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didFetchMessages(_ messages: [Message])
    func didTapSend(_ message: String)
    func didReceiveNewMessage(_ message: Message)
}
