//
//  UnitTests.swift
//  JSONXTests
//
//  Created by Mohsan Khan on 2016-10-16.
//  Copyright © 2016 Mohsan Khan. All rights reserved.
//


import XCTest


class UnitTests:XCTestCase
{
    func testInitJSONX()
    {
        // init with String
        XCTAssertNil(JSONX(with:""), "Should be nil because string is empty!")

        // init with String
        let jsonXOptionalFromString1:JSONX? = JSONX(with:"{'name':'Khan Solo'}" /* , usesSingleQuotes:true */)
        XCTAssertNil(jsonXOptionalFromString1, "Should be nil because we use single quotes instead of the default double quotes!")

        // init with String
        let jsonXOptionalFromString2:JSONX? = JSONX(with:"{'name':'Khan Solo'}", usesSingleQuotes:true)
        print(jsonXOptionalFromString2?.description() as Any)
        dump(jsonXOptionalFromString2)
        XCTAssertNotNil(jsonXOptionalFromString2, "Should not be nil because we use single quotes!")

        //

        // init with file contents at path
        let bundle1:Bundle = Bundle(for:UnitTests.self)
        let filePath1:String = bundle1.path(forResource:"test", ofType:"json")!
        XCTAssertNotNil(JSONX(with:filePath1), "Should work as expected.")

        //

        // init with file at URL
        let fileUrl1:URL = URL(fileURLWithPath:"ThisPathDoesNotExist")
        XCTAssertNil(JSONX(with:fileUrl1), "Should not work because file does not exist at URL!")

        // init with file at URL
        let filePath4:String = bundle1.path(forResource:"test", ofType:"json")!
        let fileUrl2:URL = URL(fileURLWithPath:filePath4)
        XCTAssertNotNil(JSONX(with:fileUrl2), "Should work as expected.")

        //

        // init with dictionary
        XCTAssertNil(JSONX(with:[:]), "Should fail because dictionary is empty!")

        // init with dictionary
        let testDict:Dictionary<String, Any> = ["abc":123, "xyz":true, "foo":12.3456]
        XCTAssertNotNil(JSONX(with:testDict), "Should work as expected.")

        //

        // init with Data
        XCTAssertNil(JSONX(with:Data()), "Should fail because data is empty!")

        // init with Data
        let data:Data? = JSONX.convertSingleQuotesToDoubleQuotes("{'name':'Khan Solo'}").data(using:String.Encoding.utf8)
        XCTAssertNotNil(JSONX(with:data!), "Should work as expected.")
    }


    func testDataTypes()
    {
        // test data
        let testDictionary:Dictionary<String, Any> = [
            "testBoolTrue": true,
            "testBoolFalse": false,

            "testUInt": 100,
            "testInt": -100,

            "testFloat": 12.3456,
            "testDouble": 12.3456789,

            "testString": "ThisStringWorks",

            "testArray": ["abc", 123, true],

            "testDictionary": ["abc":123, "xyz":true, "foo":12.3456],

            "testKeyPath":
            [
                "parent":
                [
                    "child":
                    [
                        "grandChild": "Cute little baby!"
                    ]
                ]
            ]
        ]

        // init with Dictionary<String, Any>
        let jsonXOptionalFromDictionary:JSONX? = JSONX(with:testDictionary)

        guard let jsonx:JSONX = jsonXOptionalFromDictionary else { print("Failed to create JSONX object!"); return }

        // the tests
        XCTAssertEqual(jsonx.asRaw("testString") as? String, "ThisStringWorks", "Test `asRaw` failed!")

        XCTAssertTrue(jsonx.asBool("testBoolTrue")!, "Test `asBool` failed!")
        XCTAssertFalse(jsonx.asBool("testBoolFalse")!, "Test `asBool` failed!")

        XCTAssertEqual(jsonx.asUInt("testUInt"), 100, "Test `asUInt` failed!")

        XCTAssertEqual(jsonx.asInt("testInt"), -100, "Test `asInt` failed!")

        XCTAssertEqual(jsonx.asFloat("testFloat"), 12.3456, "Test `asFloat` failed!")

        XCTAssertEqual(jsonx.asDouble("testDouble"), 12.3456789, "Test `asDouble` failed!")

        XCTAssertEqual(jsonx.asString("testString"), "ThisStringWorks", "Test `asString` failed!")

        let _ = zip(jsonx.asArray("testArray")!, ["abc", 123, true]).map
        {
            (e1:Any, e2:Any) in
            XCTAssertTrue((e1 as AnyObject).isEqual(e2), "Test `asArray` failed!")
        }

        let testNSDict1:Dictionary<String, Any> = jsonx.asDictionary("testDictionary")!
        let testNSDict2:Dictionary<String, Any> = ["abc":123, "xyz":true, "foo":12.3456]
        XCTAssertTrue(NSDictionary(dictionary:testNSDict1).isEqual(to:testNSDict2), "Test `asDictionary` failed!")
    }


