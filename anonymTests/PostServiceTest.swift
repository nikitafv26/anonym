//
//  PostServiceTest.swift
//  anonymTests
//
//  Created by Nikita Fedorenko on 19.06.2021.
//

import XCTest
@testable import anonym

class PostServiceTest: XCTestCase {

    var service: PostService!
    var testData: Data!
    
    override func setUp() {
        testData = getTestData()
    }

    func testFetchDataSuccess() throws {
        let url = URL(string: "https://k8s-stage.apianon.ru/posts/v1/posts?first=20&orderBy=mostPopular")
        let response = HTTPURLResponse(url: URL(string: "https://k8s-stage.apianon.ru/posts/v1/posts?first=20&orderBy=mostPopular")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        URLProtocolMock.mockURLs = [url: (nil, testData, response)]
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let mockSession = URLSession(configuration: config)
        
        let service = PostService(session: mockSession)
        service.fetch(first: 20, after: "", orderBy: .popular, completion: {data in
            XCTAssertNotNil(data)
            XCTAssert(data.items.count > 0)
        })
    }

    func getTestData() -> Data {
        do{
            if let url = Bundle(for: type(of: self)).url(forResource: "postTestData", withExtension: "json"){
                return try Data(contentsOf: url)
            }
        }catch{
            print(error.localizedDescription)
        }
        fatalError("dont't get test data from resource")
    }
}
