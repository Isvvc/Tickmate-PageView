//
//  TrackTableViewController.swift
//  PageView
//
//  Created by Elaine Lyons on 2/10/22.
//

import UIKit
import Combine

class Track: NSObject {
    var name: String
    var color: UIColor
    
    init(name: String, color: UIColor) {
        self.name = name
        self.color = color
    }
}

class TrackController {
    static var shared = TrackController()
    
    var tracks: [Track] = [
        Track(name: "Brush teeth", color: .systemBlue),
        Track(name: "Read", color: .systemYellow)
    ]
}

class TrackTableViewController: UITableViewController {
    
    //MARK: Static
    
    static let days = 100
    
    //MARK: Properties
    
    var index = 0
    var scrollController: ScrollController = .shared
    private var initialized = false
    
    private var pagingSubscriber: AnyCancellable?
    
    //MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(DayTableViewCell.self, forCellReuseIdentifier: "DayCell")
        tableView.delegate = self
        tableView.sectionHeaderTopPadding = 0
        scrollToDelegate()
        
        pagingSubscriber = scrollController.$isPaging.sink { [weak self] isPaging in
            guard let self = self else { return }
            
            if isPaging {
                self.tableView.showsVerticalScrollIndicator = false
            } else {
                // We only want to flash the scroll bar if the table is scrolled above the bottom.
                //TODO: Test this on a square screen with no Safe Area
                // Could even potentially add a bit more tolorance to this
                // so it doesn't flash them when only scrolled up a bit.
                //Note: If there's an added option to flip so today is at the top, make sure to adjust this
                let position = self.tableView.contentSize.height - self.tableView.bounds.size.height + self.tableView.contentInset.bottom
                if self.tableView.contentOffset.y < position {
                    self.tableView.showsVerticalScrollIndicator = true
                    self.tableView.flashScrollIndicators()
                }
                // If we set showsVerticalScrollIndicator to true here it'll show it, so leave it off
                // until the user actually starts scrolling again (see scrollViewWillBeginDragging).
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToDelegate()
    }
    
    //MARK: Private
    
    private func scrollToDelegate() {
        guard !tableView.isDragging, !tableView.isDecelerating else { return }
        
        guard scrollController.initialized else {
            return scrollToBottom()
        }
        
        let scrollPosition = scrollController.contentOffset
        print(scrollPosition, "scrollToDelegate")
        self.tableView.contentOffset = scrollPosition
    }
    
    private func scrollToBottom(animated: Bool = false) {
        let indexPath = IndexPath(row: Self.days-1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
        if initialized {
            scrollController.contentOffset = tableView.contentOffset
            print(scrollController.contentOffset, "scrollToBottom")
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath)
        if let dayRow = cell as? DayTableViewCell {
            dayRow.configure(with: TrackController.shared.tracks)
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
        print(scrollView.contentOffset,
              "scrollViewDidEndDecelerating",
              "contentSize.height - bounds.size.height + contentInset.bottom",
              scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        // Avoid uncessesary calls to setter as that seems to flash it
        if !tableView.showsVerticalScrollIndicator {
            tableView.showsVerticalScrollIndicator = true
        }
        scrollController.initialized = true
        initialized = true
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
