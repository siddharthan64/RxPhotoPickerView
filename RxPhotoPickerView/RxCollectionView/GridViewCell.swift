//
//  GridViewCell.swift
//  RxPhotoPickerView
//
//  Created by Siddharthan Asokan on 3/18/18.
//  Copyright © 2018 sid. All rights reserved.
//

import UIKit

class GridViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var indexLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUp()
    }
    
    private func setUp(){
//        selectionView.isHidden = true
        selectionView.layer.cornerRadius = 15
    }
    
    
    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImage = nil
        selectionView.isHidden = true
    }
    
    func configureCell(_ model: SelectionModel) {
        thumbnailImage = model.image
        selectionView.isHidden = !model.isSelected
        if let index = model.imageIndex, model.isSelected {
            indexLabel.text = "\(index)"
        }
    }
}

