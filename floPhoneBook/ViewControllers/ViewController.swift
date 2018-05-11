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
    let age: Int?
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
    let friends: friendsData?
}

class ViewController: UITableViewController {
    let searchController = UISearchController(searchResultsController: nil)
    var contactFriendsData: friendsData?
    var data = [cellData]()
    var filteredData = [cellData]()
    var selectedContactData: cellData?
    
    
    override func viewDidLoad() {
        getUsers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSecond" {
            let vc = segue.destination as! SecondViewController
            vc.selectedContactData = self.selectedContactData
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedContactData = self.data[indexPath.row]
        self.performSegue(withIdentifier: "goToSecond", sender: self)
    }
    
    func setUpTableView() {
        self.tableView.register(PhoneBookTableViewCell.self, forCellReuseIdentifier: "cellId")
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
                    let contactAge: Int? = jsonDict["age"] as? Int ?? 0
                    let contactSex: String? = jsonDict["sex"] as? String ?? ""
                    let contactStatus: String? = jsonDict["status"] as? String ?? ""
                    let contactBirthDate: String? = jsonDict["birthdate"] as? String ?? ""
                    let contactDetails = jsonDict["contactdetails"] as? [String : Any] ?? [:]
                    let email: String? = contactDetails["email"] as? String ?? ""
                    let mobileNumber: String? = contactDetails["mobileNumber"] as? String ?? ""
                    let address: String? = contactDetails["address"] as? String ?? ""
                    guard let contact = jsonDict["friends"] as? [String : Any] else { return }
                    print(contact)
                    let friendsName: String? = contact["name"] as? String ?? ""
                    let friendsAge: Int? = contact["age"] as? Int ?? 0
                    let friendsSex: String? = contact["sex"] as? String ?? ""
                    let friendsStatus: String? = contact["status"] as? String ?? ""
                    let friendsBirthDate: String? = contact["birthdate"] as? String ?? ""
                    
                    self.contactFriendsData = friendsData.init(name: friendsName, gender: friendsSex, age: friendsAge, status: friendsStatus, birthdate: friendsBirthDate)
                    _ = self.data.append(cellData.init(name: contactName, gender: contactSex, age: contactAge, status: contactStatus, birthdate: contactBirthDate, email: email, mobileNumber: mobileNumber, address: address, friends: contactFriendsData))
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
