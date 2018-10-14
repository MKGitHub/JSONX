//
//  PerformanceTests.swift
//  JSONXTests
//
//  Created by Mohsan Khan on 2016-10-15.
//  Copyright © 2016/2017/2018 Mohsan Khan. All rights reserved.
//


import XCTest


final class PerformanceTests:XCTestCase
{
    // MARK: Private Members
    private var mJSONX:JSONX!
    private var mSwiftyJSON:JSON!


    // MARK:- Life Cycle


    override func setUp()
    {
        super.setUp()

        do
        {
            // load `JSON` file as Data
            let bundle:Bundle = Bundle(for:PerformanceTests.self)
            let filePath:String = bundle.path(forResource:"test", ofType:"json")!
            let fileContents:String = try String(contentsOfFile:filePath)
            let data:Data = fileContents.data(using:String.Encoding.utf8)!

            // init `JSONX`
            mJSONX = JSONX(data:data)

            // init `SwiftyJSON`
            mSwiftyJSON = try JSON(data:data)
        }
        catch let error
        {
            print("Error:", error.localizedDescription)
        }
    }


    // MARK:- Test


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

