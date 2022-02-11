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
        
        guard let initialVC = trackVC(for: page) else { return }
        setViewControllers([initialVC], direction: .forward, animated: true)
    }
    
    private func trackVC(for index: Int) -> TrackTableViewController? {
        guard let trackVC = storyboard?.instantiateViewController(withIdentifier: "TrackTable") as? TrackTableViewController else { return nil }
        
        trackVC.index = index
        trackVC.delegate = self
        
        return trackVC
    }
    
    private func index(of viewController: UIViewController) -> Int? {
        (viewController as? TrackTableViewController)?.index
    }

}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        trackVC(for: (index(of: viewController) ?? page) - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        trackVC(for: (index(of: viewController) ?? page) + 1)
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let trackVC = previousViewControllers.first as? TrackTableViewController else { return }
        page = trackVC.index
    }
}
