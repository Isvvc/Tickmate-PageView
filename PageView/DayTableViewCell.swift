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
        button.layer.cornerRadius = 8
        button.tintColor = .white
        
        stackView.addArrangedSubview(button)
        self.button = button
        
        let tempButton = UIButton(primaryAction: UIAction { action in
            print("lol")
        })
        tempButton.backgroundColor = UIColor.systemBlue
        tempButton.layer.cornerRadius = 8
        stackView.addArrangedSubview(tempButton)
    }

    func configure(with title: String) {
        button?.setTitle(title, for: .normal)
    }

}
