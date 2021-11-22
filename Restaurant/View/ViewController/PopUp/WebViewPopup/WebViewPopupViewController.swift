//
//  WebViewPopupViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/11/22.
//

import UIKit
import WebKit

class WebViewPopupViewController: BaseViewController, Storyboard {
    weak var coordinator: WebViewPopupCoordinator?
    var webViewURL: String?

    @IBOutlet weak var webView: WKWebView!
    @IBAction func clickedCloseButton(_ sender: Any) {
        coordinator?.presenter.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadUrl()
    }

    deinit {
        print("WebViewPopupViewController Deinit")
    }

    private func loadUrl() {
        let url = URL(string: webViewURL ?? "")
        let request = URLRequest(url: url!)

        webView.load(request)
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
}

extension WebViewPopupViewController: WKUIDelegate, WKNavigationDelegate {
    //WKNavigationDelegate 중복적으로 리로드 방지 (iOS 9 이후지원)
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
}
