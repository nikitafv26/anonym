//
//  ViewController.swift
//  anonym
//
//  Created by Nikita Fedorenko on 13.06.2021.
//

import UIKit

class PostListViewController: UIViewController {

    private var service = PostService()
    
    let itemsInBatch = 20
    var cursor: String? = ""
    var order = Order.popular
    
    var orderView: UIView!
    var popularButton: UIButton!
    var commentedButton: UIButton!
    var createdButton: UIButton!
    
    var tableView: UITableView!
    var imgLoader = ImgLoader()
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        initOrderView()
        initTableView()
        
        fetchData()
    }
    
    func setupNavigation(){
        navigationItem.title = "POSTS"
        self.navigationController?.navigationBar.barTintColor = .red
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func initOrderView(){
        orderView = UIView()
        orderView.backgroundColor = .black
        view.addSubview(orderView)
        
        popularButton = UIButton()
        popularButton.setTitle("Popular", for: .normal)
        popularButton.addTarget(self, action: #selector(popularButtonPressed), for: .touchUpInside)
        
        commentedButton = UIButton()
        commentedButton.setTitle("Commented", for: .normal)
        commentedButton.addTarget(self, action: #selector(commentedButtonPressed), for: .touchUpInside)
        
        createdButton = UIButton()
        createdButton.setTitle("Created", for: .normal)
        createdButton.addTarget(self, action: #selector(createdButtonPressed), for: .touchUpInside)
        
        view.addSubview(popularButton)
        view.addSubview(commentedButton)
        view.addSubview(createdButton)
        
        orderView.translatesAutoresizingMaskIntoConstraints = false
        orderView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        orderView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        orderView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        orderView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        popularButton.translatesAutoresizingMaskIntoConstraints = false
        popularButton.centerYAnchor.constraint(equalTo: self.orderView.centerYAnchor).isActive = true
        popularButton.trailingAnchor.constraint(equalTo: self.commentedButton.leadingAnchor, constant: -20).isActive = true
        
        commentedButton.translatesAutoresizingMaskIntoConstraints = false
        commentedButton.centerYAnchor.constraint(equalTo: self.orderView.centerYAnchor).isActive = true
        commentedButton.centerXAnchor.constraint(equalTo: self.orderView.centerXAnchor).isActive = true
        
        createdButton.translatesAutoresizingMaskIntoConstraints = false
        createdButton.centerYAnchor.constraint(equalTo: self.orderView.centerYAnchor).isActive = true
        createdButton.leadingAnchor.constraint(equalTo: self.commentedButton.trailingAnchor, constant: 20).isActive = true
    }
    
    func initTableView(){
        tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.orderView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func fetchData(){
        if let cursor = self.cursor {
            service.fetch(first: itemsInBatch, after: cursor, orderBy: order, completion: { data in
                self.posts.append(contentsOf: data.items)
                self.cursor = data.cursor
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    @objc
    func popularButtonPressed() {
        orderBy(criterion: .popular)
    }
    
    @objc
    func commentedButtonPressed() {
        orderBy(criterion: .commented)
    }
    
    @objc
    func createdButtonPressed() {
        orderBy(criterion: .created)
    }
    
    func orderBy(criterion: Order){
        posts.removeAll()
        tableView.reloadData()
        
        cursor = ""
        order = criterion
        
        fetchData()
    }
}


extension PostListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row]
        
        if indexPath.row == self.posts.count - 1, self.cursor != nil{
            fetchData()
            return cell
        }
        
        if let imgPath = post.extraSmallImgUrl{
            imgLoader.load(from: imgPath){ image in
                if let updateCell = tableView.cellForRow(at: indexPath) as? PostTableViewCell {
                    updateCell.authorImageView.image = image
                }
            }
        }
        
        cell.authorNameLabel.text = post.authorName
        if let contents = post.contents{
            let textContents = service.getTextContent(data: contents)
            cell.postTitleLabel.text = textContents.first?.textValue
        }
        cell.viewsImageView.image = UIImage(systemName: "eye")
        if let viewCount = post.viewCount{
            cell.viewCountLabel.text = String(viewCount)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let detailVC = PostDetailViewController()
        detailVC.data = post
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
}

