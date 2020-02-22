//
//  PhotoPagesViewController.swift
//  Notes
//
//  Created by Илья Бочков  on 2/22/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class PhotoPagesViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var photoNotebookControllers: [PhotoPageViewController] = []
    
    init(photoNotebook: PhotoNotebook, entryPhotoIndex: Int) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        for (index, photo) in photoNotebook.photes.enumerated() {
            photoNotebookControllers.append(PhotoPageViewController(photo: photo, index: index))
        }
        setViewControllers([photoNotebookControllers[entryPhotoIndex]], direction: .forward, animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        hidesBottomBarWhenPushed = true
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let photoPageVC = viewController as? PhotoPageViewController, photoPageVC.index > 0 else { return nil }
        return photoNotebookControllers[photoPageVC.index - 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let photoPageVC = viewController as? PhotoPageViewController, photoPageVC.index < photoNotebookControllers.count - 1 else { return nil }
        return photoNotebookControllers[photoPageVC.index + 1]
    }
}
