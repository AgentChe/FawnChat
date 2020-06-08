//
//  PageViewController.swift
//

import UIKit

final class PageViewController: UIPageViewController {
    private lazy var pageControl = makePageControl()
    
    private var orderedViewControllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
}

// MARK: Make

extension PageViewController {
    static func make(viewControllers: [UIViewController]) -> PageViewController {
        let vc = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        vc.orderedViewControllers = viewControllers
        return vc
    }
}

// MARK: MainViewControllerDelegate

extension PageViewController: MainViewControllerDelegate {
    func tapOnChats() {
        guard
            let currentViewController = self.viewControllers?.first,
            let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController)
        else {
            return
        }
        
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
    }
    
    func tapOnSearch() {
        guard
            let currentViewController = self.viewControllers?.first,
            let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController)
        else {
            return
        }
        
        setViewControllers([previousViewController], direction: .reverse, animated: true, completion: nil)
    }
}

// MARK: UIPageViewControllerDelegate {

extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard
            let vc = viewControllers?.first,
            let index = orderedViewControllers.firstIndex(of: vc)
        else {
            return
        }
        
        pageControl.currentPage = index
    }
}

// MARK: UIPageViewControllerDataSource

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController == orderedViewControllers.last {
            return orderedViewControllers.first
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController == orderedViewControllers.first {
            return orderedViewControllers.last
        }
        
        return nil
    }
}

// MARK: Lazy initialization

private extension PageViewController {
    func makePageControl() -> UIPageControl {
        let view = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        view.numberOfPages = orderedViewControllers.count
        view.currentPage = 0
        view.tintColor = UIColor.black
        view.pageIndicatorTintColor = UIColor.white
        view.currentPageIndicatorTintColor = UIColor.black
        return view
    }
}
