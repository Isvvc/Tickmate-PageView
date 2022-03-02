//
//  DayTableViewCell.swift
//  PageView
//
//  Created by Isaac Lyons on 2/17/22.
//

import UIKit

class DayTableViewCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    
    private var button: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stackView.alignment = .center
        
        let button = UIButton(primaryAction: UIAction { action in
            print(action)
        })
        button.setTitle("Button", for: .normal)
        button.backgroundColor = UIColor.systemOrange
        button.layer.cornerRadius = 4
        button.tintColor = .white
        
        stackView.addArrangedSubview(button)
        self.button = button
        
        let tempButton = UIButton(primaryAction: UIAction { action in
            print("lol")
        })
        tempButton.backgroundColor = UIColor.systemBlue
        tempButton.layer.cornerRadius = 4
        stackView.addArrangedSubview(tempButton)
        
        NSLayoutConstraint.activate([
            // -12 matches the old SwiftUI Tickmate
            button.heightAnchor.constraint(equalTo: stackView.heightAnchor, constant: -10),
            tempButton.heightAnchor.constraint(equalTo: stackView.heightAnchor, constant: -10)
        ])
    }

    func configure(with title: String) {
        button?.setTitle(title, for: .normal)
    }

}
