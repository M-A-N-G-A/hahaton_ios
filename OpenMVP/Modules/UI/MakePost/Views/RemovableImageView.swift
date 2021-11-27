//
//  RemovableImageView.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

/// rx: `imageSubject`
final class RemovableImageView: UIView {
    
    enum State {
        case imageSelected(UIImage)
        case blank
    }
    
    enum Constants {
        static let crossBtnSize = CGSize(width: 32, height: 32)
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "AddImageIcon")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.systemBlue
        return imageView
    }()
    
    lazy var crossBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "trash.slash")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.tintColor = .systemRed
        btn.layer.backgroundColor = UIColor.white.cgColor
        btn.layer.cornerRadius = Constants.crossBtnSize.width / 2
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.systemRed.cgColor
        return btn
    }()
    
    let imageStateSubject = PublishSubject<State>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        makeSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension RemovableImageView {
    func setupUI() {
        [
            imageView,
            crossBtn
        ]
        .forEach { addSubview($0) }
    }
    
    func makeSubviewsLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        crossBtn.snp.makeConstraints { make in
            make.right.equalTo(imageView).inset(16)
            make.top.equalToSuperview().inset(-8)
            make.size.equalTo(Constants.crossBtnSize)
        }
    }
}

// MARK: - Rx Binders
extension RemovableImageView {
    var stateBinder: Binder<State> {
        Binder(self) { view, state in
            view.imageStateSubject.on(.next(state))
            switch state {
            case let .imageSelected(image):
                view.imageView.image = image
                view.crossBtn.alpha = 1
                view.crossBtn.isHidden = false
            case .blank:
                view.imageView.image = UIImage(named: "AddImageIcon")?.withRenderingMode(.alwaysTemplate)
                view.crossBtn.alpha = 0
                view.crossBtn.isHidden = true
            }
        }
    }
}
