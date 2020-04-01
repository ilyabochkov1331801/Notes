//
//  ConteinerViewController.swift
//  Notes
//
//  Created by Илья Бочков  on 3/9/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    var navigationControllerForNotes: UINavigationController!
    var menuViewController: LeftMenuViewController!
    var isMenuHide = true

    override func viewDidLoad() {
        super.viewDidLoad()
        configureteNotesTableViewCOntroller()
    }
    
    func configureteNotesTableViewCOntroller() {
        let notesTable = NotesTableViewController()
        notesTable.delegate = self
        navigationControllerForNotes = UINavigationController(rootViewController: notesTable)
        view.addSubview(navigationControllerForNotes.view)
        addChild(navigationControllerForNotes)
    }

    func configureteMenuViewController() {
        if menuViewController == nil {
            menuViewController = LeftMenuViewController()
            menuViewController.view.frame = UIScreen.main.bounds
            menuViewController.delegate = self
            if let noteTableViewController = navigationControllerForNotes.viewControllers.first as? UpdateDataDelegate {
                menuViewController.updateDataDelegate = noteTableViewController
            }
            view.insertSubview(menuViewController.view, at: 0)
            addChild(menuViewController)
        }
    }
    func showMenuViewController() {
        if isMenuHide {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 8,
                           options: .curveEaseInOut,
                           animations: {
                            self.navigationControllerForNotes.view.frame.origin.x = self.navigationControllerForNotes.view.frame.width
            }, completion: { [weak self] (finished) in
                self?.navigationControllerForNotes.view.isUserInteractionEnabled = false
            })
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 8,
                           options: .curveEaseInOut,
                           animations: {
                            self.navigationControllerForNotes.view.frame.origin.x = .zero
                            
            }, completion: { [weak self] (finished) in
                self?.navigationControllerForNotes.view.isUserInteractionEnabled = true
            })
        }
        isMenuHide = !isMenuHide
    }
}

extension MainScreenViewController: LeftMenuDelegate {
    func toggleMenu() {
        configureteMenuViewController()
        showMenuViewController()
    }
}
