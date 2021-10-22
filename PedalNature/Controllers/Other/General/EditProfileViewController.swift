//
//  EditProfileViewController.swift
//  PedalNature
//
//  Created by Volkan on 24.09.2021.
//

import UIKit

/// For user to Edit Profile Info
final class EditProfileViewController: UIViewController {

    private let tableView : UITableView = {
        let tableview = UITableView()
        tableview.register(EditProfileFormTableViewCell.self, forCellReuseIdentifier: EditProfileFormTableViewCell.identifier)
        return tableview
    }()
    
    private var profileFormModal = [EditProfileFormModal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModals()
        title = "Edit Profile"
        view.backgroundColor = .systemBackground
        tableView.tableHeaderView = createTableHeaderView()
        view.addSubview(tableView)
        tableView.dataSource = self
        configureEditProfileNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    public func configureEditProfileNavigationBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSaveButton))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapCancelButton))
    }
    
    private func configureModals(){
        // Name, Username, Bicycle, Bio
        let profileSections = ["Name", "Username", "Bicycle", "Bio"]
        
        for profileSection in profileSections{
            
            if profileSection == "Bicycle"{
                let modal = EditProfileFormModal(label: profileSection,
                                                 placeHolder: "Enter \(profileSection) modal", value: nil)
                profileFormModal.append(modal)
            }else{
                let modal = EditProfileFormModal(label: profileSection,
                                                 placeHolder: "Enter \(profileSection)", value: nil)
                profileFormModal.append(modal)
            }
        }
        
    }
    
    private func createTableHeaderView() -> UIView{
        let header = UIView(frame: CGRect(x: 0, y: 0,
                                          width: view.width, height: view.height/4).integral)
        let size = header.height/1.5
        let profilePhotoButton = UIButton(frame: CGRect(x: (view.width - size)/2,
                                                        y: (header.height - size)/2,
                                                        width: size,
                                                        height: size))
        header.addSubview(profilePhotoButton)
        profilePhotoButton.layer.masksToBounds = true
        profilePhotoButton.layer.cornerRadius = size/2.0
        profilePhotoButton.addTarget(self,
                                     action: #selector(didTapProfilePhotoButton),
                                     for: .touchUpInside)
        profilePhotoButton.tintColor = .label
        profilePhotoButton.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
        profilePhotoButton.layer.borderWidth = 1.0
        profilePhotoButton.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        return header
    }
    
    @objc private func didTapProfilePhotoButton(){
        
    }
    
    @objc private func didTapSaveButton(){
        dismiss(animated: true)
        
    }
    
    @objc private func didTapCancelButton(){
        dismiss(animated: true)
    }
    
    @objc private func didTapChangeProfilePictureButton(){
        let actionSheet = UIAlertController(title: "Profile picture",
                                            message: "Change Profile Picture",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default, handler: { _ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose from Library",
                                            style: .default, handler: { _ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel, handler: nil))
        
        actionSheet.popoverPresentationController?.sourceRect = view.bounds
        actionSheet.popoverPresentationController?.sourceView = view
        present(actionSheet, animated: true, completion: nil)

    }

}

extension EditProfileViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileFormModal.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let modal = profileFormModal[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileFormTableViewCell.identifier, for: indexPath) as! EditProfileFormTableViewCell
        cell.configure(with: modal)
        cell.delegate = self
        return cell
    }
    
    
}

extension EditProfileViewController: EditProfileFormTableViewDelegate{
    func formTableViewCell(_ cell: EditProfileFormTableViewCell, didUpdateField updatedModel: EditProfileFormModal) {
        print(updatedModel.label)

        print(updatedModel.value ?? "nil")
    }
    
    
}
