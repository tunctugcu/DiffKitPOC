//
//  ViewController.swift
//  DiffKitPOC
//
//  Created by Tunc Tugcu on 25.08.2021.
//

import UIKit
import DifferenceKit

final class ViewController: UIViewController {
    
    let identifier = "cell"
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var items = [Model]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            let a = Model(id: 1, fullName: "Tunc", content: "akdjfakljdf")

            let newItems = [
                a,
                a,
                Model(id: 2, fullName: "Selahattin", content: "akdjfakljdf"),
                Model(id: 3, fullName: "Shehryar", content: "akdjfakljdf"),
            ]

            let changeSet = StagedChangeset(source: self.items, target: newItems)


            self.tableView.reload(using: changeSet, with: .automatic) { (data) in
                self.items = data
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                let anotherItems = [
                    Model(id: 1, fullName: "Tunc", content: "akdjfakljdf"),
                    Model(id: 2, fullName: "Selahattin", content: "Dulgeroglu"),
                    Model(id: 2, fullName: "Selahattin", content: "Dulgeroglu"),
                    Model(id: 3, fullName: "Shehryar", content: "Mohammed"),
//                    Model(id: 2, fullName: "Selahattin Dulgeroglu", content: "akdjfakljdf"),
//                    Model(id: 4, fullName: "Shehryar", content: "akdjfakljdf"),
                ]

                let changeSet = StagedChangeset(source: self.items, target: anotherItems)

                self.tableView.reload(using: changeSet, with: .automatic) { (data) in
                    self.items = data
                }
            }
        }
    }
}

extension ViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.fullName
        cell.detailTextLabel?.text = item.content
        
        return cell
    }
}

struct Post {
    let id: Int
    let title: String
}

struct PostPresentationModel {
    private let post: Post
    
    init(post: Post) {
        self.post = post
    }
    
    var title: String {
        return post.title
    }
}

extension PostPresentationModel: Differentiable {
    func isContentEqual(to source: PostPresentationModel) -> Bool {
        return post.title == source.post.title
    }
    
    var differenceIdentifier: Int {
        return post.id
    }
}


final class Model: Differentiable {
    
    func isContentEqual(to source: Model) -> Bool {
        return fullName == source.fullName &&
            content == source.content
        
    }
    
    let id: Int
    let fullName: String
    let content: String
    
    init(id: Int, fullName: String, content: String) {
        self.id = id
        self.fullName = fullName
        self.content = content
    }
    
    var differenceIdentifier: Int {
        return id
    }
}

struct Model2: Differentiable {
    
    func isContentEqual(to source: Model2) -> Bool {
        return fullName == source.fullName &&
            content == source.content
        
    }
    
    let id: Int
    let fullName: String
    let content: String

    
    var differenceIdentifier: Int {
        return id
    }
}

