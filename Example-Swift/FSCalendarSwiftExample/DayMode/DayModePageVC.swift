//
//  DayModePageVC.swift
//  FSCalendarSwiftExample
//
//  Created by Tran Han Huy on 2/10/21.
//  Copyright © 2021 wenchao. All rights reserved.
//

import Foundation

protocol DayModePageDelegate: NSObject {
    func swipeDate(date: Date?)
    func swipeNextDate(date: Date?)
    func swipePreviousDate(date: Date?)
}

final class DayModePageVC: UIPageViewController {
    
    var currentDate = Date()
    var gregorian: Calendar!
    weak var dayModePageDelegate: DayModePageDelegate?
    
    var nextDay: Date {
        return self.gregorian.date(byAdding: Calendar.Component.day, value: 1, to: currentDate) ?? currentDate
    }
    var previousDay: Date {
        return self.gregorian.date(byAdding: Calendar.Component.day, value: -1, to: currentDate) ?? currentDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    init(selectedDay: Date) {
        self.gregorian = Calendar.init(identifier: .gregorian)
        self.currentDate = selectedDay
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        dataSource = self
        delegate = self
        view.backgroundColor = .black
        setupPageViewController()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func setupPageViewController() {
        setViewControllers([createContentViewController(currentDate)], direction: .forward, animated: true, completion: nil)
    }
    
    func createContentViewController(_ date: Date) -> UIViewController {
        let vc = DayModeContentVC()
        vc.date = date
        return vc
    }
    
    func getCurrentViewController() -> DayModeContentVC? {
        return viewControllers?.first as? DayModeContentVC
    }
}

extension DayModePageVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return createContentViewController(self.previousDay)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return createContentViewController(self.nextDay)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished, let delegate = dayModePageDelegate, let vc = getCurrentViewController() {
            currentDate = vc.date ?? currentDate
            delegate.swipeDate(date: vc.date)
        }
    }
}
