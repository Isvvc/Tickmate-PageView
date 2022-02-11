//
//  TrackTableViewController.swift
//  PageView
//
//  Created by Isaac Lyons on 2/10/22.
//

import UIKit

class TrackTableViewController: UITableViewController {
    
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)

        if indexPath.row == 0 {
            cell.textLabel?.text = "Page \(index)"
        } else {
            cell.textLabel?.text = "Row \(indexPath.row)"
        }

        return cell
    }

}
