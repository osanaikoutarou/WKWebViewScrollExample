//
//  ViewController.swift
//  WKWebViewScrollExample
//
//  Created by 長内幸太郎 on 2019/11/15.
//  Copyright © 2019 長内幸太郎. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    var scrollStartPoint: ScrollStartPoint = ScrollStartPoint(direction: .none, point: .zero)
    var prevScrollViewContentOffset: CGPoint = .zero
    
//    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var wkWebView: WKWebView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var toptop: NSLayoutConstraint!
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        wkWebView.load(URLRequest(url: one))
        
//        self.navigationController?.hidesBarsOnSwipe = true
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        view.addGestureRecognizer(pan)
        pan.delegate = self
        
        wkWebView.scrollView.delegate = self
        
//        animator = UIViewPropertyAnimator(duration: 5.0, curve: .linear) {
//            self.navigationController?.setNavigationBarHidden(true, animated: true)
//            self.navigationController?.navigationBar.alpha = -5
//            self.toptop.constant = 0
//            self.view.layoutIfNeeded()
//        }
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        wkWebView.scrollView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        print("ほげ")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.endRefreshing()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.wkWebView.reload()
            
        }
        
    }
    
    enum VerticalPanDirection {
        case up
        case down
        case none
        
        static func detect(translation: CGPoint) -> VerticalPanDirection {
            if translation.y < -20 {
                return .up
            }
            if translation.y > 20 {
                return .down
            }
            return .none
        }
    }
    
    var isViewDidAppear: Bool = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        isViewDidAppear = true
        
        
    }
    
    var animator: UIViewPropertyAnimator!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if !animator.isRunning {
////            animator.isRunning
//        }
        animator = UIViewPropertyAnimator(duration: 5.0, curve: .linear) {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
//            self.navigationController?.navigationBar.alpha = -5
            self.toptop.constant = 0
            self.view.layoutIfNeeded()
        }
        
        animator.addCompletion { (p) in
            print("おわったー")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        animator.stopAnimation(false)
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
//        super.viewDidDisappear(animated)
//    }
    
    @objc func willEnterForegroundNotification(notification: NSNotification) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.alpha = 1
        self.toptop.constant = 44
    }
    
    @objc func didPan(gesture: UIPanGestureRecognizer) {
        let a = VerticalPanDirection.detect(translation: gesture.translation(in: view))
        var t = gesture.translation(in: view)
        var v = gesture.velocity(in: view)
//        print(a)
////        print("v + \(v.y)")
//        switch a {
//        case .up:
//            self.navigationController?.setNavigationBarHidden(true, animated: true)
//        case .down:
//            self.navigationController?.setNavigationBarHidden(false, animated: true)
//        default:
//            break
//        }
        
//        let movedFromStart = scrollView.contentOffset.y - scrollStartPoint.point.y
        
//        prevScrollViewContentOffset = scrollView.contentOffset
        
//        setAnimatorTranctionComplete(value: -t.y/2.0)
        
        
        
        
//        self.navigationController?.navigationBar.transform = CGAffineTransform(translationX: 0, y: gesture.translation(in: view).y)
        
//        let fractionComplete = gesture.translation(in: view).y * 0.0005 * -1.0
//        print(fractionComplete)
//        self.animator.fractionComplete = fractionComplete
    }
    
    
    var url: URL = URL(string: "https://stg2-app-mdpr.freetls.fastly.net/top")!
    var yahoo: URL = URL(string: "https://m.yahoo.co.jp/")!
    var netnative: URL = URL(string: "https://net-native.net/")!
    var hatena: URL = URL(string: "https://www.hatena.ne.jp/")!
    var one: URL = URL(string: "https://ja.wikipedia.org/wiki/%E3%83%AF%E3%83%B3%E3%83%91%E3%83%B3%E3%83%9E%E3%83%B3")!

}

enum ScrollStartPointDirection {
    case up     // yと逆方向
    case down   // y方向
    case none   // 0
    
    static func detect(movedY: CGFloat) -> ScrollStartPointDirection {
        if movedY > 0 {
            return .down
        }
        if movedY < 0 {
            return .up
        }
        return .none
    }
 
}
struct ScrollStartPoint {
    var direction: ScrollStartPointDirection
    var point: CGPoint
}
//var scrollStartPoint: ScrollStartPoint = ScrollStartPoint(direction: .up, point: .zero)

extension ViewController {
    func scrollViewDidScrollFromStart(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            return
        }
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.size.height {
            return
        }
        let movedY = scrollView.contentOffset.y - prevScrollViewContentOffset.y
        print(movedY)
        
        let direction = ScrollStartPointDirection.detect(movedY: movedY)
        
        if direction != scrollStartPoint.direction {
            scrollStartPoint.direction = direction
            scrollStartPoint.point = scrollView.contentOffset
        }
        
        let movedFromStart = scrollView.contentOffset.y - scrollStartPoint.point.y
        
        prevScrollViewContentOffset = scrollView.contentOffset
        
        setAnimatorTranctionComplete(value: movedFromStart)
    }
}

extension ViewController {
    func setAnimatorTranctionComplete(value: CGFloat) {
        let expected = self.animator.fractionComplete + value / (topBarHeight * 10)
        let maxFractionComplete = (1.0 - statusBarHeight/topBarHeight)
        let minFractionComplete: CGFloat = 0
        
        let result = max(min(expected, maxFractionComplete), minFractionComplete)
        print("result \(result)")
        
        self.animator.fractionComplete = result
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isViewDidAppear else {
            return
        }

        scrollViewDidScrollFromStart(scrollView)

//        let fractionComplete = scrollView.contentOffset.y / topBarHeight
//        let maxFractionComplete = (1.0 - statusBarHeight/topBarHeight)
//        print(fractionComplete)
//        self.animator.fractionComplete = min(fractionComplete, maxFractionComplete)
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    // here are those protocol methods with Swift syntax
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
}

class HogeViewController: UIViewController {
    
}

class HogeTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let ho = self.storyboard!.instantiateViewController(identifier: "HogeViewController")
//
//        viewControllers?.append(ho)
        
    }
}

//extension ViewController: UITableViewDelegate,UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 100
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return UITableViewCell(style: .default, reuseIdentifier: "_")
//    }
//}





////

extension UIViewController {
    var navigationBarHeight: CGFloat {
        return navigationController?.navigationBar.bounds.height ?? 0
    }
    ///
    var topBarHeight: CGFloat {
        return statusBarHeight + navigationBarHeight
    }
}
extension UIViewController {
    var statusBarHeight: CGFloat {
        if #available(iOS 13, *) {
            return view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        }
        else {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }
}
extension UIApplication {
    var safeAreaInsets: UIEdgeInsets {
        return currentWindow?.safeAreaInsets ?? .zero
    }
}

extension UIApplication {
    var currentWindow: UIWindow? {
        if #available(iOS 13, *) {
            if let window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first {
                return window
            }
        }
        else if #available(iOS 11, *) {
            if let keyWindow = UIApplication.shared.keyWindow {
                return keyWindow
            }
        }
        if let uiApplicationDelegate = UIApplication.shared.delegate,
            let window = uiApplicationDelegate.window {
            return window
        }
        return nil
    }
}
