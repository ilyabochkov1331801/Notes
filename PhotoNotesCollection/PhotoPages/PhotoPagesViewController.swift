//
//  PhotoPagesViewController.swift
//  Notes
//
//  Created by Илья Бочков  on 2/22/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class PhotoPagesViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var photoNotebookControllers: Array<PhotoPageViewController>
    
    init(photoNotebook: PhotoNotebook, entryPhotoIndex: Int) {
        photoNotebookControllers = Array<PhotoPageViewController>()
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal,
                   options: nil)
        for (indexInControllersArray, photo) in photoNotebook.photes.enumerated() {
            photoNotebookControllers.append(PhotoPageViewController(photo: photo,
                                                                    index: indexInControllersArray))
        }
        setViewControllers([photoNotebookControllers[entryPhotoIndex]],
                           direction: .forward,
                           animated: true,
                           completion: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let photoPageVC = viewController as? PhotoPageViewController,
            photoPageVC.indexOfPage > 0 else { return nil }
        return photoNotebookControllers[photoPageVC.indexOfPage - 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let photoPageVC = viewController as? PhotoPageViewController,
            photoPageVC.indexOfPage < photoNotebookControllers.count - 1 else { return nil }
        return photoNotebookControllers[photoPageVC.indexOfPage + 1]
    }
}
