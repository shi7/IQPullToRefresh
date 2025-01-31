//
//  UIRefreshControl+IQAnimatableRefresh.swift
//  https://github.com/hackiftekhar/IQPullToRefresh
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

extension UIRefreshControl: IQAnimatableRefresh {

    private struct AssociatedKeys {
        static var state = "state"
        static var mode = "mode"
        static var style = "style"
    }

    public var mode: IQRefreshTriggerMode {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.mode) as? IQRefreshTriggerMode ?? .userInteraction
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.mode, newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var refreshStyle: IQRefreshTriggerStyle {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.style) as? IQRefreshTriggerStyle else {
                return .progressCompletion
            }
            return value
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.style, newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var refreshHeight: CGFloat {
        return 170
    }

    public var refreshState: IQAnimatableRefreshState {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.state) as? IQAnimatableRefreshState ?? .unknown
        }
        set {
            let oldValue = refreshState

            guard oldValue != newValue else {
                return
            }

            objc_setAssociatedObject(self, &AssociatedKeys.state, newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            switch newValue {
            case .unknown, .none:
                if isRefreshing {
                    endRefreshing()
                }
            case .pulling, .eligible:
                break
            case .refreshing:
                if !isRefreshing {
                    beginRefreshing()
                }
            }
        }
    }
}
