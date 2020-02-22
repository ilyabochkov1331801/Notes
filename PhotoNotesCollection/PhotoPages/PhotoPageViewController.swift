//
//  PhotoPageViewController.swift
//  Notes
//
//  Created by Илья Бочков  on 2/22/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class PhotoPageViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let index: Int
    let photoImage: UIImage
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    init(photo: UIImage, index: Int) {
        self.index = index
        photoImage = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImageView.image = photoImage
        view.backgroundColor = .black
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        swipeUp.delegate = self
        swipeUp.direction =  UISwipeGestureRecognizer.Direction.up
        view.addGestureRecognizer(swipeUp)
    }
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
