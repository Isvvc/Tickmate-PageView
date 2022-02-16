//
//  ViewController.swift
//  PageView
//
//  Created by Elaine Lyons on 2/10/22.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shadowView: UIView!
    
    var scrollController: ScrollController = .shared
    private var subscribers = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up shadow
        shadowView.layer.shadowRadius = 4
        //shadowView.layer.shadowOpacity = 0.5
        shadowView.clipsToBounds = false
        
        // Keep shadow on the right
        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: 0, y: 0, width: tableView.frame.width * 2, height: tableView.frame.height * 2)
        
        shadowView.layer.mask = maskLayer
        
        // Sync scroll position
        let scrollSubscriber = scrollController.$contentOffset.sink { [weak self] contentOffset in
            self?.tableView.contentOffset = contentOffset
        }
        
        let pagingSubscriber = scrollController.$isPaging.sink { [weak self] isPaging in
            UIView.animate(withDuration: 0.25) {
                self?.shadowView.layer.shadowOpacity = isPaging ? 0.5 : 0
            }
        }
        
        subscribers = [scrollSubscriber, pagingSubscriber]
    }

}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        100
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Title"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath)
        cell.textLabel?.text = "Day \(indexPath.row)"
        return cell
    }
}

extension ViewController: UITableViewDelegate {}
