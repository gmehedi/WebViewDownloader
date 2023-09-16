//
//  ViewController.swift
//  WkWebViewTest
//
//  Created by M M Mehedi Hasan
//

import UIKit
import WebKit
import WKDownloadHelper

class ViewController: UIViewController {
    var webView:WKWebView!
    //var helper:WKWebviewDownloadHelper!
    var downloadHelper: WKDownloadHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = WKWebView(frame: self.view.frame)
        self.view.addSubview(webView)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let mimeTypes = [MimeType(type: "ms-excel", fileExtension: "jpg"),
                         MimeType(type: "pdf", fileExtension: "png")]
        //helper = WKWebviewDownloadHelper(webView: webView, mimeTypes:mimeTypes, delegate: self)
        downloadHelper = WKDownloadHelper(webView: webView, supportedMimeTypes: mimeTypes, delegate: self)

        let request = URLRequest(url: URL(string: "https://we.tl/t-zs3JHwU03I")!)
        webView.load(request)
        self.webView = webView
        self.navigationItem.title = "My Page"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: nil, action: nil)
        
    }
}

// OLD implementation
//extension ViewController: WKWebViewDownloadHelperDelegate {
//    func fileDownloadedAtURL(url: URL) {
//        DispatchQueue.main.async {
//            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
//            activityVC.popoverPresentationController?.sourceView = self.view
//            activityVC.popoverPresentationController?.sourceRect = self.view.frame
//            activityVC.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
//            self.present(activityVC, animated: true, completion: nil)
//        }
//    }
//}

extension ViewController: WKDownloadHelperDelegate {
    func canNavigate(toUrl: URL) -> Bool {
        true
    }
    
    func didFailDownloadingFile(error: Error) {
        print("error while downloading file \(error)")
    }
    
    func didDownloadFile(atUrl: URL) {
        print("did download file!")
        DispatchQueue.main.async {
            let activityVC = UIActivityViewController(activityItems: [atUrl], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.popoverPresentationController?.sourceRect = self.view.frame
            activityVC.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            self.present(activityVC, animated: true, completion: nil)
        }
    }

}

extension ViewController: WKUIDelegate, WKNavigationDelegate {
        
        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationResponse: WKNavigationResponse,
                     decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            let url = navigationResponse.response.url

            let documentUrl = url?.appendingPathComponent(navigationResponse.response.suggestedFilename!)
          //  loadAndDisplayDocumentFrom(url: documentUrl!)
            decisionHandler(.cancel)

        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
                if navigationAction.navigationType == .linkActivated {
                    if let url = navigationAction.request.url {
                        if url.absoluteString == "http://someaction/" {
                            print("Action trigure")
                        } else {
                            print("No action trigure")
                        }
                    }
                    decisionHandler(.cancel)
                } else {
                    decisionHandler(.allow)
                }
            }
}
