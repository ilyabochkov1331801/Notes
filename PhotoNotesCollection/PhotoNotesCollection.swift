//
//  PhotoNotesCollection.swift
//  Notes
//
//  Created by Илья Бочков  on 2/19/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotoNotesCollection: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    let photoNotebook: PhotoNotebook = PhotoNotebook()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "PhotoNotesCollectionCell",
                                      bundle: nil),
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
        let photoPickerViewController = UIImagePickerController()
        photoPickerViewController.delegate = self
        photoPickerViewController.allowsEditing = true
        photoPickerViewController.mediaTypes = ["public.image"]
        photoPickerViewController.sourceType = .photoLibrary
        present(photoPickerViewController, animated: true, completion: nil)
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
