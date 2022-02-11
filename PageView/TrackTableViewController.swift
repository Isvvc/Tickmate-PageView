//
//  TrackTableViewController.swift
//  PageView
//
//  Created by Isaac Lyons on 2/10/22.
//

import UIKit

protocol TrackTableViewDelegate: AnyObject {
    var scrollPosition: CGPoint { get set }
}

class TrackTableViewController: UITableViewController {
    
    var index = 0
    weak var delegate: TrackTableViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        scrollToDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToDelegate()
    }
    
    private func scrollToDelegate() {
        guard !tableView.isDragging, !tableView.isDecelerating,
              let scrollPosition = delegate?.scrollPosition else { return }
        print(scrollPosition)
        self.tableView.contentOffset = scrollPosition
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        101
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Page \(index)"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)

        if indexPath.row == 0 {
            cell.textLabel?.text = "Page \(index)"
            cell.textLabel?.font = .boldSystemFont(ofSize: 17)
        } else {
            cell.textLabel?.text = "Page \(index)\t\tRow \(indexPath.row)"
            cell.textLabel?.font = .systemFont(ofSize: 17)
        }

        scrollToDelegate()
        return cell
    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.scrollPosition = scrollView.contentOffset
        print(scrollView.contentOffset)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollPosition = scrollView.contentOffset
        print(scrollView.contentOffset)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.scrollPosition = scrollView.contentOffset
        print(scrollView.contentOffset)
    }

}
