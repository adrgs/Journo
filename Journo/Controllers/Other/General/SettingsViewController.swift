//
//  SettingsViewController.swift
//  Journo
//
//  Created by Dragos Albastroiu on 07.05.2022.
//

import UIKit

struct SettingCellModel {
    let title: String
    let handler: (() -> Void)
}

final class SettingsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    private var data = [[SettingCellModel]]()
    
    private func configureModels() {
        let section = [
            SettingCellModel(title:"Log Out") { [weak self] in
                self?.didClickLogOut()
            }
        ]
        data.append(section)
    }
    
    private func didClickLogOut() {
        let actionSheet = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title:"Log Out", style: .destructive, handler: {_ in
            
            AuthManager.shared.logOut(completion: {success in
                DispatchQueue.main.async {
                    if success {
                        let loginViewController = LoginViewController()
                        loginViewController.modalPresentationStyle = .fullScreen
                        self.present(loginViewController, animated: true, completion: {
                            self.navigationController?.popToRootViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        })
                    } else {
                        let alert = UIAlertController(title: "Log Out Error", message: "Try again", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title:"Dismiss", style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            })
            
        }))
        
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        
        present(actionSheet, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureModels()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.section][indexPath.row].handler()
    }
}
