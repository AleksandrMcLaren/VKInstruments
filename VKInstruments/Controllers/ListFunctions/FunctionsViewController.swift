//
//  FunctionsViewController.swift
//  VKInstruments
//
//  Created by Aleksandr on 05/07/2017.
//
//

import UIKit

protocol FunctionsView  {

    func showFunctionsData(_ functions: [Function])
}

class FunctionsViewController: UIViewController {

    var presenter: FunctionsPresentation!
    let tableView: UITableView = UITableView()
    let cellReuseIdentifier = "cell"
    var functions: [Function] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self;
        tableView.allowsMultipleSelection = true;
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80.0
        view.addSubview(tableView)
        
        presenter.needsUpdateView()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let boundsSize = view.bounds.size
        
        tableView.frame = CGRect(x: 0, y: 0, width: boundsSize.width, height: boundsSize.height)
        
        if let rect = Router.shared.navigationController?.navigationBar.frame {
            
            let y = rect.size.height + rect.origin.y
            self.tableView.contentInset = UIEdgeInsetsMake( y, 0, 0, 0)
        }
    }
    
    // MARK: - Actions
}

extension FunctionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return functions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let function = functions[indexPath.row]
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
            else {return UITableViewCell()}
        
        cell.textLabel?.text = function.title
        cell.accessoryType = function.selected ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let f = functions[indexPath.row]
        presenter.didSelectFunction(f)
    }
}

extension FunctionsViewController: FunctionsView {
    
    func showFunctionsData(_ functions: [Function]) {
        
        self.functions = functions
    }
}
