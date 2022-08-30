//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    var model: ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        model = ViewModel()
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model?.task?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        model?.word = searchBar.text
        
        guard let word = model?.word else {
            return
        }
        guard word.count != 0 else {
            return
        }
        model?.url = "https://api.github.com/search/repositories?q=\(word)"
        guard let url = URL(string: model?.url ?? "") else {
            return
        }
        model?.task = URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let obj = try? JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                if let items = obj["items"] as? [[String: Any]] {
                    self.model?.repo = items
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        // これ呼ばなきゃリストが更新されません
        model?.task?.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Detail" {
            let dtl = segue.destination as? ViewController2
            dtl?.model = model
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.repo.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        guard let rp = model?.repo[indexPath.row] else {
            return cell
        }
        cell.textLabel?.text = rp["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = rp["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        model?.idx = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
        
    }
    
}
