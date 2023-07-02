//
//  LibraryViewController.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/29/23.
//

import UIKit

class LibraryViewController: UIViewController {
    
    let labelView: UILabel = {
        let label = UILabel()
        label.text = "Hello world!"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Library"
        view.addSubview(labelView)
        labelView.pin(to: view)        
    }

}
