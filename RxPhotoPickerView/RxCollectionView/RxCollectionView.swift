//
//  RxCollectionView.swift
//  RxImagePicker
//
//  Created by Siddharthan Asokan on 3/10/18.
//  Copyright © 2018 sid. All rights reserved.
//

import UIKit

class RxCollectionView: UICollectionView {
    var layout: UICollectionViewLayout

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        self.layout = layout
        super.init(frame: frame, collectionViewLayout: layout)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
