//
//  TextSinglePageViewController.swift
//  Dokusho
//
//  Created by Tyler Baker on 4/30/23.
//

import UIKit


class TextSinglePageViewController: UIViewController {
    var readerNavigationController: UINavigationController
    let pageText: String
    var isHidden: Bool = false
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    init(navigationController: UINavigationController, pageText: String ) {
        self.readerNavigationController = navigationController
        self.pageText = pageText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    lazy var hidingTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        let doubleTap = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(doubleTap)
        doubleTap.numberOfTapsRequired = 2
        tap.numberOfTapsRequired = 1
        tap.require(toFail: doubleTap)
        
        return tap
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(hidingTap)
        view.addSubview(textView)
        configure()
    }
    func configure() {
        textView.text = pageText
        textView.pinToSafeArea(to: view)
    }

}


extension TextSinglePageViewController {
    
    @objc func handleSingleTap(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 10) {
            //            self.readerNavigationController.navigationBar.isHidden.toggle()
            //            self.currentPageLabel.isHidden.toggle()
            self.isHidden.toggle()
            
        }
        
    }
}

