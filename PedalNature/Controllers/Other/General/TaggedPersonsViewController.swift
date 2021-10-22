//
//  TaggedPersonsViewController.swift
//  PedalNature
//
//  Created by Volkan on 14.10.2021.
//

import UIKit

class TaggedPersonsViewController: UIViewController {

    private let tagPersonTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(TaggedPersonTableViewCell.self, forCellReuseIdentifier: TaggedPersonTableViewCell.identifier)
        return tableView
    }()
    
    public var routeModal : UserRoute?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tagPersonTableView)
        tagPersonTableView.delegate = self
        tagPersonTableView.dataSource = self
        navigationItem.hidesBackButton = false        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bottomHeight = view.safeAreaLayoutGuide.layoutFrame.size.height

        tagPersonTableView.frame = CGRect(x: 0,
                                          y: view.safeAreaInsets.top,
                                          width: view.width,
                                          height: bottomHeight)
    }

}

extension TaggedPersonsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeModal!.tagUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaggedPersonTableViewCell.identifier, for: indexPath) as! TaggedPersonTableViewCell
        cell.configure(with: (routeModal!.tagUser[indexPath.row]))
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}

extension TaggedPersonsViewController: TaggedPersonTableViewCellDelegate{
    func userNameorPhotoPressed(_ response: User) {
        let vc = UserProfileViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
