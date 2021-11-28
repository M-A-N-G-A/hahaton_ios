//
//  StockCell.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class StockCell: UICollectionViewCell {
    
    enum Constants {
        static let iconSize = CGSize(width: 48, height: 48)
    }
    
    private lazy var containerView = UIView()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        // TODO: font and color
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        // TODO: font and color
        return label
    }()
    
    var viewModel: StockCellViewModel?
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        makeSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

// MARK: - Setup UI
private extension StockCell {
    func setupUI() {
        layer.masksToBounds = true
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemBlue.cgColor // TODO: open color
        
        addSubview(containerView)
        
        [
            imageView,
            titleLabel,
            valueLabel
        ]
        .forEach { containerView.addSubview($0) }
    }
    
    func makeSubviewsLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - HomeViewController.Constants.horizontalInsets)
        }
        imageView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(8)
            make.size.equalTo(Constants.iconSize)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(8)
            make.centerY.equalToSuperview()
        }
        valueLabel.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(8)
        }
    }
}

// MARK: - Setup Bindings
extension StockCell {
    func configure(with factory: @escaping (StockCellViewModel.Input) -> StockCellViewModel) {
        let input = StockCellViewModel.Input()
        
        let viewModel = factory(input)
        
        let output = viewModel.transform(input: input)
        
        [
            output.icon.drive(imageView.rx.image),
            output.title.drive(titleLabel.rx.text),
            output.value.drive(valueLabel.rx.text)
        ]
        .forEach { $0.disposed(by: disposeBag) }
    }
}
