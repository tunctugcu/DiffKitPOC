//
//  ViewController2.swift
//  DiffKitPOC
//
//  Created by Tunc Tugcu on 25.08.2021.
//


import DifferenceKit

final class ViewController2: UIViewController {
    let identifier = "cell"
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var items: [ArraySection<Section, AnyDifferentiable>] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let newItems: [ArraySection<Section, AnyDifferentiable>] = [
                ArraySection(model: .a, elements: [
                    AnyDifferentiable(Model(id: 1, fullName: "Tunc", content: "akdjfakljdf")),
                    AnyDifferentiable(Model(id: 1, fullName: "Tunc", content: "ajksdfklajsdfkljasdfkl")),
                    AnyDifferentiable(Model(id: 2, fullName: "Selahattin", content: "Dulgeroglu")),
                    AnyDifferentiable(Model(id: 3, fullName: "Shehryar", content: "Mohammed")),
                    AnyDifferentiable(Model2(id: 4, fullName: "Tunc2", content: "akdjfakljdf")),
                ]),
                
                ArraySection(model: .c, elements: [
                    AnyDifferentiable(Model2(id: 4, fullName: "Tunc2", content: "akdjfakljdf")),
                    AnyDifferentiable(Model2(id: 5, fullName: "Selahattin2", content: "Dulgeroglu")),
                    AnyDifferentiable(Model2(id: 7, fullName: "Shehryar2", content: "Mohammed"))
                ])
            ]
            
            let changeSet = StagedChangeset(source: self.items, target: newItems)
            
            self.tableView.reload(using: changeSet, with: .automatic) { (data) in
                self.items = data
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                var copyItems = self.items
                
                copyItems[0].elements.append(
                    AnyDifferentiable(Model(id: 4, fullName: "asdfasdfadf", content: "Mohammed"))
                )
                
                
                let changeSet = StagedChangeset(source: self.items, target: copyItems)
                
                self.tableView.reload(using: changeSet, with: .automatic) { (data) in
                    self.items = data
                }
            }
        }
    }
}

extension ViewController2: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if let item = items[indexPath.section].elements[indexPath.row].base as? Model {
            cell.textLabel?.text = item.fullName
            cell.detailTextLabel?.text = item.content
        }
        
        if let item = items[indexPath.section].elements[indexPath.row].base as? Model2 {
            cell.textLabel?.text = "Model 2:" + item.fullName
            cell.detailTextLabel?.text = "Model 2: " + item.content
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].model.title
    }
}


enum Section: Differentiable {
    case a, b, c
    
    var title: String? {
        switch self {
        case .a: return "a"
        case .b: return "b"
        case .c: return "c"
        }
    }
}
