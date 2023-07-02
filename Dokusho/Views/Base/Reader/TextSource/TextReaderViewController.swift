//
//  TextReaderViewController.swift
//  Dokusho
//
//  Created by Tyler Baker on 4/29/23.
//

import UIKit
import ZIPFoundation

class TextReaderViewController: UIViewController {
    let isLocalSource: Bool
    let chapter: Chapter?
    let source: Source?
    let viewModel = TextReaderViewModel(provider: CoreDataManager.shared)
    
    let currentPageLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    init(isLocalSource: Bool, chapter: Chapter? = nil, source: Source? = nil, number: Int? = nil, document: Archive? = nil) {
        self.chapter = chapter
        self.source = source
        self.isLocalSource = isLocalSource
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = TextPagedReaderViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, source: source!, chapter: chapter!, mangaId: chapter!.mangaId, viewModel: viewModel, navigationController: self.navigationController!)
        
        
        view.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currentPageLabel)
        currentPageLabel.text = "Test"
        configure()

        constrain(vc: vc)
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(
                barButtonSystemItem: .close,
                target: self,
                action: #selector(dismissReaderView)
            )
        ]
        navigationItem.title = "Chapter \(chapter!.chapNumString)"
    }
    
    func configure() {
        viewModel.currentPageObservable.bind { [weak self] newPage in
            self?.currentPageLabel.text = "Page \(newPage) of \(self?.viewModel.totalPagesObservable.value ?? 0)"
        }
        viewModel.isHiddenObservable.bind { [weak self] isHidden in
            self?.navigationController?.navigationBar.isHidden = isHidden
            self?.currentPageLabel.isHidden = isHidden
        }
    }
    
    func constrain(vc: TextPagedReaderViewController) {
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            vc.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            vc.view.bottomAnchor.constraint(equalTo: currentPageLabel.topAnchor),
            currentPageLabel.heightAnchor.constraint(equalToConstant: 60),
            currentPageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            currentPageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            currentPageLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.handleDismiss(source: source!)
    }
    
    @objc func dismissReaderView() {
        dismiss(animated: true)
    }
}




