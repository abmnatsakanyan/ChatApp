//
//  ChatInteractor.swift
//  ChatApp
//
//  Created by Albert Mnatsakanyan on 10/14/24.
//

import Foundation

final class ChatInteractor: ChatInteractorProtocol {
    weak var presenter: ChatPresenterProtocol?

    private var chatService: ChatServiceProtocol

    init(chatService: ChatServiceProtocol) {
        self.chatService = chatService
        
        bindNewMessages()
    }
    
    private func bindNewMessages() {
        chatService.onReceiveMessage = { [weak self] message in
            DispatchQueue.main.async {
                self?.presenter?.didReceiveNewMessage(message)
            }
        }
    }

    func fetchMessages() throws {
        Task {
            let messages = try await chatService.fetchMessages()
            
            await MainActor.run {
                presenter?.didFetchMessages(messages)
            }
        }
    }

    func sendMessage(_ message: String) throws {
        Task {
            try await chatService.sendMessage(message)
        }
    }
}
