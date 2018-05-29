//
//  ViewController.swift
//  WKWebView
//
//  Created by JiangSonglun on 2017/5/2.
//  Copyright © 2017年 JSL. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController,WKNavigationDelegate,WKUIDelegate {

//    网页地址
    let url = "https://www.baidu.com"
    
//    WKWebView
    lazy var wkwebView: WKWebView = {
        
        var webView = WKWebView(frame: self.view.bounds)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.isUserInteractionEnabled = true
        return webView
    }()
    
//    进度条
    lazy var progBar: UIProgressView = {
        
        var pro = UIProgressView(frame: CGRect(x: 0, y: 44, width: self.view.frame.width, height: 1))
        pro.progress = 0.0
        pro.progressTintColor = UIColor.green
        pro.trackTintColor = UIColor.gray
        return pro
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加到界面
        self.view.addSubview(self.wkwebView)
        
        //添加进度条
        self.navigationController?.navigationBar.addSubview(self.progBar)
        
        //添加进度监听
        self.wkwebView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        
        //加载网页
        let request = NSURLRequest(url: URL(string:url)!)
        self.wkwebView.load(request as URLRequest)
        
    }
    
    //处理监听
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progBar.alpha = 1.0
            progBar.setProgress(Float(self.wkwebView.estimatedProgress), animated: true)
            //进度条的值最大为1.0
            if(self.wkwebView.estimatedProgress >= 1.0) {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: UIViewAnimationOptions.curveEaseInOut, animations: { () -> Void in
                    self.progBar.alpha = 0.0
                }, completion: { (finished:Bool) -> Void in
                    self.progBar.progress = 0
                })
            }
        }

    }
    
//    WKNavigationDelegate
    
    //1. 处理网页加载完成后
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.navigationItem.title = self.wkwebView.title
    }
    
    //2.决定网页能否被允许跳转
//    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//        
//    }

    //3.处理网页开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("\(#function)")
    }
    
    //4.
//    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
//        
//    }
    
    //5.处理网页加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
    //6.处理网页内容开始返回
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    //7.
//    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
//        
//    }
    
    //8.处理网页进程终止
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        
    }
    
    //9.处理网页返回内容时发生的失败
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("导航加载失败！！")
    }
    
//    WKUIDelegate
    
    //(1)WKWebView创建初始化加载的一些配置    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        //如果目标主视图不为空,则允许导航
        if !(navigationAction.targetFrame?.isMainFrame != nil) {
            self.wkwebView.load(navigationAction.request)
        }
        return nil
    }
    
    //(2)iOS9.0中新加入的,处理WKWebView关闭的时间
    func webViewDidClose(_ webView: WKWebView) {
        
    }
        
    //(3)处理网页js中的提示框,若不使用该方法,则提示框无效
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
    }
        
    //(4)处理网页js中的确认框,若不使用该方法,则确认框无效
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
    }
        
    // (5)处理网页js中的文本输入
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        //移除监听
        self.wkwebView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}

