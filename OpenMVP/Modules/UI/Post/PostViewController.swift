//
//  PostViewController.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 28.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class PostViewController: UIViewController {
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var actionsView: UIView!
    @IBOutlet weak var likesView: UIView!
    
    var _profileView = ProfileRowView()
    var _actionsView = ProfileActionsView()
    var _likesView = PostLikesView()
    
    private let disposeBag = DisposeBag()
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileView.addAndFill(_profileView)
        actionsView.addAndFill(_actionsView)
        likesView.addAndFill(_likesView)
        
        setupUI()
        makeSubviewsLayout()
        setupBindings()
//        _profileView.imageView.image = UIColor.systemBlue.image()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let post = post else { return }
        setup(post)
    }
    
    func setup(_ post: Post) {
        
        if let profileImage = post.user?.imageFile {
            Api()._requestImage(by: profileImage) { result in
                switch result {
                case let .success(image):
                    DispatchQueue.main.sync {
                        self._profileView.imageView.image = image
                    }
                case let .failure(error):
                    Log.debug(error)
                    Log.debug("nothing doing")
                }
            }
        }
        
        _profileView.nameLabel.text = post.user?.userName ?? "Nope name"
        messageLabel.text = post.content
        
        guard let imageName = post.media else { return }
        Api()._requestImage(by: imageName) { result in
            switch result {
            case let .success(image):
                DispatchQueue.main.sync {
                    self.imageView.image = image
                }
            case let .failure(error):
                Log.debug(error)
                Log.debug("nothing doing")
            }
        }
    }
    
}

// MARK: - Setup UI
private extension PostViewController {
    func setupUI() {
        
    }
    
    func makeSubviewsLayout() {
        
    }
}

// MARK: - Setup Bindings
private extension PostViewController {
    func setupBindings() {
        
    }
}
