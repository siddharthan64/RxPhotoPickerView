//
//  RxCollectionViewHLayout.swift
//  RxPhotoPickerView
//
//  Created by Siddharthan Asokan on 3/17/18.
//  Copyright © 2018 sid. All rights reserved.
//

import UIKit

class RxCollectionViewHLayout: UICollectionViewLayout {
    let numberOfRows: Int

    init(numberOfRows: Int) {
        self.numberOfRows = numberOfRows
        super.init()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate var cellPadding: CGFloat = 6

    var scrollDirection: UICollectionViewScrollDirection = .horizontal

    fileprivate var xOffset = [CGFloat]()
    fileprivate var yOffset = [CGFloat]()

    fileprivate var cache = [UICollectionViewLayoutAttributes]()

    fileprivate var contentWidth: CGFloat = 0

    fileprivate var contentHeight: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.top + insets.bottom)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        let rowHeight = contentHeight / CGFloat(numberOfRows)

        for row in 0 ..< numberOfRows {
            yOffset.append(CGFloat(row) * rowHeight)
        }

        var row = 0
        xOffset = [CGFloat](repeating: 0, count: numberOfRows)

        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            var attributes: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes()

            switch item {
            case 0:
                attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frameForMainCell()

                contentWidth = max(contentWidth, attributes.frame.maxX)

                updateXOffet()
            case 1, 2:
                attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frameForPrimaryCell(item: item)

            default:
                attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                let rowIndex = (abs(item - 3)) % numberOfRows

                attributes.frame = frameForSecondaryCell(rowIndex: rowIndex)

                contentWidth = max(contentWidth, attributes.frame.maxX)

                let width = cellPadding + attributes.frame.size.width

                xOffset[rowIndex] = xOffset[rowIndex] + width
            }
            cache.append(attributes)

            row = row < (numberOfRows - 1) ? (row + 1) : 0
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }

    private func frameForMainCell() -> CGRect {
        let photoHeight = contentHeight * (2 / 3)
        let photoWidth = (collectionView?.bounds.width ?? 0) * (2 / 3)
        let frame = CGRect(x: 0, y: 0, width: photoWidth, height: photoHeight)
        return frame.insetBy(dx: cellPadding, dy: cellPadding)
    }

    private func frameForPrimaryCell(item: Int) -> CGRect {
        let rowHeight = (contentHeight / 3)
        let width = (collectionView?.bounds.width ?? 0) / 3

        let x = item == 1 ? 0 : width
        let y = (rowHeight * 2)

        let frame = CGRect(x: x, y: y, width: width, height: rowHeight)

        return frame.insetBy(dx: cellPadding, dy: cellPadding)
    }

    private func frameForSecondaryCell(rowIndex: Int) -> CGRect {
        let rowHeight = contentHeight / CGFloat(numberOfRows)
        let width = (collectionView?.bounds.width ?? 0) / CGFloat(numberOfRows)
        let frame = CGRect(x: xOffset[rowIndex], y: yOffset[rowIndex], width: width, height: rowHeight)
        return frame.insetBy(dx: cellPadding, dy: cellPadding)
    }

    private func updateXOffet() {
        for row in 0 ..< numberOfRows {
            xOffset[row] = xOffset[row] + contentWidth
        }
    }
}
