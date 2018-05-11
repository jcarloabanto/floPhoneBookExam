//
//  ViewController.swift
//  floPhoneBook
//
//  Created by James Abanto on 11/05/2018.
//  Copyright © 2018 James Abanto. All rights reserved.
//

import UIKit

struct friendsData {
    let name: String?
    let gender: String?
    let age: String?
    let status: String?
    let birthdate: String?
}

struct cellData {
    let name: String?
    let gender: String?
    let age: Int?
    let status: String?
    let birthdate: String?
    let email: String?
    let mobileNumber: String?
    let address: String?
}

class ViewController: UITableViewController {
    let searchController = UISearchController(searchResultsController: nil)
    var data = [cellData]()
    var filteredData = [cellData]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUsers()
        setUpSearchController()
        setUpTableView()
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! PhoneBookTableViewCell
        let userData: cellData
        userData = isFiltering() ? filteredData[indexPath.row] : data[indexPath.row]
        cell.name = userData.name
        cell.age = userData.age
        cell.gender = userData.gender
        cell.birthdate = userData.birthdate
        cell.status = userData.status
        cell.layoutSubviews()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredData.count : data.count
    }
    
    func setUpTableView() {
        self.tableView.register(PhoneBookTableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.topAnchor.constraintEqualToSystemSpacingBelow(view.topAnchor, multiplier: 100).isActive = true
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        self.tableView.reloadData()
    }
   
    func getUsers(){
        if let path = Bundle.main.path(forResource: "usersAPI", ofType: "txt") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                guard let jsonValues = json as? [Any] else { return }
                for jsonValue in jsonValues {
                    
                    guard let jsonDict = jsonValue as? [String:Any] else {return}
                    let contactName: String? = jsonDict["name"] as? String ?? ""
                    let contactAge: Int? = jsonDict["age"] as? Int ?? nil
                    let contactSex: String? = jsonDict["sex"] as? String ?? ""
                    let contactStatus: String? = jsonDict["status"] as? String ?? ""
                    let contactBirthDate: String? = jsonDict["birthdate"] as? String ?? ""
                    let contactDetails = jsonDict["contactDetails"] as? [String : Any] ?? [:]
                    let email: String? = contactDetails["email"] as? String ?? ""
                    let mobileNumber: String? = contactDetails["mobileNumber"] as? String ?? ""
                    let address: String? = contactDetails["address"] as? String ?? ""
                    
                    _ = self.data.append(cellData.init(name: contactName, gender: contactSex, age: contactAge, status: contactStatus, birthdate: contactBirthDate, email: email, mobileNumber: mobileNumber, address: address))
                }
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path")
        }
    }
}

extension ViewController: UISearchResultsUpdating {
    
    func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Names"
        navigationItem.title = "Phone Book"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredData = data.filter({( cellData : cellData) -> Bool in
            return (cellData.name?.lowercased().contains(searchText.lowercased()))!
        })
        
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}
