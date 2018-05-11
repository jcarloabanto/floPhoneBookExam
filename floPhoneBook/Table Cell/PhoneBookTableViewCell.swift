//
//  PhoneBookTableViewCell.swift
//  floPhoneBook
//
//  Created by James Abanto on 11/05/2018.
//  Copyright © 2018 James Abanto. All rights reserved.
//

import UIKit

class PhoneBookTableViewCell: UITableViewCell {
    
    var name: String?
    var gender: String?
    var age: Int?
    var birthdate: String?
    var status: String?
    
    var nameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var genderLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var ageLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var birthdateLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var statusLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let name = name {
            nameLabel.text = "Name: " + name
        }
        
        if let age = age {
            ageLabel.text = "Age: \(age)"
        }
        
        if let gender = gender {
            genderLabel.text = "Gender: " + gender
        }
        
        if let birthdate = birthdate {
            birthdateLabel.text = "Birthdate: " + birthdate
        }
        
        if let status = status {
            statusLabel.text = "Status: " + status
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        self.addSubview(nameLabel)
        self.addSubview(genderLabel)
        self.addSubview(statusLabel)
        self.addSubview(birthdateLabel)
        self.addSubview(ageLabel)
       
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: genderLabel.topAnchor).isActive = true
        
        genderLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        genderLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor).isActive = true
        genderLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        statusLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        statusLabel.bottomAnchor.constraint(equalTo: birthdateLabel.topAnchor).isActive = true
        statusLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        birthdateLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        birthdateLabel.bottomAnchor.constraint(equalTo: ageLabel.topAnchor).isActive = true
        birthdateLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        ageLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        ageLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        ageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
