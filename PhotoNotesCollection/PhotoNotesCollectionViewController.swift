//
//  PhotoNotesCollection.swift
//  Notes
//
//  Created by Илья Бочков  on 2/19/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotoNotesCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    let photoNotebook: PhotoNotebook = PhotoNotebook()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "PhotoNotesCollectionCell", bundle: nil),
                                forCellWithReuseIdentifier: "PhotoNotesCollectionCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addPhoto))
        title = "Photo Notes"
        collectionView.backgroundColor = .white
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let newPhoto = info[.editedImage] as? UIImage {
            photoNotebook.addPhoto(photo: newPhoto)
        }
        dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = (view.frame.width - 20) / 3
        return CGSize(width: cellSize, height: cellSize)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    @objc func addPhoto() {
        let alert = UIAlertController(title: nil, message: "Add photo", preferredStyle: .actionSheet)
        let galleryButton = UIAlertAction(title: "Galery", style: .default, handler: { [weak self] _ in
            self?.addPhotoViewController()
        })
        let cameraButton = UIAlertAction(title: "Take photo", style: .default, handler: { [weak self] _ in
            self?.addCameraViewController()
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(galleryButton)
        alert.addAction(cameraButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    private func addPhotoViewController() {
        let photoViewController = UIImagePickerController()
        photoViewController.sourceType = .photoLibrary
        photoViewController.allowsEditing = true
        photoViewController.delegate = self
        present(photoViewController, animated: true)
    }
    
    private func addCameraViewController() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraViewController = UIImagePickerController()
            cameraViewController.sourceType = .camera
            cameraViewController.allowsEditing = true
            cameraViewController.delegate = self
            present(cameraViewController, animated: true)
        } else {
            showNoCameraAlert()
        }
    }
    private func showNoCameraAlert() {
        let alertViewController = UIAlertController(title: "No Camera", message: "Sorry, this device hasn't got camera", preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style:.default))
        present(alertViewController, animated: true)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoNotebook.photes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoNotesCollectionCell", for: indexPath) as! PhotoNotesCollectionCell
        cell.showData(image: photoNotebook.photes[indexPath.row])
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoPagesVC = PhotoPagesViewController(photoNotebook: photoNotebook, entryPhotoIndex: indexPath.row)
        navigationController?.pushViewController(photoPagesVC, animated: true)
    }
}
