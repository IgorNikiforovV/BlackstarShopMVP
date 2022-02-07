//
//  ImageHorizontalCollectionView.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 06.02.2022.
//

import UIKit

class ImageHorizontalCollectionView: UIView {

    // MARK: Outlets

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: Properties

    private var images = [UIImage]()
    private let imagesService: DownloadImagesService = DownloadImagesServiceImpl()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

}

// MARK: - Public methods

extension ImageHorizontalCollectionView {

    func configure(_ imageUrls: [URL]) {
        guard !imageUrls.isEmpty else { return }
        imagesService.downloadImages(by: imageUrls) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleRowImageDataResult(result)
            }
        }
    }

}

// MARK: - Private methods

private extension ImageHorizontalCollectionView {

    func initialize() {
        _ = R.nib.imageHorizontalCollectionView(owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor)
        ])
        collectionView.register(R.nib.imageHorizontalCollectionCell)
    }

    func handleRowImageDataResult(_ result: Result<[Data], NetworkError>) {
        switch result {
        case .success(let imageDataList):
            images = imageDataList.compactMap { UIImage(data: $0) }
            collectionView.reloadData()
        case .failure(let error):
            print("Error image downloading \(error.description())")
        }
    }

}

// MARK: - UICollectionViewDataSource

extension ImageHorizontalCollectionView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: R.reuseIdentifier.imageHorizontalCollectionCell ,
            for: indexPath
        )!
        let image = images[indexPath.item]
        cell.configure(image)
        return cell
    }

}

// MARK: - UICollectionViewFlowLayout

extension ImageHorizontalCollectionView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

}
