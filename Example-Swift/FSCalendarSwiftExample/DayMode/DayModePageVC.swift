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
}

extension DayModePageVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // Khởi tạo Content View Controller dựa vào date
    func createContentViewController(_ date: Date) -> UIViewController {
        let vc = DayModeContentVC()
        vc.date = date
        return vc
    }
    
    // Lấy View Controller đang hiện thị ở PageViewController
    func getCurrentViewController() -> DayModeContentVC? {
        return viewControllers?.first as? DayModeContentVC
    }
    
    // DataSource & Delegate - Khởi tạo Content của ngày hôm qua
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return createContentViewController(self.previousDay)
    }
    
    // DataSource & Delegate - Khởi tạo Content của ngày kế tiếp
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return createContentViewController(self.nextDay)
    }
    
    // DataSource & Delegate - Sự kiện sau khi swipe thành công, sẽ trả dữ liệu về trang DayModeViewController để xử lý các mong muốn.
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished, let delegate = dayModePageDelegate, let vc = getCurrentViewController() {
            currentDate = vc.date ?? currentDate
            delegate.swipeDate(date: vc.date)
        }
    }
}
