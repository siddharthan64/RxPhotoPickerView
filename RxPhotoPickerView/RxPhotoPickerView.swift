//
//  RxPhotoPickerView.swift
//  RxImagePicker
//
//  Created by Siddharthan Asokan on 3/10/18.
//  Copyright © 2018 sid. All rights reserved.
//

import Photos
import RxSwift
import UIKit

@IBDesignable class RxPhotoPickerView: UIView, UICollectionViewDataSource, UICollectionViewDelegate,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var layoutConfiguration: CustomLayoutConfiguration = DefaultConfiguration()

    var imagePicker: UIImagePickerController?

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

        if let imageIndexModel = self.layoutConfiguration.imagesModels.filter({ ($0.index - 1) == indexPath.row }).first {
            cell.configure(image: imageIndexModel.image)
        } else {
            cell.updateText(index: indexPath.row + 1)
        }

        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let count = layoutConfiguration.imagesModels.count
        if count == 0 || indexPath.item > (count - 1) {
            showAlertControllerWithNoImage()
        } else {
            showAlertControllerWithImage(indexPath)
        }
    }

    private var hasImages: Bool {
        return layoutConfiguration.imagesModels.count > 0
    }

    private func getSelectionModels() -> [SelectionModel] {
        return layoutConfiguration.imagesModels.map({ (model) -> SelectionModel in
            SelectionModel(image: model.image, isSelected: true, imageIndex: model.index, representedAssetIdentifier: model.assetIdentifier)
        })
    }

    private func subscribeTo(_ selectionModelObservable: Observable<[SelectionModel]>) {
        selectionModelObservable.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] selectionModels in

            guard let `self` = self else {
                return
            }

            let imageModels = selectionModels.map({ (selectionModel) -> ImageIndexModel in
                guard let imageIndex = selectionModel.imageIndex, let image = selectionModel.image else {
                    return ImageIndexModel()
                }

                return ImageIndexModel(index: imageIndex, image: image, assetIdentifier: selectionModel.representedAssetIdentifier)
            })

            self.layoutConfiguration.imagesModels = imageModels
            self.rxCollectionView.reloadData()
        }).disposed(by: disposeBag)
    }

    private func showAlertControllerWithImage(_ indexPath: IndexPath) {
        let removeAction = UIAlertAction(title: "Remove Image", style: .default) { _ in
            self.removeImage(indexPath)
        }
        let updateImageAction = UIAlertAction(title: "Update Images", style: .default, handler: loadFromLibrary)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        controller.addAction(removeAction)
        controller.addAction(updateImageAction)
        controller.addAction(cancelAction)

        UIApplication.topViewController()?.present(controller, animated: true)
    }

    // Actions when there are images on the tapped cell
    private func removeImage(_ indexPath: IndexPath) {
        guard indexPath.item <= layoutConfiguration.imagesModels.count - 1 else {
            return
        }

        for i in indexPath.item ..< layoutConfiguration.imagesModels.count {
            layoutConfiguration.imagesModels[i].index = i
        }

        layoutConfiguration.imagesModels.remove(at: indexPath.item)
        rxCollectionView.reloadData()
    }

    private func showAlertControllerWithNoImage() {
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: captureImage)
        let loadFromLibraryAction = UIAlertAction(title: "Load from library", style: .default, handler: loadFromLibrary)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        controller.addAction(cameraAction)
        controller.addAction(loadFromLibraryAction)
        controller.addAction(cancelAction)

        UIApplication.topViewController()?.present(controller, animated: true)
    }

    private func captureImage(action _: UIAlertAction) {
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.sourceType = .camera
        if let picker = imagePicker {
            UIApplication.topViewController()?.present(picker, animated: true, completion: nil)
        }
    }

    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        imagePicker?.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        imagePicker?.dismiss(animated: true, completion: nil)
        if let imageToSave = info[UIImagePickerControllerOriginalImage] as? UIImage {
            UIImageWriteToSavedPhotosAlbum(imageToSave, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo _: UnsafeRawPointer) {
        if let error = error {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            UIApplication.topViewController()?.present(alert, animated: true)
        } else {
            let fetchResult = fetchLatestPhotos(forCount: 1)
            if fetchResult.count > 0 {
                let asset = fetchResult.object(at: 0)
                let imageModel = ImageIndexModel(index: layoutConfiguration.imagesModels.count + 1, image: image, assetIdentifier: asset.localIdentifier)
                layoutConfiguration.imagesModels.append(imageModel)
                rxCollectionView.reloadData()
            }
        }
    }

    private func fetchLatestPhotos(forCount count: Int?) -> PHFetchResult<PHAsset> {
        // Create fetch options.
        let options = PHFetchOptions()

        // If count limit is specified.
        if let count = count { options.fetchLimit = count }

        // Add sortDescriptor so the lastest photos will be returned.
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        options.sortDescriptors = [sortDescriptor]

        // Fetch the photos.
        return PHAsset.fetchAssets(with: .image, options: options)
    }

    private func loadFromLibrary(action _: UIAlertAction) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let photoVC = AssetGridViewController(collectionViewLayout: UICollectionViewFlowLayout())
        subscribeTo(photoVC.modelObservable)

        if hasImages {
            photoVC.reEntryModelIndexes = getSelectionModels()
        }

        photoVC.imageCount = numberOfImages
        let navVC = UINavigationController(rootViewController: photoVC)
        UIApplication.topViewController()?.present(navVC, animated: true)
    }

    private let disposeBag = DisposeBag()
}

extension UIApplication {
    static func topViewController() -> UIViewController? {
        guard var top = shared.keyWindow?.rootViewController else {
            return nil
        }
        while let next = top.presentedViewController {
            top = next
        }
        return top
    }
}
