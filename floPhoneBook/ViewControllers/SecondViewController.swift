//
//  SecondViewController.swift
//  floPhoneBook
//
//  Created by James Abanto on 11/05/2018.
//  Copyright © 2018 James Abanto. All rights reserved.
//

import UIKit

class SecondViewController: UITableViewController {
    
    var selectedContactData: cellData?
    var contactData = [String]()
    var friendsContactData = [String]()
    var dataTitleToBePresented: [String] = ["Name: ", "Gender: ", "Status: ", "Birthdate: ", "Age: ", "Address: ", "Email: ", "Mobile Number: "]
    var friendsDataToBePresented: [String] = ["Name: ", "Gender: ", "Status: ", "Birthdate: ", "Age: "]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.register(SecondTableViewCell.self, forCellReuseIdentifier: "cellId")
        contactData = [selectedContactData?.name, selectedContactData?.gender, selectedContactData?.status, selectedContactData?.birthdate, "\(String(describing: selectedContactData?.age))", selectedContactData?.address, selectedContactData?.email, selectedContactData?.mobileNumber] as! [String]
        friendsContactData = [selectedContactData?.friends?.name, selectedContactData?.friends?.gender, selectedContactData?.friends?.status, selectedContactData?.friends?.birthdate, "\(String(describing: selectedContactData?.age))"] as! [String]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? dataTitleToBePresented.count : friendsDataToBePresented.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        if indexPath.section == 1 {
            cell.textLabel?.text = self.friendsDataToBePresented[indexPath.row] + self.friendsContactData[indexPath.row]
        } else {
            cell.textLabel?.text = self.dataTitleToBePresented[indexPath.row] + self.contactData[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Contact Details" : "Friends"
    }
}
