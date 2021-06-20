//
//  PostTableViewCell.swift
//  anonym
//
//  Created by Nikita Fedorenko on 13.06.2021.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    let authorImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 35
        img.clipsToBounds = true
        return img
    }()
    
    let authorNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textColor = UIColor.white
        lbl.backgroundColor = UIColor.green
        lbl.layer.cornerRadius = 5
        lbl.clipsToBounds = true
        lbl.contentMode = .scaleAspectFill
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let postTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textColor = UIColor.black
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    let containerView: UIView = {
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.clipsToBounds = true
      return view
    }()
    
    let viewsImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let viewCountLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 10)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        authorImageView.image = nil
    }
    
    private func addViews(){
        self.contentView.addSubview(authorImageView)
        containerView.addSubview(authorNameLabel)
        containerView.addSubview(postTitleLabel)
        self.contentView.addSubview(containerView)
        self.contentView.addSubview(viewsImageView)
        self.contentView.addSubview(viewCountLabel)
    }
    
    private func setConstraints(){
        //authorImageView
        authorImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        authorImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        authorImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        authorImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        //containerView
        containerView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.authorImageView.trailingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        //postTitleLabel
        postTitleLabel.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor).isActive = true
        postTitleLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        postTitleLabel.trailingAnchor.constraint(equalTo: self.viewsImageView.leadingAnchor, constant: -20).isActive = true
        
        //authorNameLabel
        authorNameLabel.topAnchor.constraint(equalTo: self.postTitleLabel.bottomAnchor).isActive = true
        authorNameLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        
        //viewsImageView
        viewsImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        viewsImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -40).isActive = true
        viewsImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        viewsImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        //viewCountLabel
        viewCountLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        //viewCountLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
        viewCountLabel.leadingAnchor.constraint(equalTo: self.viewsImageView.trailingAnchor, constant: 5).isActive = true
        
    }

}
