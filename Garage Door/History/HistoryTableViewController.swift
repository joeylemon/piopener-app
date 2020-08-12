//
//  HistoryTableViewController.swift
//  Garage Door
//
//  Created by Joey Lemon on 6/17/20.
//  Copyright © 2020 Joey Lemon. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    var page = 1
    var loading = false
    var sections = [HistorySection]()
    var refreshController = UIRefreshControl()
    var indicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 75
        self.tableView.tableFooterView = UIView() // Only show bottom separators between cells
        
        // Configure refresh controller (pull down to refresh)
        self.tableView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(refreshHistory), for: .valueChanged)
        refreshController.attributedTitle = NSAttributedString(string: "Loading history ...")
        
        // Configure refresh indicator (loading circle in center)
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        
        self.loadHistory(refresh: false)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].Entries.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].Title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "HistoryTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HistoryTableViewCell  else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        
        // Fetches the appropriate scorecard for the data source layout.
        let entry = sections[indexPath.section].Entries[indexPath.row]
        
        cell.titleLabel.text = "\(entry.Action) by \(entry.PersonName)"
        cell.dateLabel.text = Utils.formatDate(entry.Date)
        cell.rowImage.image = UIImage(systemName: entry.PersonName.lowercased().prefix(1) + ".circle.fill")
        cell.rowImage.tintColor = UIColor(
            red: CGFloat(entry.PersonColor[0])/255.0,
            green: CGFloat(entry.PersonColor[1])/255.0,
            blue: CGFloat(entry.PersonColor[2])/255.0,
            alpha: 1)

        return cell
    }
    
    override open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == sections.count-1 && !loading {
            print("load more data")
            page += 1
            self.loadHistory(refresh: false)
        }
    }
    
    private func showActivityIndicator() {
        indicator.startAnimating()
    }
    
    private func hideActivityIndicator() {
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
    }
    
    @objc private func refreshHistory(_ sender: Any) {
        self.page = 1
        loadHistory(refresh: true)
    }
    
    private func finishLoading() {
        DispatchQueue.main.async {
            self.loading = false
            self.tableView.reloadData()
            self.refreshController.endRefreshing()
            self.hideActivityIndicator()
        }
    }
    
    public func loadHistory(refresh: Bool) {
        self.loading = true
        self.showActivityIndicator()
        Request.send(url: "https://jlemon.org/garage/history/\(page)/\(Auth.TOKEN)") { (response, result) -> () in
            let httpResponse = response as! HTTPURLResponse
            
            // If the API didn't return 200 OK, something went wrong
            if httpResponse.statusCode != 200 {
                self.finishLoading()
                return
            }
            
            let decoder = JSONDecoder()
            do {
                if refresh {
                    self.sections = [HistorySection]()
                }
                
                var result = try decoder.decode([HistorySection].self, from: result!)
                
                // Merge section that already exists
                if let section = self.sections.first(where: { $0.Title == result[0].Title }) {
                    section.Entries += result[0].Entries
                    result.removeFirst()
                }
                
                self.sections += result
                self.finishLoading()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}
