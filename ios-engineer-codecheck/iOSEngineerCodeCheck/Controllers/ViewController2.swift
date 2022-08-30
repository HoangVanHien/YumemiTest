//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    let notFavoriteImage = UIImage.init(systemName: "heart")
    let didFavoriteImage = UIImage(systemName: "heart.fill")
    
    var model: ViewModel?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDetail()
        getImage()
        setUpFavorite()
    }
    
    func setUpDetail(){
        guard let index = model?.idx, let repo = model?.repo[index] else {
            return
        }
        languageLabel.text = "Written in \(repo["language"] as? String ?? "")"
        starsLabel.text = "\(repo["stargazers_count"] as? Int ?? 0) stars"
        watchersLabel.text = "\(repo["wachers_count"] as? Int ?? 0) watchers"
        forksLabel.text = "\(repo["forks_count"] as? Int ?? 0) forks"
        issuesLabel.text = "\(repo["open_issues_count"] as? Int ?? 0) open issues"
    }
    
    func getImage(){
        guard let index = model?.idx, let repo = model?.repo[index] else {
            return
        }
        
        titleLabel.text = repo["full_name"] as? String ?? ""
        
        guard let owner = repo["owner"] as? [String: Any] else {
            return
        }
        guard let imgURL = owner["avatar_url"] as? String else {
            return
        }
        URLSession.shared.dataTask(with: URL(string: imgURL)!) { (data, res, err) in
            let img = UIImage(data: data!)!
            DispatchQueue.main.async {
                self.imageView.image = img
            }
        }.resume()
        
    }
    
    func setUpFavorite(){
        guard let index = model?.idx, let fav = model?.favorite[index] else {
            return
        }
        favoriteImage.image = fav ? didFavoriteImage : notFavoriteImage
        favoriteImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(favoriteAction)))
    }
    
    @objc func favoriteAction(){
        guard let index = model?.idx, let fav = model?.favorite[index] else {
            return
        }
        model?.favorite[index] = favoriteImage.image == notFavoriteImage
        favoriteImage.image = fav ? notFavoriteImage : didFavoriteImage
    }
}