    func testKeyPath()
    {
        // test data
        let testDictionary:Dictionary<String, Any> = [
            "testBoolTrue": true,
            "testBoolFalse": false,

            "testUInt": 100,
            "testInt": -100,

            "testFloat": 12.3456,
            "testDouble": 12.3456789,

            "testString": "ThisStringWorks",

            "testArray": ["abc", 123, true],

            "testDictionary": ["abc":123, "xyz":true, "foo":12.3456],

            "testKeyPath":
            [
                "parent":
                [
                    "child":
                    [
                        "grandChild": "Cute little baby!",

                        "testBoolTrue": true,
                        "testBoolFalse": false,

                        "testUInt": 100,
                        "testInt": -100,

                        "testFloat": 12.3456,
                        "testDouble": 12.3456789,

                        "testString": "ThisStringWorks",

                        "testArray": ["abc", 123, true],

                        "testDictionary": ["abc":123, "xyz":true, "foo":12.3456]
                    ]
                ]
            ]
        ]

        // init with Dictionary<String, Any>
        let jsonXOptionalFromDictionary:JSONX? = JSONX(with:testDictionary)

        guard let jsonx:JSONX = jsonXOptionalFromDictionary else { print("Failed to create JSONX object!"); return }

        // the tests
        let foundValue1:Any? = jsonx.asRaw(inKeyPath:"testKeyPath.parent.child.grandChild", usingDelimiter:".")
        XCTAssertEqual((foundValue1 as! String), "Cute little baby!", "Test `asRaw` 1 failed!")

        XCTAssertNil(jsonx.asRaw(inKeyPath:"", usingDelimiter:"."), "Test `asRaw` 2 failed!")

        XCTAssertNil(jsonx.asRaw(inKeyPath:".testKeyPath", usingDelimiter:"."), "Test `asRaw` 3 failed!")

        XCTAssertNil(jsonx.asRaw(inKeyPath:"testKeyPath.", usingDelimiter:"."), "Test `asRaw` 4 failed!")

        XCTAssertNil(jsonx.asRaw(inKeyPath:"nonExistingKey", usingDelimiter:"."), "Test `asRaw` 4 failed!")

        XCTAssertNil(jsonx.asRaw(inKeyPath:"testKeyPath.parent.child.grandChild.nonExistingKey"), "Test `asRaw` 5 failed!")

        let foundValue2:Any? = jsonx.asRaw(inKeyPath:"testKeyPath->parent->child->grandChild", usingDelimiter:"->")
        XCTAssertEqual((foundValue2 as! String), "Cute little baby!", "Test `asRaw` 6 failed!")

        XCTAssertNil(jsonx.asRaw(inKeyPath:"testKeyPath.parent.child.grandChild", usingDelimiter:""), "Test `asRaw` 7 failed!")

        XCTAssertNil(jsonx.asRaw(inKeyPath:"testKeyPath.parent.child.grandChild", usingDelimiter:"_"), "Test `asRaw` 8 failed!")

        //

        XCTAssertTrue(jsonx.asBool(inKeyPath:"testKeyPath.parent.child.testBoolTrue")!, "Test `asBool` failed!")

        XCTAssertFalse(jsonx.asBool(inKeyPath:"testKeyPath.parent.child.testBoolFalse")!, "Test `asBool` failed!")

        XCTAssertEqual(jsonx.asUInt(inKeyPath:"testKeyPath.parent.child.testUInt"), 100, "Test `asUInt` failed!")

        XCTAssertEqual(jsonx.asInt(inKeyPath:"testKeyPath.parent.child.testInt"), -100, "Test `asInt` failed!")

        XCTAssertEqual(jsonx.asFloat(inKeyPath:"testKeyPath.parent.child.testFloat"), 12.3456, "Test `asFloat` failed!")

        XCTAssertEqual(jsonx.asDouble(inKeyPath:"testKeyPath.parent.child.testDouble"), 12.3456789, "Test `asDouble` failed!")

        XCTAssertEqual(jsonx.asString(inKeyPath:"testKeyPath.parent.child.testString"), "ThisStringWorks", "Test `asString` failed!")

        let _ = zip(jsonx.asArray(inKeyPath:"testKeyPath.parent.child.testArray")!, ["abc", 123, true]).map
        {
            (e1:Any, e2:Any) in
            XCTAssertTrue((e1 as AnyObject).isEqual(e2), "Test `asArray` failed!")
        }

        let testNSDict1:Dictionary<String, Any> = jsonx.asDictionary(inKeyPath:"testKeyPath.parent.child.testDictionary")!
        let testNSDict2:Dictionary<String, Any> = ["abc":123, "xyz":true, "foo":12.3456]
        XCTAssertTrue(NSDictionary(dictionary:testNSDict1).isEqual(to:testNSDict2), "Test `asDictionary` failed!")
    }


