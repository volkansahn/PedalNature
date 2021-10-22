//
//  SettingsViewController.swift
//  PedalNature
//
//  Created by Volkan on 24.09.2021.
//

import UIKit
import FirebaseAuth

/// Settings List
///     - Edit Profile
///     - Account
///     - Metrics
///     - Terms
///     -  Privacy
///     - Help / Support
///     - Log Out

final class SettingsViewController: UIViewController {

    private let settingsTableview : UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableview
    }()
    
    private var data = [[SettingsCellModal]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModal()
        view.addSubview(settingsTableview)
        view.backgroundColor = .systemBackground
        settingsTableview.delegate = self
        settingsTableview.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        settingsTableview.frame = view.bounds
    }
    
    private func configureModal(){
        data.append([
                    SettingsCellModal(title: "Edit Profile") { [weak self] in
                        self?.didTapEditProfile()
                    },
                     SettingsCellModal(title: "Account") { [weak self] in
                         self?.didTapAccount()
                     },
                     SettingsCellModal(title: "Invite Friends") { [weak self] in
                         self?.didTapInviteFriends()
                     },
                    SettingsCellModal(title: "Metrics") { [weak self] in
                        self?.didTapMetrics()
                    }])

        data.append([
                    SettingsCellModal(title: "Terms of Service") { [weak self] in
                        self?.didTapTerms()
                    },
                    SettingsCellModal(title: "Privacy policy") { [weak self] in
                        self?.didTapPrivacy()
                    },
                    SettingsCellModal(title: "Help/Support") { [weak self] in
                        self?.didTapHelp()
                    }])
        data.append([SettingsCellModal(title: "Log Out") { [weak self] in
            self?.didTapLogOut()
        }])
    }
    
    private func didTapEditProfile(){
        let vc = EditProfileViewController()
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: true, completion: nil)
    }
    
    private func didTapAccount(){
        
    }
    
    private func didTapInviteFriends(){
        
    }
    
    private func didTapMetrics(){
        
    }
    
    private func didTapTerms(){
        
    }
    
    private func didTapPrivacy(){
        
    }
    
    private func didTapHelp(){
        
    }

    
    private func didTapLogOut(){
        let actionsheet = UIAlertController(title: "Log Out",
                                            message: "Are you sure you want to Log Out ?", preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionsheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { actionsheet in
            AuthManager.shared.logOut(completion: { success in
                DispatchQueue.main.async {
                    if success{
                        let vc = LoginViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true ){
                            self.navigationController?.popToRootViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        }
                        
                    }
                    else{
                        fatalError("Could not log out user")
                    }
                }
            })

        }))
        actionsheet.popoverPresentationController?.sourceView = settingsTableview
        actionsheet.popoverPresentationController?.sourceRect = settingsTableview.bounds
        present(actionsheet, animated: true)
        
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.section][indexPath.row].handler()
    }
    
    
}
