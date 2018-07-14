//
//  InfinityScrollController.swift
//  news-proj
//
//  Created by Евгений Иванов on 14.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation
import UIKit

fileprivate var KVOContext = "InfiniteScrollingControllerKVOContext"

fileprivate let LoadingViewHeight: CGFloat = 60

fileprivate enum InfiniteScrollingControllerState {
    case animating
    case stopped
}

class InfiniteScrollingController: NSObject {
    
    var infinityScrollingEnabled = true
    
    fileprivate var state = InfiniteScrollingControllerState.stopped
    
    fileprivate var originalBottomInset: CGFloat = 0.0
    fileprivate var scrollView: UIScrollView! {
        
        didSet {
            originalBottomInset = scrollView.contentInset.bottom
            scrollView.addSubview(loadingView)
            addScrollViewObserving(scrollView)
            adjustLoadingViewFrame()
        }
        
    }
    fileprivate lazy var loadingView: UIView = {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: LoadingViewHeight))
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        
        view.isHidden = true
        
        return view
        
    }()
    
    // MARK: - Class constructor

    public static func infiniteScrollingController(on scrollView: UIScrollView) -> InfiniteScrollingController {
        let infinityScrollController = InfiniteScrollingController()
        infinityScrollController.scrollView = scrollView
        return infinityScrollController
    }
    
    deinit {
        removeScrollViewObserving(scrollView)
    }
    
    // MARK: - Public
    
    public func startAnimating() {
        
        guard infinityScrollingEnabled, state != .animating, scrollView.contentSize.height > 0 else { return }
        
        state = .animating
        adjustContentInset(for: state)
        loadingView.isHidden = false
        print("loading view frame: \(loadingView.frame)")
        
    }
    
    public func stopAnimation() {
        
        guard state != .stopped else { return }
        
        state = .stopped
        adjustContentInset(for: state)
        loadingView.isHidden = true
        
    }
    
    // MARK: - Observing
    
    func addScrollViewObserving(_ scrollView: UIScrollView?) {
        scrollView?.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: .new, context: &KVOContext)
        scrollView?.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentInset), options: .new, context: &KVOContext)
        scrollView?.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: .new, context: &KVOContext)
    }
    
    func removeScrollViewObserving(_ scrollView: UIScrollView?) {
        scrollView?.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), context: &KVOContext)
        scrollView?.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentInset), context: &KVOContext)
        scrollView?.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), context: &KVOContext)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard context == &KVOContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        guard let keyPath = keyPath else { return }
        
        switch keyPath {
            
        case #keyPath(UIScrollView.contentSize):
            adjustLoadingViewFrame()
            
        case #keyPath(UIScrollView.contentInset):

            if let newContentInset = change?[NSKeyValueChangeKey.newKey] as? UIEdgeInsets, newContentInset.bottom != bottomInset(for: state) {
                
                originalBottomInset = newContentInset.bottom
                adjustLoadingViewFrame()
                
                if state == .animating {
                    scrollView.contentInset.bottom = originalBottomInset + LoadingViewHeight
                }
                
            }
            
        case #keyPath(UIScrollView.contentOffset):
            
            if let change = change, let offset = change[NSKeyValueChangeKey.newKey] as? CGPoint {
                
                let contentHeight = scrollView.contentSize.height
                
                if offset.y > contentHeight - scrollView.frame.height {
                    startAnimating()
                }
                
            }
            adjustLoadingViewFrame()
            
        default:
            break
        }
        
    }
    
    // MARK: - Private
    fileprivate func adjustLoadingViewFrame() {
        
        var frame = loadingView.frame
        frame.origin.y = scrollView.contentSize.height + originalBottomInset
        
        loadingView.frame = frame
        
    }
    
    fileprivate func adjustContentInset(for state: InfiniteScrollingControllerState) {
        
        var contentInset = scrollView.contentInset
        contentInset.bottom = bottomInset(for: state)
        
        scrollView.contentInset = contentInset
        
    }
    
    fileprivate func bottomInset(for state: InfiniteScrollingControllerState) -> CGFloat {
        
        switch state {
        case .animating:
            return originalBottomInset + LoadingViewHeight
        default:
            return originalBottomInset
        }
        
    }
    
}
