//
//  DayModeVC.swift
//  FSCalendarSwiftExample
//
//  Created by Tran Han Huy on 2/7/21.
//  Copyright © 2021 wenchao. All rights reserved.
//

import Foundation

final class DayModeVC: UIViewController {
 
    fileprivate weak var calendar: FSCalendar!
    private var calendarHeightConstraint: NSLayoutConstraint!
    private let calendarHeight: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 400 : 300
    
    fileprivate var containerView: UIView!
    fileprivate var pageViewController: DayModePageVC!
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    override func loadView() {
        super.loadView()
        
        navigationItem.rightBarButtonItem  = UIBarButtonItem.init(title: "Toggle", style: .plain, target: self, action: #selector(toggleTouched))
        
        let calendar = FSCalendar()
        calendar.dataSource = self
        calendar.delegate = self
        calendar.select(Date())
        calendar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendar)
        if #available(iOS 9.0, *) {
            calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: self.navigationController!.navigationBar.frame.maxY).isActive = true
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            calendarHeightConstraint = calendar.heightAnchor.constraint(equalToConstant: calendarHeight)
            calendarHeightConstraint.isActive = true
        } else {
            // Fallback on earlier versions
        }
        self.calendar = calendar
        
        containerView = UIView()
        containerView.backgroundColor = .blue
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        if #available(iOS 9.0, *) {
            containerView.topAnchor.constraint(equalTo: calendar.bottomAnchor ).isActive = true
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        } else {
            // Fallback on earlier versions
        }
        
        pageViewController = DayModePageVC(selectedDay: calendar.selectedDate ?? Date())
        pageViewController.dayModePageDelegate = self
        addChildViewController(pageViewController)
        containerView.addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Events for Day Mode"
        
        self.view.backgroundColor = .white
        self.view.addGestureRecognizer(self.scopeGesture)
    }
    
    @objc func toggleTouched() {
        
        calendar.setScope(calendar.scope == .month ? .week : .month, animated: true)
    }
}

// MARK:- FSCalendar
extension DayModeVC: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        pageViewController.currentDate = date
        pageViewController.setupPageViewController()
    }
}

// MARK:- UIGestureRecognizerDelegate
extension DayModeVC: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let velocity = self.scopeGesture.velocity(in: self.view)
        switch self.calendar.scope {
        case .month:
            return velocity.y < 0
        case .week:
            return velocity.y > 0
        }
    }
}

// MARK:- DayModePageDelegate
extension DayModeVC: DayModePageDelegate {
    func swipeDate(date: Date?) {
        calendar.select(date, scrollToDate: true)
    }
    
    func swipeNextDate(date: Date?) {
        
    }
    
    func swipePreviousDate(date: Date?) {
        
    }
}
