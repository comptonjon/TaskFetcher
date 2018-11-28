//
//  ViewController.swift
//  TaskFetcher
//
//  Created by Jonathan Compton on 11/27/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//



import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var noUsersLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var users: [LocalUser] = [LocalUser]()
    var selectedUser: LocalUser!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 75
        if users.count > 0 {noUsersLabel.isHidden = true}
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUsers()
        if users.count > 0 {noUsersLabel.isHidden = true}
    }
    
    func fetchUsers() {
        users = CDService.shared.fetchUsers()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLoginSignupVC" {
            let destinationVC = segue.destination as! LoginSignupVC
            destinationVC.user = selectedUser
            destinationVC.delegate = self
        }
        
        if segue.identifier == "newUserToLogin" {
            let destinationVC = segue.destination as! LoginSignupVC
            destinationVC.delegate = self
        }
    }
    @IBAction func addUserTapped(_ sender: Any) {
        performSegue(withIdentifier: "newUserToLogin", sender: self)
        
    }
    
}

extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.nameLabel.text = user.name
        cell.emailLabel.text = user.email
        return cell
    }
}

extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        selectedUser = users[indexPath.row]
        SessionManager.shared.currentUser = selectedUser
        performSegue(withIdentifier: "toLoginSignupVC", sender: self)
    }
}

extension HomeVC: LoginVCDelegate {
    func signUpSuccessful() {
        print("Got to the delegate function")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.performSegue(withIdentifier: "toMasterVC2", sender: self)
        }
        
    }
    
    
}

