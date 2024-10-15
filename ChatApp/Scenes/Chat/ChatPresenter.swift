//
//  ChatPresenter.swift
//  ChatApp
//
//  Created by Albert Mnatsakanyan on 10/14/24.
//

import Foundation

final class ChatPresenter: ChatPresenterProtocol {
    weak var view: ChatViewProtocol?
    var interactor: ChatInteractorProtocol?

    func viewDidLoad() {
        do {
            try interactor?.fetchMessages()
        } catch {
            view?.onReceiveError(error.localizedDescription)
        }
    }

    func didFetchMessages(_ messages: [Message]) {
        view?.updateMessages(
            messages.compactMap {
                .init(
                    text: $0.text,
                    isOwner: $0.owner == .current
                )
            }
        )
    }

    func didTapSend(_ message: String) {
        do {
            try interactor?.sendMessage(message)
        } catch {
            view?.onReceiveError(error.localizedDescription)
        }
    }

    func didReceiveNewMessage(_ message: Message) {
        view?.updateMessages([.init(text: message.text, isOwner: message.owner == .current)])
    }
}
