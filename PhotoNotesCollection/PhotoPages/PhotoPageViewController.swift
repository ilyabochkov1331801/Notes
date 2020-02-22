//
//  PhotoPageViewController.swift
//  Notes
//
//  Created by Илья Бочков  on 2/22/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class PhotoPageViewController: UIViewController, UIGestureRecognizerDelegate {

    private let photoImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let index: Int
    
    init(photo: UIImage, index: Int) {
        self.index = index
        super.init(nibName: nil, bundle: nil)
        photoImage.image = photo
        view.backgroundColor = .black
        view.addSubview(photoImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImage.frame.size = view.frame.size
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        swipeDown.delegate = self
        swipeDown.direction =  UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(swipeDown)
    }
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
}
