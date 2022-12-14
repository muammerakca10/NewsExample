//
//  ViewController.swift
//  NewsExample
//
//  Created by MAC on 2.09.2022.
//

import UIKit

class ViewController:  UITableViewController {
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var tempPetitions = [Petition]()
    var filterWord : String?
    var textFieldSearch : UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(creditsButtonTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        
        let urlString : String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString){
                if let data = try? Data(contentsOf: url){
                    self.parse(json: data)
                } else {
                    self.showError()
                }
            }
            self.tempPetitions = self.petitions
        }
        
    }
    
    
    @objc func searchButtonTapped(){
        let acFilter = UIAlertController(title: "Search Menu", message: "Enter Search Word...", preferredStyle: UIAlertController.Style.alert)
        acFilter.addTextField()
        acFilter.addAction(UIAlertAction(title: "Search", style: .default, handler: { alertAction in
            self.filterWord = acFilter.textFields![0].text
            
            if let filterWord = self.filterWord {
                self.filteredPetitions.removeAll()
                for petition in self.petitions {
                    if petition.body.lowercased().contains(filterWord.lowercased()) || petition.title.lowercased().contains(filterWord.lowercased()) {
                        self.filteredPetitions.append(petition)
                    }
                }
                
                self.tempPetitions = self.filteredPetitions
                self.tableView.reloadData()
                
                if self.tempPetitions.isEmpty {
                    let acNotFound = UIAlertController(title: "Error!", message: "\(filterWord) is not found", preferredStyle: .alert)
                    acNotFound.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(acNotFound, animated: true)
                    self.tempPetitions = self.petitions
                    self.tableView.reloadData()
                }
            }
        }))
        
        acFilter.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        acFilter.addAction(UIAlertAction(title: "Show all", style: .default, handler: { (alert) in
            self.tempPetitions = self.petitions
            self.tableView.reloadData()
            self.filterWord = ""
        }))
        present(acFilter, animated: true)
    }
    /*
    @objc func creditsButtonTapped(){
        let ac = UIAlertController(title: "Credits", message: "This informations from White House", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
     */
    
    func showError () {
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: "Error", message: "An error occurred. Please control your connect!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(ac, animated: true)
        }
        
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tempPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = tempPetitions[indexPath.row].title
        cell.detailTextLabel?.text = tempPetitions[indexPath.row].body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = tempPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        vc.title = tempPetitions[indexPath.row].title
        
        
    }
}

