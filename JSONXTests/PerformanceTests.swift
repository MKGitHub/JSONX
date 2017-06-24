//
//  PerformanceTests.swift
//  JSONXTests
//
//  Created by Mohsan Khan on 2016-10-15.
//  Copyright © 2016/2017 Mohsan Khan. All rights reserved.
//


import XCTest


class PerformanceTests:XCTestCase
{
    // MARK: Private Members
    fileprivate var mJSONX:JSONX!
    fileprivate var mSwiftyJSON:JSON!
    fileprivate var mJAYSON:JAYSON!


    // MARK:- Life Cycle


    override func setUp()
    {
        super.setUp()

        do
        {
            // load JSON file as Data
            let bundle:Bundle = Bundle(for:PerformanceTests.self)
            let filePath:String = bundle.path(forResource:"test", ofType:"json")!
            let fileContents:String = try String(contentsOfFile:filePath)
            let data:Data = fileContents.data(using:String.Encoding.utf8)!

            // init JSONX
            mJSONX = JSONX(with:data)

            // init SwiftyJSON
            mSwiftyJSON = JSON(data:data)

            // init JAYSON
            mJAYSON = try JAYSON(data:data)
        }
        catch let error
        {
            print("Error:", error.localizedDescription)
        }
    }


    /*override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }*/


    // MARK:- Test


    ///
    /// measured [Time, seconds] average: 0.078
    /// passed (1.035 seconds)
    ///
    func testPerformance_SearchKey_JSONX()
    {
        self.measure
        {
            for _ in 1...10000
            {
                _ = self.mJSONX.asString(inKeyPath:"key1.key2.key3.key4.key5")
            }
        }
    }


    ///
    /// https://github.com/muukii/JAYSON
    /// 0.6.2
    ///
    /// measured [Time, seconds] average: 0.163
    /// passed (1.884 seconds)
    ///
    func testPerformance_SearchKey_JAYSON()
    {
        self.measure
        {
            for _ in 1...10000
            {
                _ = self.mJAYSON["key1"]["key2"]["key3"]["key4"]["key5"].string
            }
        }
    }


    ///
    /// https://github.com/SwiftyJSON/SwiftyJSON
    /// 3.1.4
    ///
    /// measured [Time, seconds] average: 1.097
    /// passed (11.659 seconds)
    ///
    func testPerformance_SearchKey_SwiftyJSON()
    {
        self.measure
        {
            for _ in 1...10000
            {
                _ = self.mSwiftyJSON["key1"]["key2"]["key3"]["key4"]["key5"].string
            }
        }
    }
}

