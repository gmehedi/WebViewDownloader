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
    var webView:WKWebView?
    //var helper:WKWebviewDownloadHelper!
    var downloadHelper: WKDownloadHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
     
      //  self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: nil, action: nil)
        
        //downloadHelper.downloadData(from
        
    }
    
    
    @IBAction func tappedOnDSownload(_ sender: Any) {
        self.handleDownload()
    }
    
    @IBAction func tappedOnUploadButton(_ sender: Any) {
        self.handleUpload()
    }
    @IBAction func tappedOnCancelButton(_ sender: Any) {
       // self.navigationController?.popViewController(animated: true)
        self.webView?.removeFromSuperview()
    }
    
    func handleUpload() {
        
        self.webView?.removeFromSuperview()
        
        let webView = WKWebView(frame: self.view.frame)
        self.view.addSubview(webView)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.navigationItem.title = "My Page"
        self.webView = webView
        let mimeTypes = [MimeType(type: "ms-excel", fileExtension: "jpg"),
                         MimeType(type: "pdf", fileExtension: "png"),
                         MimeType(type: "pdf", fileExtension: "pdf")]
        //helper = WKWebviewDownloadHelper(webView: webView, mimeTypes:mimeTypes, delegate: self)
        downloadHelper = WKDownloadHelper(webView: webView, supportedMimeTypes: mimeTypes, delegate: self)

       
        let url = URL(string: "https://wetransfer.com/")!
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func handleDownload() {
    
        self.webView?.removeFromSuperview()
        
        let webView = WKWebView(frame: self.view.frame)
        self.view.addSubview(webView)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.navigationItem.title = "My Page"
        self.webView = webView
        
        let mimeTypes = [MimeType(type: "ms-excel", fileExtension: "jpg"),
                         MimeType(type: "pdf", fileExtension: "png"),
                         MimeType(type: "pdf", fileExtension: "pdf"),
                         MimeType(type: "pdf", fileExtension: "doc")]
        //helper = WKWebviewDownloadHelper(webView: webView, mimeTypes:mimeTypes, delegate: self)
        downloadHelper = WKDownloadHelper(webView: webView, supportedMimeTypes: mimeTypes, delegate: self)

        //let url = URL(string: "https://we.tl/t-zs3JHwU03I")! //Working
        
        let url = URL(string: "https://file-examples.com/")!
    
        let request = URLRequest(url: url)
        webView.load(request)
        
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
