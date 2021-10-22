//
//  CommentAndLikesViewController.swift
//  PedalNature
//
//  Created by Volkan on 18.10.2021.
//

import UIKit
import FirebaseAuth
import SDWebImage

final class CommentAndLikesViewController: UIViewController {

    
    private let likesLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Likes"
        label.isHidden = true
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let containerView : UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let firstPhotoOfLikedPerson : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        return imageView
    }()
    
    private let secondPhotoOfLikedPerson : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true

        
        return imageView
    }()
    
    private let thirdPhotoOfLikedPerson : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true

        return imageView
    }()
    
    private let likedLabel : UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textColor = .label
        return label
    }()
    
    private let goToLikedListButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let commentsLabel : UILabel = {
        let label = UILabel()
        label.text = "Comments"
        label.isHidden = true
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let commentTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(CommentsTableViewCell.self, forCellReuseIdentifier: CommentsTableViewCell.identifier)
        tableView.isHidden = true
        tableView.separatorColor = .systemBackground
        return tableView
    }()
    
    private let footerContainerView : UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let userPhotoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let commentTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Comment Here..."
        textField.returnKeyType = .continue
        textField.leftViewMode = .always
        textField.clearButtonMode = .always
        textField.clearButtonMode = .whileEditing
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.layer.borderColor = UIColor.secondaryLabel.cgColor
        textField.layer.borderWidth = 1.0
        return textField
    }()
    
    private let sendButton : UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    public var commentModal : UserRoute?
    
    private var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .systemBackground
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTextField.delegate = self
        //user = Auth.auth().currentUser
        configureView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bottomHeight = view.safeAreaLayoutGuide.layoutFrame.size.height
        let goToButtonSize = 30.0
        let photoSize = 30.0

        likesLabel.frame = CGRect(x: 10,
                                  y: view.safeAreaInsets.top + 20.0,
                                  width: view.width,
                                  height: photoSize+20.0)
        
        containerView.frame = CGRect(x: 0,
                                     y: likesLabel.bottom,
                                     width: view.width,
                                     height: photoSize+40.0)
        
        firstPhotoOfLikedPerson.frame = CGRect(x: 10,
                                               y: containerView.top + 10.0,
                                               width: photoSize,
                                               height: photoSize)
        firstPhotoOfLikedPerson.layer.cornerRadius = photoSize/2
        
        secondPhotoOfLikedPerson.frame = CGRect(x: firstPhotoOfLikedPerson.right - photoSize/2,
                                               y: containerView.top + 10.0,
                                               width: photoSize,
                                               height: photoSize)
        secondPhotoOfLikedPerson.layer.cornerRadius = photoSize/2
        
        thirdPhotoOfLikedPerson.frame = CGRect(x: secondPhotoOfLikedPerson.right - photoSize/2,
                                               y: containerView.top + 10.0,
                                               width: photoSize,
                                               height: photoSize)
        thirdPhotoOfLikedPerson.layer.cornerRadius = photoSize/2
        
        likedLabel.frame = CGRect(x: thirdPhotoOfLikedPerson.right,
                                  y: containerView.top + 10.0,
                                  width: photoSize + 20.0,
                                  height: photoSize)
        
        goToLikedListButton.frame = CGRect(x: view.width - goToButtonSize - 20.0,
                                           y: containerView.top + 10.0,
                                           width: goToButtonSize/1.5,
                                           height: goToButtonSize/1.5)
        
        commentsLabel.frame = CGRect(x: 10,
                               y: likedLabel.bottom,
                               width: view.width,
                               height: photoSize+20.0)
        
        commentTableView.frame = CGRect(x: 0,
                                        y: commentsLabel.bottom,
                                        width: view.width,
                                        height: view.height - bottomHeight)
        
        footerContainerView.frame = CGRect(x: 0,
                                           y: view.height-2*photoSize,
                                           width: view.width,
                                           height: photoSize)
        
        userPhotoImageView.frame = CGRect(x: 10,
                                          y: footerContainerView.top - 10.0,
                                          width: photoSize,
                                          height: photoSize)
        userPhotoImageView.layer.cornerRadius = photoSize/2
        
        let buttonSize = 30.0
        commentTextField.frame = CGRect(x: userPhotoImageView.right + 5.0,
                                        y: footerContainerView.top - 10.0,
                                        width: footerContainerView.width - photoSize - buttonSize - 60.0,
                                        height: photoSize)
        commentTextField.layer.cornerRadius = photoSize/2
        
        sendButton.frame = CGRect(x: commentTextField.right + 5.0,
                                  y: footerContainerView.top - 10.0,
                                  width: photoSize*1.5,
                                  height: photoSize)
        
    }
    
    private func configureView(){
        view.addSubview(likesLabel)
        view.addSubview(containerView)
        view.addSubview(firstPhotoOfLikedPerson)
        view.addSubview(secondPhotoOfLikedPerson)
        view.addSubview(thirdPhotoOfLikedPerson)
        view.addSubview(likedLabel)
        view.addSubview(commentsLabel)
        view.addSubview(commentTableView)
        view.addSubview(goToLikedListButton)
        view.addSubview(footerContainerView)
        view.addSubview(userPhotoImageView)
        view.addSubview(commentTextField)
        view.addSubview(sendButton)
        
        if commentModal!.likeCount.count > 0{
            commentTableView.isHidden = false
        }
        
        if commentModal!.likeCount.count > 0{
            if commentModal!.likeCount.count == 1{
                firstPhotoOfLikedPerson.isHidden = false
                firstPhotoOfLikedPerson.backgroundColor = .systemRed
//                firstPhotoOfLikedPerson.sd_setImage(with: modal?.likeCount.first?.user.profilePhoto, completed: nil)
            }else if commentModal?.likeCount.count == 2{
                firstPhotoOfLikedPerson.isHidden = false
                secondPhotoOfLikedPerson.isHidden = false
                firstPhotoOfLikedPerson.backgroundColor = .systemRed
                secondPhotoOfLikedPerson.backgroundColor = .systemBlue
//                firstPhotoOfLikedPerson.sd_setImage(with: modal?.likeCount.first?.user.profilePhoto, completed: nil)
//                secondPhotoOfLikedPerson.sd_setImage(with: modal?.likeCount[1].user.profilePhoto, completed: nil)
            
            }else if commentModal!.likeCount.count > 2{
                firstPhotoOfLikedPerson.isHidden = false
                secondPhotoOfLikedPerson.isHidden = false
                thirdPhotoOfLikedPerson.isHidden = false
                firstPhotoOfLikedPerson.backgroundColor = .systemRed
                secondPhotoOfLikedPerson.backgroundColor = .systemBlue
                thirdPhotoOfLikedPerson.backgroundColor = .systemGreen
//                firstPhotoOfLikedPerson.sd_setImage(with: modal?.likeCount.first?.user.profilePhoto, completed: nil)
//                secondPhotoOfLikedPerson.sd_setImage(with: modal?.likeCount[1].user.profilePhoto, completed: nil)
//                thirdPhotoOfLikedPerson.sd_setImage(with: modal?.likeCount[2].user.profilePhoto, completed: nil)
            }
            commentsLabel.isHidden = false
            likesLabel.isHidden = false
            likedLabel.isHidden = false
            goToLikedListButton.isHidden = false
            likedLabel.text = commentModal!.likeCount.count > 1 ?
                            "\(commentModal!.likeCount.count) likes" :
                            "\(commentModal!.likeCount.count) like"
            userPhotoImageView.backgroundColor = .systemBrown
            //userPhotoImageView.sd_setImage(with: user?.profilePhoto, completed: nil)
        }else{
            commentsLabel.isHidden = false
            commentsLabel.frame = CGRect(x: 10,
                                         y: view.safeAreaInsets.top + 20.0,
                                         width: view.width,
                                         height: 50.0)
        }
    
    }

}

extension CommentAndLikesViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentModal!.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if commentModal!.comments.count > 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentsTableViewCell.identifier, for: indexPath) as! CommentsTableViewCell
            cell.configure(with: commentModal!.comments[indexPath.row])
            return cell
            
        }else{
            return UITableViewCell()
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    
}

extension CommentAndLikesViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        self.view.superview!.setNeedsLayout()
        self.view.superview!.layoutIfNeeded()
        self.commentTextField.frame.size.width = 30
        
        

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
