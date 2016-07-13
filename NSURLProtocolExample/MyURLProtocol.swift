import UIKit

var requestCount = 0
typealias NSURLSessionCompletionHandler = (NSData?, NSURLResponse?, NSError?) -> Void

class Wrapper<T> {
    let p:T
    init(_ p:T) {
        self.p = p
    }
}

let kCompletionHandlerKey = "completionHandler"

class MyURLProtocol: NSURLProtocol {
    let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var dataTask: NSURLSessionDataTask?

    override class func canInitWithRequest(request: NSURLRequest) -> Bool {
        print("Request #\(requestCount += 1): URL = \(request.URL?.absoluteString)")
        if NSURLProtocol.propertyForKey("MyURLProtocolHandledKey", inRequest: request) != nil {
            return false
        }
        return true
    }

    override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request
    }

    override class func requestIsCacheEquivalent(aRequest: NSURLRequest, toRequest bRequest: NSURLRequest) -> Bool {
        return super.requestIsCacheEquivalent(aRequest, toRequest:bRequest)
    }

    override func startLoading() {
        guard let newRequest = request.mutableCopy() as? NSMutableURLRequest else {
            return
        }
        NSURLProtocol.setProperty(true, forKey: "MyURLProtocolHandledKey", inRequest: newRequest)
        if let completionHandler = NSURLProtocol.propertyForKey(kCompletionHandlerKey, inRequest: request) as? Wrapper<NSURLSessionCompletionHandler> {
            #if DEBUG
            if let path = NSBundle.mainBundle().pathForResource("sampleUser", ofType: "json"), url = request.URL {
                let data = NSData(contentsOfFile: path)
                let response = NSHTTPURLResponse(URL: url, statusCode: 200, HTTPVersion: "HTTP/1.1", headerFields: nil)
                completionHandler.p(data, response, nil)
            }
            #else
            dataTask = defaultSession.dataTaskWithRequest(request, completionHandler:completionHandler.p)
            dataTask?.resume()
            #endif
        }
    }

    override func stopLoading() {
        dataTask?.cancel()
    }
}