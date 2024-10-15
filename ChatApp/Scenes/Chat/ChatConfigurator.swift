//
//  ChatConfigurator.swift
//  ChatApp
//
//  Created by Albert Mnatsakanyan on 10/14/24.
//

import UIKit

struct ChatConfigurator {
    static func configure() -> UIViewController {
        let chatReversalService = ChatReversalService(delayInSeconds: 3)
        let inputBar = MessageInputBar(textLimit: 300)
        
        let presenter = ChatPresenter()
        let view = ChatViewController(presenter: presenter, inputBar: inputBar)
        let interactor = ChatInteractor(chatService: chatReversalService)

        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter

        return view
    }
}
