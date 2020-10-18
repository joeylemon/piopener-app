//
//  SettingsViewController.swift
//  Garage Door
//
//  Created by Joey Lemon on 10/17/20.
//  Copyright © 2020 Joey Lemon. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    var refreshController = UIRefreshControl()
    
    var sections = [SettingsSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 76
        self.tableView.tableFooterView = nil
        
        // Configure refresh controller (pull down to refresh)
        self.tableView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(refreshSettings), for: .valueChanged)
        refreshController.attributedTitle = NSAttributedString(string: "Loading settings ...")
        
        self.loadSettings()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].Entries.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].Name
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "SettingsCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SettingsCell else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        
        // Fetches the appropriate scorecard for the data source layout.
        let entry = sections[indexPath.section].Entries[indexPath.row]
        
        cell.settingName.text = entry.SettingName
        cell.settingDescription.text = entry.Description
        cell.settingSwitch.isOn = entry.Enabled
        cell.settingKey = entry.SettingKey

        return cell
    }
    
    @objc private func refreshSettings(_ sender: Any) {
        loadSettings()
    }
    
    private func finishLoading() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshController.endRefreshing()
        }
    }
    
    public func loadSettings() {
        print("load settings")
        Request.send(url: "https://jlemon.org/garage/settings/get/\(Auth.TOKEN)") { (response, result) -> () in
            let httpResponse = response as! HTTPURLResponse
            
            // If the API didn't return 200 OK, something went wrong
            if httpResponse.statusCode != 200 {
                self.finishLoading()
                return
            }
            
            let decoder = JSONDecoder()
            do {
                self.sections = try decoder.decode([SettingsSection].self, from: result!)
                self.finishLoading()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
