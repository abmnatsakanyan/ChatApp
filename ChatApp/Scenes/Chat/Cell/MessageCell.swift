//
//  MessageCell.swift
//  ChatApp
//
//  Created by Albert Mnatsakanyan on 10/14/24.
//

import UIKit

final class MessageCell: UIView, UIContentView {

    private var messageLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    private var bubbleView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    
    var configuration: UIContentConfiguration {
        didSet {
            configure(with: configuration)
        }
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        backgroundColor = .secondarySystemBackground
        
        bubbleView.addSubview(messageLabel)
        addSubview(bubbleView)
        
        let inset = CGFloat(10)
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: inset),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -inset),
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: inset),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -inset),
            messageLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24),
            
            bubbleView.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            bubbleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
    }
    
    func configure(with configuration: UIContentConfiguration) {
        guard let config = configuration as? MessageCellContentConfiguration else { return }
        
        messageLabel.text = config.text
        
        leadingConstraint?.isActive = false
        trailingConstraint?.isActive = false
        
        switch config.isOwner {
        case true:
            bubbleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
            leadingConstraint = bubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 30)
            trailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
            bubbleView.backgroundColor = .black
            messageLabel.textColor = .white
        case false:
            bubbleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            trailingConstraint = bubbleView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -30)
            leadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
            bubbleView.backgroundColor = .white
            messageLabel.textColor = .black
        }
        
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
    }
}
