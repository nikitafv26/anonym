//
//  PostDetailViewController.swift
//  anonym
//
//  Created by Nikita Fedorenko on 13.06.2021.
//

import UIKit

class PostDetailViewController: UIViewController {

    var postTextLabel: UILabel!
    
    var data: Post?
    var textArea = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        postTextLabel = UILabel()
        postTextLabel.font = UIFont.italicSystemFont(ofSize: 20)
        postTextLabel.textColor = .black
        postTextLabel.textAlignment = .center
        postTextLabel.numberOfLines = 10
        self.view.addSubview(postTextLabel)
        
        postTextLabel.translatesAutoresizingMaskIntoConstraints = false
        postTextLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        postTextLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        postTextLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 10).isActive = true
        
        if let post = data{
            if let contents = post.contents{
                for content in contents {
                    self.textArea += content.textValue ?? ""
                    self.textArea += "\n"
                }
            }
        }
        
        postTextLabel.text = textArea
    }
}
