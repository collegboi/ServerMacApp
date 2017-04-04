///
//  GithubViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 02/04/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class GithubViewController: NSViewController {
    
    
    @IBOutlet weak var githubTableView: NSTableView!
    @IBOutlet weak var usernameLabel: NSTextField!
    
    var allRepos = [Repos]()
    
    fileprivate var githubTableViewDelegate: GithubTableViewDelegate!
    fileprivate var githubTableViewDataSource: GithubTableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.githubTableViewDataSource = GithubTableViewDataSource(tableView: self.githubTableView)
        self.githubTableViewDelegate = GithubTableViewDelegate(tableView: self.githubTableView)
        
        self.getAllRepos()
    }
    
    func reloadTable() {
        self.githubTableViewDelegate.reload(self.allRepos)
        self.githubTableViewDataSource.reload(count: self.allRepos.count)
    }
    
    func getStatsForRepos() {
        
        for repo in self.allRepos {
            
            let githubToken = UserDefaults.standard.string(forKey: "git_Token") ?? "67c01987af05d394167f8475ca754eaae4344cff"
            
            var url = "https://api.github.com/repos/collegboi/"+repo.name+"/stats/contributors"
            
            if githubToken != "" {
                url = url + "?access_token=" + githubToken
            }
            
            
            HTTPSConnection.httpGetRequestURL(token: "", url: url, mainKey: "") { (complete, results) in
                DispatchQueue.main.async {
                    if complete {
                        
                        for result in results {
                            
                            repo.totalCommits = result.tryConvert(forKey: "total")
                        }
                        
                        self.reloadTable()
                        
                    }
                }
            }
            
        }
    }
    
    func getAllRepos() {
        
        let githubToken = UserDefaults.standard.string(forKey: "git_Token") ?? "67c01987af05d394167f8475ca754eaae4344cff"
        let githubUserName = UserDefaults.standard.string(forKey: "git_username") ?? "collegboi"
        self.usernameLabel.stringValue = githubUserName
        
        var url = "https://api.github.com/users/"+githubUserName+"/repos?sort=updatedt"
        
        if githubToken != "" {
            url = url + "&access_token=" + githubToken
        }
        
        
        
        HTTPSConnection.httpGetRequestURL(token: "", url: url, mainKey: "") { (complete, results) in
            DispatchQueue.main.async {
                if complete {
                    
                    for result in results {
                        
                        let newRepo = Repos(dictionary: result)
                        self.allRepos.append(newRepo)
                    }
                    
                    self.reloadTable()
                    self.getStatsForRepos()
                }
            }
        }
    }
    
}
