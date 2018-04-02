//
//  RxCollectionViewVLayout.swift
//  RxPhotoPickerView
//
//  Created by Siddharthan Asokan on 3/17/18.
//  Copyright © 2018 sid. All rights reserved.
//

import UIKit

class RxCollectionViewVLayout: UICollectionViewLayout {
    let numberOfColumns: Int

    init(numberofColumns: Int) {
        numberOfColumns = numberofColumns
        super.init()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate var cellPadding: CGFloat = 6

    var scrollDirection: UICollectionViewScrollDirection = .vertical

    fileprivate var xOffset = [CGFloat]()
    fileprivate var yOffset = [CGFloat]()

    fileprivate var cache = [UICollectionViewLayoutAttributes]()

    fileprivate var contentHeight: CGFloat = 0

    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        let columnWidth = contentWidth / CGFloat(numberOfColumns)

        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }

        var column = 0
        yOffset = [CGFloat](repeating: 0, count: numberOfColumns)

        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            var attributes: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes()

            switch item {
            case 0:
                attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frameForMainCell()

                contentHeight = max(contentHeight, attributes.frame.maxY)

                updateYOffet()
            case 1, 2:
                attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frameForPrimaryCell(item: item)

            default:
                attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                let columnIndex = (abs(item - 3)) % numberOfColumns

                attributes.frame = frameForSecondaryCell(colIndex: columnIndex)

                contentHeight = max(contentHeight, attributes.frame.maxY)

                let height = cellPadding + attributes.frame.size.height

                yOffset[columnIndex] = yOffset[columnIndex] + height
            }
            cache.append(attributes)

            column = column < (numberOfColumns - 1) ? (column + 1) : 0
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
        let photoWidth = contentWidth * (2 / 3)
        let photoHeight = (collectionView?.bounds.height ?? 0) * (2 / 3)
        let frame = CGRect(x: 0, y: 0, width: photoWidth, height: photoHeight)
        return frame.insetBy(dx: cellPadding, dy: cellPadding)
    }

    private func frameForPrimaryCell(item: Int) -> CGRect {
        let columnWidth = (contentWidth / 3)
        let height = (collectionView?.bounds.height ?? 0) / 3

        let x = (columnWidth * 2)
        let y = item == 1 ? 0 : height

        let frame = CGRect(x: x, y: y, width: columnWidth, height: height)

        return frame.insetBy(dx: cellPadding, dy: cellPadding)
    }

    private func frameForSecondaryCell(colIndex: Int) -> CGRect {
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        let height = (collectionView?.bounds.height ?? 0) / CGFloat(numberOfColumns)
        let frame = CGRect(x: xOffset[colIndex], y: yOffset[colIndex], width: columnWidth, height: height)
        return frame.insetBy(dx: cellPadding, dy: cellPadding)
    }

    private func updateYOffet() {
        for column in 0 ..< numberOfColumns {
            yOffset[column] = yOffset[column] + contentHeight
        }
    }
}
