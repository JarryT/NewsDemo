//
//  WebView.swift
//  JiaMeiC Swift
//
//  Created by 汤军 on 2018/10/12.
//  Copyright © 2018年 汤军. All rights reserved.
//

import UIKit
import WebKit

/*需要JS交互时:
 WebView 必须先registerForMessageHanderWithhanderNames,再loadRequest或loadHTML
 */

typealias MessageHanderBlock = (_ handerName: String, _ parameter: Any) -> Void
typealias ContentHeightChangedBlock = (_ contentHeight: CGFloat) -> Void

class WebView: UIView {
    
    /**
     webView.scrollView的contentSize.height改变时主动调用
     */
    var contentHeightChangedBlock: ContentHeightChangedBlock?
    
    /**
     响应JS -> APP 交互事件、用户在注册registerForMessageHanderWithHanderNames方法后、方可监听回调
     */
    var messagehander: MessageHanderBlock?
    
    /**
     progressView显示webview的加载进度
     */
    var progressView: UIProgressView = {
       var progressView = UIProgressView()
        return progressView
    }()
    
    
    /**
     返回webView的scrollView、只读
     */
    var scrollView: UIScrollView{
        get{
            return webView!.scrollView
        }
    }
    
    private lazy var webView: WKWebView? = WKWebView()
    
    private var userContentController: WKUserContentController? = WKUserContentController()
    
    private var cachedHanderNames: [String] = [String]()
    
    private lazy var lastContentHeight = {
       return scrollView.contentSize.height
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpWebConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpWebConfig()
    }
    
    func setUpWebConfig(){
        
        addObserverForContentSize()
        addObserverForEstimatedProgress()
        
        webView!.uiDelegate = self
        webView!.navigationDelegate = self
        self.addSubview(webView!)
        
        progressView.tintColor = UIColor.green
        progressView.trackTintColor = UIColor.clear
        self.addSubview(progressView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateFrame()
    }
    
    func updateFrame(){
        webView?.frame = self.bounds
        progressView.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: 2)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath! == "estimatedProgress" {
            DispatchQueue.main.async {
                self.progressView.progress = Float(self.webView!.estimatedProgress)
                if self.webView!.estimatedProgress > 1.0{
                    self.progressView.setProgress(0, animated: false)
                }
            }
        }else if keyPath! == "contentSize" && ((object as? NSObject) == webView?.scrollView){
            if let block = self.contentHeightChangedBlock{
                let size = change?[NSKeyValueChangeKey.newKey] as! CGSize
                let current = size.height
                if lastContentHeight != current{
                    lastContentHeight = current
                    DispatchQueue.main.async {
                        block(current)
                    }
                }
            }
        }
    }
}

//private methods
extension WebView{
    private func addObserverForContentSize(){
        webView!.scrollView.addObserver(self, forKeyPath: "contentSize", options: [.new,.old], context: nil)
    }
    private func removeObserverForContentSize(){
        webView!.scrollView.removeObserver(self, forKeyPath: "contentSize")
    }
    private func addObserverForEstimatedProgress(){
        webView!.scrollView.addObserver(self, forKeyPath: "estimatedProgress", options: [.new,.old], context: nil)
    }
    private func removeObserverForEstimatedProgress(){
        webView!.scrollView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}

extension WebView: WebViewDelegeteControllerDelegate{
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if let hander = self.messagehander {
            hander(message.name,message.body)
        }
    }
}

extension WebView{
    
    /**
     注册方法
     @param handerNames 待监听的所有事件
     */
    private func registerForMessageHander(with handerNames:[String]){
        
        //清除之前的webview配置和监听方法
        removeObserverForContentSize()
        removeObserverForEstimatedProgress()
        webView!.removeFromSuperview()
        webView = nil
        
        for handerName in cachedHanderNames {
            userContentController!.removeScriptMessageHandler(forName: handerName)
        }
        userContentController = nil
        
        //配置环境
        let configuration = WKWebViewConfiguration()
        userContentController = WKUserContentController()
        configuration.userContentController = userContentController!
        
        weak var ws = self
        for handerName in handerNames {
            //delegate
            let delegateVC = WebViewDelegeteController()
            delegateVC.delegete = ws
            userContentController?.add(delegateVC, name: handerName)
        }
        
        //配置最新的webview
        webView = WKWebView.init(frame: CGRect.zero, configuration: configuration)
        insertSubview(webView!, at: 0)
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        
        addObserverForContentSize()
        addObserverForEstimatedProgress()
        
        updateFrame()
        cachedHanderNames = handerNames
    }
    
