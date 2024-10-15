//
//  ChatService.swift
//  ChatApp
//
//  Created by Albert Mnatsakanyan on 10/14/24.
//

import Foundation

protocol ChatServiceProtocol {
    var onReceiveMessage: ((Message) -> Void)? { get set }

    func sendMessage(_ message: String) async throws
    func fetchMessages() async throws -> [Message]
}

final class ChatReversalService: ChatServiceProtocol {
    var onReceiveMessage: ((Message) -> Void)?

    private var delay: UInt64

    init(delayInSeconds: Int) {
        self.delay = UInt64(delayInSeconds) * 1_000_000_000
    }

    func sendMessage(_ message: String) async throws {
        let sentMessage = Message(owner: .current, text: message)
        
        onReceiveMessage?(sentMessage)
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: delay)
        
        await reverseMessage(message)
    }

    func fetchMessages() async throws -> [Message] {
        return [Message(owner: .other, text: "Hello")]
    }
    
    private func reverseMessage(_ message: String) async {
        Task(priority: .background) {
            onReceiveMessage?(Message(owner: .other, text: String(message.reversed())))
        }
    }
}
