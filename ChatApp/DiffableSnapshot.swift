//
//  DiffableSnapshot.swift
//  ChatApp
//
//  Created by Albert Mnatsakanyan on 10/14/24.
//

import UIKit

typealias DiffableSection = Hashable

final class CollectionDiffableSnapshot<Cell: Hashable, Section: DiffableSection> {
    typealias Item = Cell
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>

    private(set) var dataSource: DataSource
    
    weak var collectionView: UICollectionView!

    init(collectionView: UICollectionView, cellProvider: @escaping DataSource.CellProvider) {
        self.collectionView = collectionView
        self.dataSource = DataSource(collectionView: collectionView, cellProvider: cellProvider)
    }

    func clearItems() {
        var snapshot = dataSource.snapshot()

        snapshot.deleteAllItems()

        dataSource.apply(snapshot)
    }

    func insertItem(_ items: [Item], at section: Section?) {
        var snapshot = dataSource.snapshot()

        if let section {
            if !snapshot.sectionIdentifiers.contains(section) {
                snapshot.appendSections([section])
            }
        }

        snapshot.appendItems(items, toSection: section)

        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func delete(_ items: [Item]) {
        var snapshot = dataSource.snapshot()

        snapshot.deleteItems(items)

        dataSource.apply(snapshot)
    }
    
    func items(for section: Int) -> [Item] {
        let snapshot = dataSource.snapshot()
        
        if snapshot.sectionIdentifiers.indices.contains(section) {
            let section = snapshot.sectionIdentifiers[section]
            
            return snapshot.itemIdentifiers(inSection: section)
        }
        
        return []
    }

    func item(at indexPath: IndexPath) -> Item? {
        let items = items(for: indexPath.section)
        
        if !items.isEmpty {
            return items[indexPath.row]
        }
        
        return nil
    }
}
