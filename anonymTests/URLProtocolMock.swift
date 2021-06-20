//
//  URLProtocolMock.swift
//  anonymTests
//
//  Created by Nikita Fedorenko on 20.06.2021.
//

import Foundation

class URLProtocolMock: URLProtocol {
    typealias Response = (error: Error?, data: Data?, response: HTTPURLResponse?)
    static var mockURLs = [URL?: Response]()

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let url = request.url {
            if let (error, data, response) = URLProtocolMock.mockURLs[url] {
                
                if let response = response {
                    self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                }
                
                if let data = data {
                    self.client?.urlProtocol(self, didLoad: data)
                }
                
                if let error = error {
                    self.client?.urlProtocol(self, didFailWithError: error)
                }
            }
        }

        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() { }
}
