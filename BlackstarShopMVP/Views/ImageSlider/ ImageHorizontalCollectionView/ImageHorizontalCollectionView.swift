//
//  ImageHorizontalCollectionView.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 06.02.2022.
//

import UIKit
import SkeletonView

class ImageHorizontalCollectionView: UIView {

    // MARK: Outlets

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!

    // MARK: Properties

    private let skeletonView = UIView()

    private var images = [UIImage]()
    private let imagesService: DownloadImagesService = DownloadImagesServiceImpl()

    // MARK: - Object lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // при изменеии размера view в процессе растягивания пересчитываем размер коллекции и ячеек
        collectionView?.collectionViewLayout.invalidateLayout()
    }

}

// MARK: - Public methods

extension ImageHorizontalCollectionView {

    func configure(_ imageUrls: [URL]) {
        guard !imageUrls.isEmpty else { addPlaceholderForEmptyCollection(); return }
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

        pageControl.currentPageIndicatorTintColor = .green

        configureSceletonView()
        showSkeletonLoading()

        // во время растягивания collection view не должен меняться adjustment - это приводит к появлению warning
        collectionView.contentInsetAdjustmentBehavior = .never
    }

    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        guard images.indices.contains(sender.currentPage) else { return }

        let scrollPosition: UICollectionView.ScrollPosition = (focusedCellIndex ?? 0) < sender.currentPage ? .right : .left

        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: true)
    }

    var focusedCellIndex: Int? {
        guard let cell = collectionView.visibleCells.first else { return nil }
        return collectionView.indexPath(for: cell)?.item
    }

    func handleRowImageDataResult(_ result: Result<[Data], NetworkError>) {
        switch result {
        case .success(let imageDataList):
            images = imageDataList.compactMap { UIImage(data: $0) }
            setPageControl(with: images.count)
            hideSkeletonLoading()
            collectionView.reloadData()
        case .failure(let error):
            print("Error image downloading \(error.description())")
        }
    }

    func addPlaceholderForEmptyCollection() {
        images.append(R.image.common.placeholder()!)
        pageControl.isHidden = true
        hideSkeletonLoading()
        collectionView.reloadData()
    }

    func setPageControl(with imagesCount: Int) {
        pageControl.isHidden = imagesCount == 1 ? true : false
        pageControl.numberOfPages = imagesCount
    }

    func configureSceletonView() {
        skeletonView.isSkeletonable = true
        contentView.insertSubview(skeletonView, at: 0)

        skeletonView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            skeletonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            skeletonView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            skeletonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            skeletonView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }

    func showSkeletonLoading() {
        collectionView.isHidden = true

        let gradient = SkeletonGradient(baseColor: UIColor.concrete)
        self.skeletonView.showAnimatedGradientSkeleton(usingGradient: gradient)
    }

    func hideSkeletonLoading() {
        collectionView.isHidden = false

        skeletonView.hideSkeleton()
    }

}

// MARK: - UICollectionViewDataSource

extension ImageHorizontalCollectionView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.imageHorizontalCollectionCell,
                                                      for: indexPath)!
        if let image = images[safeIndex: indexPath.item] {
            cell.configure(image)
        }
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

extension ImageHorizontalCollectionView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerPoint = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.minY)
        let collectionViewCenterPoint = self.convert(centerPoint, to: collectionView)

        if let indexPath = collectionView.indexPathForItem(at: collectionViewCenterPoint) {
            pageControl.currentPage = indexPath.item
        }
    }

}
