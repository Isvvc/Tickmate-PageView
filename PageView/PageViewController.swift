//
//  PageViewController.swift
//  PageView
//
//  Created by Isaac Lyons on 2/10/22.
//

import UIKit

class PageViewController: UIPageViewController, TrackTableViewDelegate {
    
    var scrollPosition: CGPoint = .zero
    private var page: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
        
        if let initialVC = createTrackVC(for: page) {
            setViewControllers([initialVC], direction: .forward, animated: true)
        }
        
//        if let scrollView = view.subviews.first(where: { (view: UIView) -> Bool in
//            guard let scrollView = view as UIScrollView else { return false }
//            return scrollView.direc
//        })
        
//        if let scrollView = view.subviews.first(where: { $0 is UIScrollView && !($0 is UITableView) }) {
//            print(scrollView)
//            scrollView.delegate = self
//        }
        
        _ = view.subviews.first { (view: UIView) -> Bool in
            if let scrollView = view as? UIScrollView,
               !(scrollView is UITableView) {
                print(scrollView)
                scrollView.delegate = self
                return true
            }
            return false
        }
    }
    
    private func createTrackVC(for index: Int) -> TrackTableViewController? {
        guard let trackVC = storyboard?.instantiateViewController(withIdentifier: "TrackTable") as? TrackTableViewController else { return nil }
        
        trackVC.index = index
        trackVC.delegate = self
        
        return trackVC
    }
    
    private func index(of viewController: UIViewController) -> Int? {
        (viewController as? TrackTableViewController)?.index
    }
    
    private func trackVC(at index: Int) -> TrackTableViewController? {
        viewControllers?.compactMap { $0 as? TrackTableViewController }
        .first { $0.index == index }
    }

}

//MARK: Page View Controller Data Source

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        createTrackVC(for: (index(of: viewController) ?? page) - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        createTrackVC(for: (index(of: viewController) ?? page) + 1)
    }
}

//MARK: Page View Controller Delegate

extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let trackVC = previousViewControllers.first as? TrackTableViewController else { return }
        page = trackVC.index
    }
}

//MARK: Scroll View Delegate

extension PageViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        trackVC(at: page)?.tableView.flashScrollIndicators()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.frame.width - scrollView.contentOffset.x
        if offset >= 0 {
            if let trackVC = trackVC(at: page) {
                trackVC.tableView.automaticallyAdjustsScrollIndicatorInsets = false
                trackVC.tableView.verticalScrollIndicatorInsets = .init(top: 0, left: 0, bottom: 0, right: offset)
                print(offset)
            }
        } else {
            if let nextTrackVC = trackVC(at: page + 1) {
                nextTrackVC.tableView.verticalScrollIndicatorInsets = .init(top: 0, left: 0, bottom: 0, right: -scrollView.contentOffset.x)
            }
        }
    }
}
