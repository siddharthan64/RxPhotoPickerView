//
//  SelectionModel.swift
//  RxPhotoPickerView
//
//  Created by Siddharthan Asokan on 3/18/18.
//  Copyright © 2018 sid. All rights reserved.
//

import Foundation
import UIKit

public struct SelectionModel {
    var image: UIImage?
    var isSelected: Bool = false
    var imageIndex: Int?
    var representedAssetIdentifier: String?
}
