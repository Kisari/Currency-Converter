//
//  MockURLProtocol.swift
//  Currency-Converter
//
//  Created by Minh Trương on 17/12/24.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var responseData: Data?
    
    static func mockResponse<T: Encodable>(with object: T) {
        responseData = try? JSONEncoder().encode(object)
        URLProtocol.registerClass(MockURLProtocol.self)
    }
    
    static func reset() {
        responseData = nil
    }

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let responseData = MockURLProtocol.responseData {
            self.client?.urlProtocol(self, didLoad: responseData)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
    
}

func setupMockURLSession() -> URLSession {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    return URLSession(configuration: config)
}

