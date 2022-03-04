//
//  TrackTableViewController.swift
//  PageView
//
//  Created by Elaine Lyons on 2/10/22.
//

import UIKit
import Combine

class TrackTableViewController: UITableViewController {
    
    static let days = 100
    
    var index = 0
    var scrollController: ScrollController = .shared
    
    private var pagingSubscriber: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.sectionHeaderTopPadding = 0
        scrollToDelegate()
        
        pagingSubscriber = scrollController.$isPaging.sink { [weak self] isPaging in
            self?.tableView.showsVerticalScrollIndicator = !isPaging
            if !isPaging {
                self?.tableView.flashScrollIndicators()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToDelegate()
    }
    
    private func scrollToDelegate() {
        guard !tableView.isDragging, !tableView.isDecelerating else { return }
        let scrollPosition = scrollController.contentOffset
        print(scrollPosition, "scrollToDelegate")
        self.tableView.contentOffset = scrollPosition
    }
    
    private func scrollToBottom(animated: Bool = false) {
        let indexPath = IndexPath(row: Self.days-1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
        scrollController.contentOffset = tableView.contentOffset
        print(scrollController.contentOffset, "scrollToBottom")
    }

    // MARK: Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Self.days
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Page \(index)"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        if let dayRow = cell as? DayTableViewCell {
            dayRow.configure(with: "Page \(index + 1)\t\tRow \(indexPath.row)")
        }

        scrollToDelegate()
        return cell
    }
    
    //MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        44
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    //MARK: Scroll View Delegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // This function gets called on view load with a value of zero,
        // resetting the scroll position every time a new screen loads.
        // This guard prevents that. The end functions below allow it
        // to still sync position when it is 0.
        guard scrollView.contentOffset != .zero,
              !scrollController.isPaging else { return }
        scrollController.contentOffset = scrollView.contentOffset
        print(scrollView.contentOffset, "scrollViewDidScroll")
    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollController.contentOffset = scrollView.contentOffset
        print(scrollView.contentOffset, "scrollViewDidEndScrollingAnimation")
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollController.contentOffset = scrollView.contentOffset
        print(scrollView.contentOffset, "scrollViewDidEndDecelerating")
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollController.contentOffset = scrollView.contentOffset
        print(scrollView.contentOffset, "scrollViewDidEndDragging")
    }
    
    override func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        print("scroll to top")
        // Scroll to bottom instead
        scrollToBottom(animated: true)
        return false
    }

}
