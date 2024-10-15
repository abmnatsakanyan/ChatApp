//
//  MessageInputBar.swift
//  ChatApp
//
//  Created by Albert Mnatsakanyan on 10/14/24.
//

import UIKit
import InputBarAccessoryView

final class MessageInputBar: InputBarAccessoryView {
    private let textLimit: Int
    
    init(textLimit: Int) {
        self.textLimit = textLimit
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        inputTextView.textContainerInset = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 36)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 36)
        inputTextView.isImagePasteEnabled = false
        inputTextView.layer.borderColor = UIColor.systemGray2.cgColor
        inputTextView.layer.borderWidth = 1.0
        inputTextView.layer.cornerRadius = 18.0
        inputTextView.layer.masksToBounds = true
        inputTextView.delegate = self
        inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        setRightStackViewWidthConstant(to: 38, animated: false)
        setStackViewItems([sendButton], forStack: .right, animated: false)
        
        sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        sendButton.image = UIImage(systemName: "arrow.up")
        sendButton.tintColor = .white
        sendButton.title = nil
        sendButton.backgroundColor = .systemGreen
        sendButton.layer.cornerRadius = 18
        
        middleContentViewPadding.right = -38
        separatorLine.isHidden = false
        isTranslucent = true
    }
}

extension MessageInputBar: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + text.count <= textLimit
    }
}
