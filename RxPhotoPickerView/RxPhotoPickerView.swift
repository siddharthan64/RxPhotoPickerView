//
//  RxPhotoPickerView.swift
//  RxImagePicker
//
//  Created by Siddharthan Asokan on 3/10/18.
//  Copyright © 2018 sid. All rights reserved.
//

import RxSwift
import UIKit

@IBDesignable class RxPhotoPickerView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var layoutConfiguration: CustomLayoutConfiguration = DefaultConfiguration()

    @IBInspectable var isHorizontal: Bool {
        get {
            return layoutConfiguration.isHorizontal
        }

        set {
            layoutConfiguration.isHorizontal = newValue
        }
    }

    @IBInspectable var numberOfSegments: Int {
        get {
            return layoutConfiguration.numberOfSegments
        }

        set {
            layoutConfiguration.numberOfSegments = newValue
        }
    }

    @IBInspectable var numberOfImages: Int {
        get {
            return layoutConfiguration.numberOfImages
        }

        set {
            layoutConfiguration.numberOfImages = newValue
        }
    }

    public convenience init(layoutConfiguration: CustomLayoutConfiguration = DefaultConfiguration()) {
        self.init(frame: .zero)
        self.layoutConfiguration = layoutConfiguration
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(rxCollectionView)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(rxCollectionView)
        setUp()
    }

    func setUp() {
        NSLayoutConstraint.activate([
            rxCollectionView.topAnchor.constraint(equalTo: topAnchor),
            rxCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rxCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            rxCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    private let cellSelectionSubject: PublishSubject<IndexPath> = PublishSubject<IndexPath>()

    public var cellSelectionObservable: Observable<IndexPath> {
        return cellSelectionSubject.asObservable()
    }

    lazy var rxCollectionView: RxCollectionView = {
        var layout: UICollectionViewLayout = UICollectionViewLayout()

        if layoutConfiguration.isHorizontal {
            layout = RxCollectionViewHLayout(numberOfRows: layoutConfiguration.numberOfSegments)
        } else {
            layout = RxCollectionViewVLayout(numberofColumns: layoutConfiguration.numberOfSegments)
        }

        let cV = RxCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cV.backgroundColor = UIColor.white
        cV.showsVerticalScrollIndicator = false
        cV.showsHorizontalScrollIndicator = false
        cV.translatesAutoresizingMaskIntoConstraints = false
        cV.dataSource = self
        cV.delegate = self
        cV.register(RxCollectionViewCell.self, forCellWithReuseIdentifier: RxCollectionViewCell.cellIdentifier)
        return cV
    }()

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return numberOfImages
    }

    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RxCollectionViewCell.cellIdentifier, for: indexPath) as? RxCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(UIImage(named: "corgi"))
        cell.updateText(index: indexPath.row)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = collectionView.dequeueReusableCell(withReuseIdentifier: RxCollectionViewCell.cellIdentifier, for: indexPath) as? RxCollectionViewCell {
            cellSelectionSubject.onNext(indexPath)
        }
    }
}