    func testDefaultValue()
    {
        // test data
        let testDictionary:Dictionary<String, Any> = ["BADKEY":"DONTUSE!"]

        // init with Dictionary<String, Any>
        let jsonXOptionalFromDictionary:JSONX? = JSONX(with:testDictionary)

        guard let jsonx:JSONX = jsonXOptionalFromDictionary else { print("Failed to create JSONX object!"); return }

        // the tests
        XCTAssertEqual(jsonx.asRaw("nonExistingKey", default:"raw food") as? String, "raw food", "Test `asRaw` failed!")

        XCTAssertTrue(jsonx.asBool("nonExistingKey", default:true)!, "Test `asBool` failed!")
        XCTAssertFalse(jsonx.asBool("nonExistingKey", default:false)!, "Test `asBool` failed!")

        XCTAssertEqual(jsonx.asUInt("nonExistingKey", default:100), 100, "Test `asUInt` failed!")

        XCTAssertEqual(jsonx.asInt("nonExistingKey", default:-100), -100, "Test `asInt` failed!")

        XCTAssertEqual(jsonx.asFloat("nonExistingKey", default:12.3456), 12.3456, "Test `asFloat` failed!")

        XCTAssertEqual(jsonx.asDouble("nonExistingKey", default:12.3456789), 12.3456789, "Test `asDouble` failed!")

        XCTAssertEqual(jsonx.asString("nonExistingKey", default:"Default string"), "Default string", "Test `asString` failed!")

        let _ = zip(jsonx.asArray("nonExistingKey", default:["abc", 123, true])!, ["abc", 123, true]).map
        {
            (e1:Any, e2:Any) in
            XCTAssertTrue((e1 as AnyObject).isEqual(e2), "Test `asArray` failed!")
        }

        let testNSDict2:Dictionary<String, Any> = ["abc":123, "xyz":true, "foo":12.3456]
        let testNSDict1:Dictionary<String, Any> = jsonx.asDictionary("nonExistingKey", default:testNSDict2)!
        XCTAssertTrue(NSDictionary(dictionary:testNSDict1).isEqual(to:testNSDict2), "Test `asDictionary` failed!")
    }


    func testKeyPathDefaultValue()
    {
        // test data
        let testDictionary:Dictionary<String, Any> = ["BADKEY":"DONTUSE!"]

        // init with Dictionary<String, Any>
        let jsonXOptionalFromDictionary:JSONX? = JSONX(with:testDictionary)

        guard let jsonx:JSONX = jsonXOptionalFromDictionary else { print("Failed to create JSONX object!"); return }

        // the tests
        XCTAssertEqual(jsonx.asRaw(inKeyPath:"nonExistingKey", default:"raw food", usingDelimiter:".") as? String, "raw food", "Test `asRaw` failed!")

        XCTAssertEqual(jsonx.asRaw(inKeyPath:"nonExistingKey.path", default:"raw food", usingDelimiter:".") as? String, "raw food", "Test `asRaw` failed!")

        XCTAssertTrue(jsonx.asBool(inKeyPath:"nonExistingKey", default:true, usingDelimiter:".")!, "Test `asBool` failed!")

        XCTAssertFalse(jsonx.asBool(inKeyPath:"nonExistingKey", default:false, usingDelimiter:".")!, "Test `asBool` failed!")

        XCTAssertEqual(jsonx.asUInt(inKeyPath:"nonExistingKey", default:100, usingDelimiter:"."), 100, "Test `asUInt` failed!")

        XCTAssertEqual(jsonx.asInt(inKeyPath:"nonExistingKey", default:-100, usingDelimiter:"."), -100, "Test `asInt` failed!")

        XCTAssertEqual(jsonx.asFloat(inKeyPath:"nonExistingKey", default:12.34, usingDelimiter:"."), 12.34, "Test `asFloat` failed!")

        XCTAssertEqual(jsonx.asDouble(inKeyPath:"nonExistingKey", default:12.3456789, usingDelimiter:"."), 12.3456789, "Test `asDouble` failed!")

        XCTAssertEqual(jsonx.asString(inKeyPath:"nonExistingKey", default:"Default str", usingDelimiter:"."), "Default str", "Test `asRaw` failed!")

        let _ = zip(jsonx.asArray(inKeyPath:"nonExistingKey", default:["abc", 123, true])!, ["abc", 123, true]).map
        {
            (e1:Any, e2:Any) in
            XCTAssertTrue((e1 as AnyObject).isEqual(e2), "Test `asArray` failed!")
        }

        let testNSDict2:Dictionary<String, Any> = ["abc":123, "xyz":true, "foo":12.3456]
        let testNSDict1:Dictionary<String, Any> = jsonx.asDictionary(inKeyPath:"nonExistingKey", default:testNSDict2)!
        XCTAssertTrue(NSDictionary(dictionary:testNSDict1).isEqual(to:testNSDict2), "Test `asDictionary` failed!")
    }
}

