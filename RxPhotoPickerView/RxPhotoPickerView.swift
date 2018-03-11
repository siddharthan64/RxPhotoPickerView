//
//  RxPhotoPickerView.swift
//  RxImagePicker
//
//  Created by Siddharthan Asokan on 3/10/18.
//  Copyright © 2018 sid. All rights reserved.
//

import RxSwift
import UIKit

class RxPhotoPickerView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    var imageCount: Int?
    let defaultCount = 6
    
    convenience public init(count:Int, frame: CGRect){
        self.init(frame: frame)
        imageCount = count
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(rxCollectionView)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        let cV = RxCollectionView(frame: CGRect.zero, collectionViewLayout: SampleLayout1())
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
        return imageCount ?? defaultCount
    }

    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RxCollectionViewCell.cellIdentifier, for: indexPath) as? RxCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(UIImage(named: "corgi"))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = collectionView.dequeueReusableCell(withReuseIdentifier: RxCollectionViewCell.cellIdentifier, for: indexPath) as? RxCollectionViewCell {
            cellSelectionSubject.onNext(indexPath)
        }
    }
}
