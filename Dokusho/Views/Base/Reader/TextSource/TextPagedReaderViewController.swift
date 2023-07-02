//
//  TextPagedReaderViewController.swift
//  Dokusho
//
//  Created by Tyler Baker on 4/30/23.
//

import UIKit

class TextPagedReaderViewController: UIPageViewController {
    let readerNavigationController: UINavigationController
    let source: Source
    let chapter: Chapter
    var pageSize: CGSize = .zero
    let viewModel: TextReaderViewModel
    var pagedViewControllers: [UIViewController] = []

    
    init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil,source: Source, chapter: Chapter, mangaId: String, viewModel: TextReaderViewModel, navigationController: UINavigationController) {
        self.source = source
        self.chapter = chapter
        self.viewModel = viewModel
        self.readerNavigationController = navigationController
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getChapterText(source: source, chapter: chapter)
        delegate = self
        dataSource = self
        loadViewIfNeeded()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        configure()
    }
    func configure() {
        print("configuring:")
        viewModel.getChapterText(source: source, chapter: chapter)
        viewModel.chapterDetailsObservable.bind { [weak self] details in
            print(self?.pageSize)
            let charactersPerLine = self?.viewModel.getCharactersPerLine(pageSize: self?.pageSize ?? .zero)
            print("characters per line is \(charactersPerLine)")
            let lines = self?.viewModel.splitIntoLines(charactersPerLine: charactersPerLine!)
            print("lines are \(lines)")
            self?.viewModel.splitIntoPages(lines: lines ?? [], pageSize: self?.view.bounds.size ?? .zero)
        }
        viewModel.pagesObservable.bind { [weak self] _ in
            self?.setUpPagesViews()
        }
    }
    
    func setUpPagesViews() {
        
        if viewModel.pagesObservable.value != [] {
            for page in viewModel.pagesObservable.value {
                let vc = TextSinglePageViewController(navigationController: readerNavigationController , pageText: page.joined())
                pagedViewControllers.append(vc)
            }
            guard let first = pagedViewControllers.first else {return}
//            if viewModel.currentPageObservable.value != "" {
//                first = pagedViewControllers[Int(viewModel.currentPageObservable.value)! - 1]
//            }
            viewModel.currentPageObservable.value = 1
            setViewControllers([first], direction: .forward, animated: true)
        }
    }

}

// MARK: PageController Delegate and DataSource
extension TextPagedReaderViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // Switched before and after to make rtl reading work. TODO: Add option to change direction.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pagedViewControllers.firstIndex(of: viewController), index < (pagedViewControllers.count - 1) else {return nil}
        let after = index + 1
        return pagedViewControllers[after]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pagedViewControllers.firstIndex(of: viewController), index > 0 else {return nil}
        let before = index - 1
        return pagedViewControllers[before]
        
    }
      func pageViewController(_ pageViewController: UIPageViewController,
                              didFinishAnimating finished: Bool,
                              previousViewControllers: [UIViewController],
                              transitionCompleted completed: Bool) {
          guard completed,
                let currentVC = pageViewController.viewControllers?.first,
                let index = pagedViewControllers.firstIndex(of: currentVC) else { return }
          viewModel.currentPageObservable.value  = index + 1

      }
}