    /**
     APP -> JS
     @param method 方法名
     @param parameters 参数
     */
    func runJavaScript(method: String, parameters: [String], complete:((Any?, Error?) -> Void)?){
        var temp = [String]()
        for item in parameters {
            temp.append("'\(item)'")
        }
        let paramsString = temp.joined(separator: ",")
        let methodString = "\(method)(\(paramsString))"
        webView!.evaluateJavaScript(methodString, completionHandler: complete)
    }
    
    /**
     执行JS内部方法,如"document.body.scrollHeight"等、
     */
    func runJavaScriptContent(content: String, complete:((Any?, Error?) -> Void)?){
        webView!.evaluateJavaScript(content, completionHandler: complete)
    }
    
    /**
     加载request
     @param urlString request的urlString
     */
    func loadRequest(with URLString: String, handerNames:[String]? = nil, cachePolicy: NSURLRequest.CachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy,timeoutInterval: TimeInterval = 10.0){
        if let handers = handerNames {
            registerForMessageHander(with: handers)
        }
        webView!.load(URLRequest.init(url: URL.init(string: URLString)!, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval))
    }
    
    /**
     加载HTML
     @param HTMLName html文件必须位于mainBundle内、切后缀为.html
     */
    func loadHTML(with HTMLName: String, handerNames:[String]? = nil){
        if let handers = handerNames {
            registerForMessageHander(with: handers)
        }
        if let path = Bundle.main.path(forResource: HTMLName, ofType: "html"){
            if let html = try? String.init(contentsOfFile: path, encoding: String.Encoding.utf8){
                webView!.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
            }
        }
    }
}


extension WebView: WKNavigationDelegate{
    
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation")
    }
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("didCommit")
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")
    }
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("didFailProvisionalNavigation")
    }
    // 接收到服务器跳转请求之后调用
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    // 在收到响应后，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        //允许跳转
        decisionHandler(.allow);
        //不允许跳转
        //decisionHandler(.cancel);
    }
    
    // 在发送请求之前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //拦截打电话
        if navigationAction.request.url?.scheme == "tel"{
            decisionHandler(.cancel)
            let mutStr = "telprompt://\(String(describing: navigationAction.request.url?.absoluteString))"
            if let url = URL.init(string: mutStr){
                if UIApplication.shared.canOpenURL(url){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }else{
            decisionHandler(.allow)
        }
    }
}

extension WebView: WKUIDelegate{
    
    // navigationAction
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if let isMainFrame = navigationAction.targetFrame?.isMainFrame {
            if isMainFrame{
                webView.load(navigationAction.request)
            }
        }
        return nil
    }
    
    // 输入框
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        let alertVC = UIAlertController.init(title: prompt, message: defaultText, preferredStyle: .alert)
        alertVC.addTextField { (textField) in
            textField.textColor = UIColor.lightText
        }
        alertVC.addAction(
            UIAlertAction.init(title: "确定", style: .default) { (action) in
            let text = alertVC.textFields?.first?.text
            completionHandler(text)
        })
        UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
    }
    
    //确认框
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let alertVC = UIAlertController.init(title: "提示", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        alertVC.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
            completionHandler(false)
        }))
         UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
    }
    
    // 警告框
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alertVC = UIAlertController.init(title: "提示", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
            completionHandler()
        }))
        alertVC.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
            completionHandler()
        }))
         UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
    }
}



@objc protocol WebViewDelegeteControllerDelegate {
    @objc func userContentController(userContentController: WKUserContentController,didReceiveScriptMessage message: WKScriptMessage)
}

final class WebViewDelegeteController: UIViewController{
    weak var delegete: WebViewDelegeteControllerDelegate?
}

extension WebViewDelegeteController: WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.delegete?.userContentController(userContentController: userContentController, didReceiveScriptMessage: message)
    }
}
