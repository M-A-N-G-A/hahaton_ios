//
//  MakePostViewController.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard

final class MakePostViewController: UIViewController {
    
    enum Constants {
        static let imageSize = CGSize(width: 100, height: 100)
        static let postSize = CGSize(width: 48, height: 48)
        static let textHeight: CGFloat = 300
    }
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        // TODO: design
        return textView
    }()
    
    private lazy var imageView = RemovableImageView()
    
    private lazy var postBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "paperplane")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = UIColor.systemBlue
        btn.layer.cornerRadius = Constants.postSize.width / 2
        btn.layer.backgroundColor = UIColor.white.cgColor
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.systemBlue.cgColor
        return btn
    }()
    
    var viewModel: MakePostViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        makeSubviewsLayout()
        setupBindings()
    }
    
}

// MARK: - Setup UI
private extension MakePostViewController {
    func setupUI() {
        view.backgroundColor = .white
        view.add(subviews: textView, imageView, postBtn)
    }
    
    func makeSubviewsLayout() {
        textView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(Constants.textHeight)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.size.equalTo(Constants.imageSize)
        }
        postBtn.snp.makeConstraints { make in
            make.size.equalTo(Constants.postSize)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Setup Bindings
private extension MakePostViewController {
    func setupBindings() {
        guard let viewModel = viewModel else { return }
        
        let input = MakePostViewModel.Input(
            message: textView.rx.text.asDriver(),
            imageState: imageView.imageStateSubject.asDriverOnErrorJustComplete(),
            postTap: postBtn.rx.tap.asDriver(),
            imageTap: imageView.imageView.rx.tapGesture().when(.recognized).mapToVoid().asDriverOnErrorJustComplete(),
            deleteTap: imageView.crossBtn.rx.tap.asDriver()
        )
        
        let output = viewModel.transform(input: input)
        
        RxKeyboard.instance.visibleHeight
            .drive(postBtnKeyboardBinder)
            .disposed(by: disposeBag)
        
        [
            output.image.drive(imageView.stateBinder),
            
            output.success.drive(successBinder),
            output.error.drive(errorBinder)
        ]
        .forEach { $0.disposed(by: disposeBag) }
    }
}

// MARK: - TabBarControllerProtocol
extension MakePostViewController: TabBarControllerProtocol {
    var tabBarTitle: String {
        "Add"
    }
    
    var tabBarIcon: UIImage? {
        UIImage(systemName: "plus.message.fill")
    }
    
    func setupTabBarSettings() {
        self.title = tabBarTitle
    }
}

// MARK: - Rx Binders
extension MakePostViewController {
    var postBtnKeyboardBinder: Binder<CGFloat> {
        Binder(self) { view, height in
            UIView.animate(withDuration: 0.3) {
                view.postBtn.snp.updateConstraints { update in
                    let tabBarHeight: CGFloat = self.tabBarController?.tabBar.frame.size.height ?? 0
                    update.bottom.equalTo(view.view.safeAreaLayoutGuide).inset(height == 0 ? height + 16 : height - tabBarHeight + 16)
                }
            }
        }
    }
}
