//
//  SampleLayout1.swift
//  RxImagePicker
//
//  Created by Siddharthan Asokan on 3/10/18.
//  Copyright © 2018 sid. All rights reserved.
//

import UIKit

private let kReducedHeightColumnIndex = 1
private let kItemHeightAspect: CGFloat = 2

class SampleLayout1: RxCollectionViewLayout {
    private var _itemSize: CGSize!
    private var _columnsXoffset: [CGFloat]!

    override init() {
        super.init()
        totalColumns = 3
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var description: String {
        return "Layout v1"
    }

    override func columnIndexForItemAt(indexPath: IndexPath) -> Int {
        let columnIndex = indexPath.item % totalColumns
        return isLastItemSingleInRow(indexPath) ? kReducedHeightColumnIndex : columnIndex
    }

    override func calculateItemFrame(indexPath: IndexPath, columnIndex: Int, columnYoffset: CGFloat) -> CGRect {
        let rowIndex = indexPath.item / totalColumns
        let halfItemHeight = (_itemSize.height - interItemsSpacing) / 2

        var itemHeight = _itemSize.height

        if (rowIndex == 0 && columnIndex == kReducedHeightColumnIndex) || isLastItemSingleInRow(indexPath) {
            itemHeight = halfItemHeight
        }

        return CGRect(x: _columnsXoffset[columnIndex], y: columnYoffset, width: _itemSize.width, height: itemHeight)
    }

    override func calculateItemsSize() {
        let contentWidthWithoutIndents = collectionView!.bounds.width - contentInsets.left - contentInsets.right
        let itemWidth = (contentWidthWithoutIndents - (CGFloat(totalColumns) - 1) * interItemsSpacing) / CGFloat(totalColumns)
        let itemHeight = itemWidth * kItemHeightAspect

        _itemSize = CGSize(width: itemWidth, height: itemHeight)

        _columnsXoffset = []

        for columnIndex in 0 ... (totalColumns - 1) {
            _columnsXoffset.append(CGFloat(columnIndex) * (_itemSize.width + interItemsSpacing))
        }
    }

    private func isLastItemSingleInRow(_ indexPath: IndexPath) -> Bool {
        return indexPath.item == (totalItemsInSection - 1) && indexPath.item % totalColumns == 0
    }
}
