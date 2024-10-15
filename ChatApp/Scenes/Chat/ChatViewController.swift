//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Albert Mnatsakanyan on 10/14/24.
//

import UIKit
import InputBarAccessoryView

private enum Section: DiffableSection {
    case main
}

final class ChatViewController: UIViewController {
    private let presenter: ChatPresenterProtocol
    private let inputBar: InputBarAccessoryView
    private let keyboardManager = KeyboardManager()
    private var collectionView: UICollectionView!
    private var collectionDataSource: CollectionDiffableSnapshot<MessageCellContentConfiguration, Section>?

    init(presenter: ChatPresenterProtocol, inputBar: InputBarAccessoryView) {
        self.presenter = presenter
        self.inputBar = inputBar

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Messages"
        setupCollectionView()
        configureDataSource()
        setupMessageInputBar()
        hideKeyboardWhenTappedAround()
        presenter.viewDidLoad()
        view.layoutIfNeeded()
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())

        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.allowsSelection = false
        collectionView.contentInset.bottom += 60

        view.addSubview(collectionView)
    }

    private func setupMessageInputBar() {
        inputBar.delegate = self
        
        view.addSubview(inputBar)
        
        keyboardManager
            .bind(inputAccessoryView: inputBar)
            .bind(to: collectionView)
            .on(event: .didShow) { [weak self] not in
                guard let self else { return }
                
                self.collectionView.contentInset.bottom += not.endFrame.height
                self.collectionView.scrollToBottom(animated: true)
            }
            .on(event: .didHide) { [weak self] not in
                guard let self else { return }
                                
                UIView.animate(withDuration: 0.2) {
                    self.collectionView.contentInset.bottom -= not.endFrame.height
                }
            }
    }

    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(tap)
    }

    @objc
    private func dismissKeyboard() {
        inputBar.inputTextView.resignFirstResponder()
    }
    
    private func scrollToBottom(animated: Bool) {
        let lastItemIndex = collectionView.numberOfItems(inSection: 0) - 1
        
        if lastItemIndex >= 0 {
            let lastItemIndexPath = IndexPath(item: lastItemIndex, section: 0)
            collectionView.scrollToItem(at: lastItemIndexPath, at: .bottom, animated: false)
        }
    }

    private func createLayout() -> UICollectionViewLayout {
        let heightDimension = NSCollectionLayoutDimension.estimated(500)
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: heightDimension
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: heightDimension
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    private func configureDataSource() {
        let cellRegister = UICollectionView.CellRegistration<UICollectionViewListCell, MessageCellContentConfiguration> { cell, _, configuration in
            cell.contentConfiguration = configuration
        }
        
        collectionDataSource = CollectionDiffableSnapshot(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegister,
                for: indexPath,
                item: itemIdentifier
            )
        })
    }
}

extension ChatViewController: ChatViewProtocol {
    func updateMessages(_ messages: [MessageCellContentConfiguration]) {
        collectionDataSource?.insertItem(messages, at: .main)
        scrollToBottom(animated: true)
    }

    func onReceiveError(_ error: String) {
        let controller = UIAlertController(
            title: "Error",
            message: error,
            preferredStyle: .alert
        )
        controller.addAction(UIAlertAction(title: "OK", style: .default))
        present(controller, animated: true)
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        presenter.didTapSend(text)
        inputBar.inputTextView.text = String()
    }

    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        collectionView.contentInset.bottom = size.height + (collectionView.frame.maxY - inputBar.frame.maxY)
        collectionView.scrollToBottom(animated: false)
        print(size.height)
    }
}
