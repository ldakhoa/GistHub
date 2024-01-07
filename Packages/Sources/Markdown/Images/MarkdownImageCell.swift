//
//  MarkdownImageCell.swift
//  GistHub
//
//  Created by Khoa Le on 05/01/2023.
//

import UIKit
import Kingfisher
import DesignSystem

protocol MarkdownImageCellDelegate: AnyObject {
    func didTapImage(image: UIImage, animatedImageData: Data?)
}

protocol MarkdownImageHeightCellDelegate: AnyObject {
    func imageDidFinishLoad(url: URL, size: CGSize)
}

final class MarkdownImageCell: UICollectionViewCell {
    static let identifier = "MarkdownImageCell"

    static let bottomInset = MarkdownSizes.rowSpacing

    weak var delegate: MarkdownImageCellDelegate?
    weak var heightDelegate: MarkdownImageHeightCellDelegate?

    let imageView = AnimatedImageView()

    private lazy var spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()

    private var tapGesture: UITapGestureRecognizer!

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityIgnoresInvertColors = true

        contentView.addSubview(imageView)
        contentView.addSubview(spinner)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        contentView.addGestureRecognizer(tapGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        var frame = contentView.bounds
        frame.size.height -= MarkdownImageCell.bottomInset

        if let size = imageView.image?.size {
            frame.size = BoundedImageSize(originalSize: size, containerWidth: frame.width)
        }

        imageView.frame = frame
    }

    func configure(with model: MarkdownImageModel) {
        imageView.image = nil
        imageView.backgroundColor = Colors.MarkdownColorStyle.background

        spinner.startAnimating()

        let imageURL = model.url

        imageView.kf.setImage(with: imageURL) { [weak self] result in
            assert(Thread.isMainThread, "Main thread")
            guard let self = self else { return }

            self.imageView.backgroundColor = .clear
            self.spinner.stopAnimating()

            switch result {
            case let .success(value):
                let size = value.image.size
                self.heightDelegate?.imageDidFinishLoad(url: imageURL, size: size)
                self.setNeedsLayout()

            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

    @objc
    private func onTap(recognizer: UITapGestureRecognizer) {
        // action will only trigger if shouldBegin returns true
        guard let image = imageView.image else { return }

//        if let animatedImage = imageView.animatedImage {
//            delegate?.didTapImage(image: image, animatedImageData: animatedImage.data)
//        } else {

        delegate?.didTapImage(image: image, animatedImageData: nil)
//        }
    }
}
