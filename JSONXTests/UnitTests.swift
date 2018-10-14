//
//  UnitTests.swift
//  JSONXTests
//
//  Created by Mohsan Khan on 2016-10-16.
//  Copyright © 2016/2017/2018 Mohsan Khan. All rights reserved.
//


import XCTest


final class UnitTests:XCTestCase
{
    func test_InitJSONX()
    {
        // init with a `String`
        XCTAssertNil(JSONX(string:"", usesSingleQuotes:true), "Should be nil because string is empty!")
        XCTAssertNil(JSONX(string:"", usesSingleQuotes:false), "Should be nil because string is empty!")
        XCTAssertNil(JSONX(string:""), "Should be nil because string is empty!")

        // init with a `String`
        let jsonXOptionalFromString1:JSONX? = JSONX(string:"{'name':'Khan Solo'}" /* , usesSingleQuotes:true */)
        XCTAssertNil(jsonXOptionalFromString1, "Should be nil because we use single quotes instead of the default double quotes!")

        // init with a `String`
        let jsonXOptionalFromString2:JSONX? = JSONX(string:"{'name':'Khan Solo'}", usesSingleQuotes:true)
        print(jsonXOptionalFromString2?.description() as Any)
        dump(jsonXOptionalFromString2)
        XCTAssertNotNil(jsonXOptionalFromString2, "Should not be nil because we use single quotes!")

        //

        // init with a file path
        let bundle1:Bundle = Bundle(for:UnitTests.self)
        let filePath1:String = bundle1.path(forResource:"test", ofType:"json")!
        XCTAssertNotNil(JSONX(filepath:filePath1), "Should work as expected.")

        //

        // init with a file `URL`
        let fileUrl1:URL = URL(fileURLWithPath:"ThisPathDoesNotExist")
        XCTAssertNil(JSONX(url:fileUrl1), "Should not work because file does not exist at `URL`!")

        // init with a file `URL`
        let filePath4:String = bundle1.path(forResource:"test", ofType:"json")!
        let fileUrl2:URL = URL(fileURLWithPath:filePath4)
        XCTAssertNotNil(JSONX(url:fileUrl2), "Should work as expected.")

        //

        // init with a `Dictionary`
        XCTAssertNil(JSONX(dictionary:[:]), "Should fail because dictionary is empty!")

        // init with a `Dictionary`
        let testDict:Dictionary<String, Any> = ["abc":123, "xyz":true, "foo":12.3456]
        XCTAssertNotNil(JSONX(dictionary:testDict), "Should work as expected.")

        //

        // init with `Data`
        XCTAssertNil(JSONX(data:Data()), "Should fail because data is empty!")

        // init with `Data`
        let data:Data? = JSONX.convertSingleQuotesToDoubleQuotes("{'name':'Khan Solo'}").data(using:String.Encoding.utf8)
        XCTAssertNotNil(JSONX(data:data!), "Should work as expected.")
    }


    func test_DataTypes()
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

        // init with a `Dictionary`
        let jsonXOptionalFromDictionary:JSONX? = JSONX(dictionary:testDictionary)

        guard let jsonx:JSONX = jsonXOptionalFromDictionary else { print("Failed to create JSONX object!"); return }

        // the tests
        XCTAssertEqual(jsonx.asRaw("nonExistingKey", default:"defaultValue") as? String, "defaultValue", "Test `asRaw` failed!")

        XCTAssertEqual(jsonx.asRaw("testString") as? String, "ThisStringWorks", "Test `asRaw` failed!")

        XCTAssertEqual(jsonx.asBool("nonExistingKey", default:true), true, "Test `asBool` failed!")
        XCTAssertEqual(jsonx.asBool("nonExistingKey", default:false), false, "Test `asBool` failed!")

        XCTAssertEqual(jsonx.asBool("testBoolTrue"), true, "Test `asBool` failed!")
        XCTAssertEqual(jsonx.asBool("testBoolFalse"), false, "Test `asBool` failed!")

        XCTAssertEqual(jsonx.asUInt("nonExistingKey", default:123), 123, "Test `asUInt` failed!")
        XCTAssertEqual(jsonx.asUInt("testUInt"), 100, "Test `asUInt` failed!")

        XCTAssertEqual(jsonx.asInt("nonExistingKey", default:-13), -13, "Test `asInt` failed!")
        XCTAssertEqual(jsonx.asInt("testInt"), -100, "Test `asInt` failed!")

        XCTAssertEqual(jsonx.asFloat("nonExistingKey", default:Float(1.23)), Float(1.23), "Test `asFloat` failed!")
        XCTAssertEqual(jsonx.asFloat("testFloat"), 12.3456, "Test `asFloat` failed!")

        XCTAssertEqual(jsonx.asDouble("nonExistingKey", default:Double(2.45)), Double(2.45), "Test `asDouble` failed!")
        XCTAssertEqual(jsonx.asDouble("testDouble"), 12.3456789, "Test `asDouble` failed!")

        XCTAssertEqual(jsonx.asString("nonExistingKey", default:"defaultString"), "defaultString", "Test `asString` failed!")
        XCTAssertEqual(jsonx.asString("testString"), "ThisStringWorks", "Test `asString` failed!")

        let _ = zip(jsonx.asArray("nonExistingKey", default:["abc", 123, true])!, ["abc", 123, true]).map
        {
            (transform:(e1:Any, e2:Any)) in
            return XCTAssertTrue((transform.e1 as AnyObject).isEqual(transform.e2), "Test `asArray` failed!")
        }
        let _ = zip(jsonx.asArray("testArray")!, ["abc", 123, true]).map
        {
            (transform:(e1:Any, e2:Any)) in
            XCTAssertTrue((transform.e1 as AnyObject).isEqual(transform.e2), "Test `asArray` failed!")
        }

        let nonExistingTestNSDict1:Dictionary<String, Any> = jsonx.asDictionary("nonExistingKey", default:["abc":123, "xyz":true, "foo":12.3456])!
        let testNSDict2:Dictionary<String, Any> = ["abc":123, "xyz":true, "foo":12.3456]
        XCTAssertTrue(NSDictionary(dictionary:nonExistingTestNSDict1).isEqual(to:testNSDict2), "Test `asDictionary` failed!")
        let testNSDict1:Dictionary<String, Any> = jsonx.asDictionary("testDictionary")!
        XCTAssertTrue(NSDictionary(dictionary:testNSDict1).isEqual(to:testNSDict2), "Test `asDictionary` failed!")
    }


    func test_KeyPath()
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

        // init with a `Dictionary`
        let jsonXOptionalFromDictionary:JSONX? = JSONX(dictionary:testDictionary)

        guard let jsonx:JSONX = jsonXOptionalFromDictionary else { print("Failed to create JSONX object!"); return }

        // the tests
        let foundValue1:Any? = jsonx.asRaw(inKeyPath:"testKeyPath.parent.child.grandChild")
        XCTAssertEqual((foundValue1 as! String), "Cute little baby!", "Test `asRaw` 1 failed!")

        XCTAssertNil(jsonx.asRaw(inKeyPath:""), "Test `asRaw` 2 failed!")

        XCTAssertNil(jsonx.asRaw(inKeyPath:".testKeyPath"), "Test `asRaw` 3 failed!")

        XCTAssertNil(jsonx.asRaw(inKeyPath:"testKeyPath."), "Test `asRaw` 4 failed!")

        XCTAssertNil(jsonx.asRaw(inKeyPath:"nonExistingKey"), "Test `asRaw` 4 failed!")

        XCTAssertNil(jsonx.asRaw(inKeyPath:"testKeyPath.parent.child.grandChild.nonExistingKey"), "Test `asRaw` 5 failed!")

        XCTAssertNil(jsonx.asRaw(inKeyPath:"wrong->key->path->format"), "Test `asRaw` 6 failed!")

        //

        XCTAssertEqual(jsonx.asBool(inKeyPath:"testKeyPath.parent.child.nonExistingKey"), nil, "Test `asBool` failed!")
        XCTAssertEqual(jsonx.asBool(inKeyPath:"testKeyPath.parent.child.testBoolTrue"), true, "Test `asBool` failed!")
        XCTAssertEqual(jsonx.asBool(inKeyPath:"testKeyPath.parent.child.testBoolFalse"), false, "Test `asBool` failed!")

        XCTAssertEqual(jsonx.asUInt(inKeyPath:"testKeyPath.parent.child.testUInt.nonExistingKey"), nil, "Test `asUInt` failed!")
        XCTAssertEqual(jsonx.asUInt(inKeyPath:"testKeyPath.parent.child.testUInt"), UInt(100), "Test `asUInt` failed!")

        XCTAssertEqual(jsonx.asInt(inKeyPath:"testKeyPath.parent.child.testInt.nonExistingKey"), nil, "Test `asInt` failed!")
        XCTAssertEqual(jsonx.asInt(inKeyPath:"testKeyPath.parent.child.testInt"), Int(-100), "Test `asInt` failed!")

        XCTAssertEqual(jsonx.asFloat(inKeyPath:"testKeyPath.parent.child.testFloat.nonExistingKey"), nil, "Test `asFloat` failed!")
        XCTAssertEqual(jsonx.asFloat(inKeyPath:"testKeyPath.parent.child.testFloat"), Float(12.3456), "Test `asFloat` failed!")

        XCTAssertEqual(jsonx.asDouble(inKeyPath:"testKeyPath.parent.child.testDouble.nonExistingKey"), nil, "Test `asDouble` failed!")
        XCTAssertEqual(jsonx.asDouble(inKeyPath:"testKeyPath.parent.child.testDouble"), Double(12.3456789), "Test `asDouble` failed!")

        XCTAssertEqual(jsonx.asString(inKeyPath:"testKeyPath.parent.child.testString.nonExistingKey"), nil, "Test `asString` failed!")
        XCTAssertEqual(jsonx.asString(inKeyPath:"testKeyPath.parent.child.testString"), "ThisStringWorks", "Test `asString` failed!")

        XCTAssertNil(jsonx.asArray(inKeyPath:"testKeyPath.parent.child.testArray.nonExistingKey"), "Test `asArray` failed!")

        let _ = zip(jsonx.asArray(inKeyPath:"testKeyPath.parent.child.testArray")!, ["abc", 123, true]).map
        {
            (transform:(e1:Any, e2:Any)) in
            XCTAssertTrue((transform.e1 as AnyObject).isEqual(transform.e2), "Test `asArray` failed!")
        }

        XCTAssertNil(jsonx.asDictionary(inKeyPath:"testKeyPath.parent.child.testDictionary.nonExistingKey"), "Test `asDictionary` failed!")

        let testNSDict1:Dictionary<String, Any> = jsonx.asDictionary(inKeyPath:"testKeyPath.parent.child.testDictionary")!
        let testNSDict2:Dictionary<String, Any> = ["abc":123, "xyz":true, "foo":12.3456]
        XCTAssertTrue(NSDictionary(dictionary:testNSDict1).isEqual(to:testNSDict2), "Test `asDictionary` failed!")
    }


    func test_DefaultValue()
    {
        // test data
        let testDictionary:Dictionary<String, Any> = ["BADKEY":"DONTUSE!"]

        // init with a `Dictionary`
        let jsonXOptionalFromDictionary:JSONX? = JSONX(dictionary:testDictionary)

        guard let jsonx:JSONX = jsonXOptionalFromDictionary else { print("Failed to create JSONX object!"); return }

        // the tests
        XCTAssertEqual(jsonx.asRaw("nonExistingKey", default:"raw food") as? String, "raw food", "Test `asRaw` failed!")

        XCTAssertEqual(jsonx.asBool("nonExistingKey", default:true), true, "Test `asBool` failed!")
        XCTAssertEqual(jsonx.asBool("nonExistingKey", default:false), false, "Test `asBool` failed!")

        XCTAssertEqual(jsonx.asUInt("nonExistingKey", default:100), 100, "Test `asUInt` failed!")

        XCTAssertEqual(jsonx.asInt("nonExistingKey", default:-100), -100, "Test `asInt` failed!")

        XCTAssertEqual(jsonx.asFloat("nonExistingKey", default:12.3456), 12.3456, "Test `asFloat` failed!")

        XCTAssertEqual(jsonx.asDouble("nonExistingKey", default:12.3456789), 12.3456789, "Test `asDouble` failed!")

        XCTAssertEqual(jsonx.asString("nonExistingKey", default:"Default string"), "Default string", "Test `asString` failed!")

        let _ = zip(jsonx.asArray("nonExistingKey", default:["abc", 123, true])!, ["abc", 123, true]).map
        {
            (transform:(e1:Any, e2:Any)) in
            XCTAssertTrue((transform.e1 as AnyObject).isEqual(transform.e2), "Test `asArray` failed!")
        }

        let testNSDict2:Dictionary<String, Any> = ["abc":123, "xyz":true, "foo":12.3456]
        let testNSDict1:Dictionary<String, Any> = jsonx.asDictionary("nonExistingKey", default:testNSDict2)!
        XCTAssertTrue(NSDictionary(dictionary:testNSDict1).isEqual(to:testNSDict2), "Test `asDictionary` failed!")
    }


    func test_KeyPathDefaultValue()
    {
        // test data
        let testDictionary:Dictionary<String, Any> = ["BADKEY":"DONTUSE!"]

        // init with a `Dictionary`
        let jsonXOptionalFromDictionary:JSONX? = JSONX(dictionary:testDictionary)

        guard let jsonx:JSONX = jsonXOptionalFromDictionary else { print("Failed to create JSONX object!"); return }

        // the tests
        XCTAssertEqual(jsonx.asRaw(inKeyPath:"nonExistingKey", default:"raw food") as? String, "raw food", "Test `asRaw` failed!")
        XCTAssertEqual(jsonx.asRaw(inKeyPath:"nonExistingKey.path", default:"raw food") as? String, "raw food", "Test `asRaw` failed!")

        XCTAssertEqual(jsonx.asBool(inKeyPath:"nonExistingKey", default:true), true, "Test `asBool` failed!")
        XCTAssertEqual(jsonx.asBool(inKeyPath:"nonExistingKey", default:false), false, "Test `asBool` failed!")

        XCTAssertEqual(jsonx.asUInt(inKeyPath:"nonExistingKey", default:100), 100, "Test `asUInt` failed!")

        XCTAssertEqual(jsonx.asInt(inKeyPath:"nonExistingKey", default:-100), -100, "Test `asInt` failed!")

        XCTAssertEqual(jsonx.asFloat(inKeyPath:"nonExistingKey", default:12.34), 12.34, "Test `asFloat` failed!")

        XCTAssertEqual(jsonx.asDouble(inKeyPath:"nonExistingKey", default:12.3456789), 12.3456789, "Test `asDouble` failed!")

        XCTAssertEqual(jsonx.asString(inKeyPath:"nonExistingKey", default:"Default str"), "Default str", "Test `asRaw` failed!")

        let _ = zip(jsonx.asArray(inKeyPath:"nonExistingKey", default:["abc", 123, true])!, ["abc", 123, true]).map
        {
            (transform:(e1:Any, e2:Any)) in
            XCTAssertTrue((transform.e1 as AnyObject).isEqual(transform.e2), "Test `asArray` failed!")
        }

        let testNSDict2:Dictionary<String, Any> = ["abc":123, "xyz":true, "foo":12.3456]
        let testNSDict1:Dictionary<String, Any> = jsonx.asDictionary(inKeyPath:"nonExistingKey", default:testNSDict2)!
        XCTAssertTrue(NSDictionary(dictionary:testNSDict1).isEqual(to:testNSDict2), "Test `asDictionary` failed!")
    }


    func test_NullValue()
    {
        // test data
        let testDictionary:Dictionary<String, Any> = ["NullKey":NSNull()]

        // init with a `Dictionary`
        let jsonXOptionalFromDictionary:JSONX? = JSONX(dictionary:testDictionary)

        guard let jsonx:JSONX = jsonXOptionalFromDictionary else { print("Failed to create JSONX object!"); return }

        // the tests, key
        XCTAssertNil(jsonx.asRaw("NullKey", default:nil), "Test `asRaw` failed!")
        XCTAssertNil(jsonx.asRaw("nonExistingKey", default:nil), "Test `asRaw` failed!")

        XCTAssertNil(jsonx.asBool("NullKey", default:nil), "Test `asBool` failed!")
        XCTAssertNil(jsonx.asBool("nonExistingKey", default:nil), "Test `asBool` failed!")

        XCTAssertNil(jsonx.asUInt("NullKey", default:nil), "Test `asUInt` failed!")
        XCTAssertNil(jsonx.asUInt("nonExistingKey", default:nil), "Test `asUInt` failed!")

        XCTAssertNil(jsonx.asInt("NullKey", default:nil), "Test `asInt` failed!")
        XCTAssertNil(jsonx.asInt("nonExistingKey", default:nil), "Test `asInt` failed!")

        XCTAssertNil(jsonx.asFloat("NullKey", default:nil), "Test `asFloat` failed!")
        XCTAssertNil(jsonx.asFloat("nonExistingKey", default:nil), "Test `asFloat` failed!")

        XCTAssertNil(jsonx.asDouble("NullKey", default:nil), "Test `asDouble` failed!")
        XCTAssertNil(jsonx.asDouble("nonExistingKey", default:nil), "Test `asDouble` failed!")

        XCTAssertNil(jsonx.asString("NullKey", default:nil), "Test `asString` failed!")
        XCTAssertNil(jsonx.asString("nonExistingKey", default:nil), "Test `asString` failed!")

        XCTAssertNil(jsonx.asArray("NullKey", default:nil), "Test `asArray` failed!")
        XCTAssertNil(jsonx.asArray("nonExistingKey", default:nil), "Test `asArray` failed!")

        XCTAssertNil(jsonx.asDictionary("NullKey", default:nil), "Test `asDictionary` failed!")
        XCTAssertNil(jsonx.asDictionary("nonExistingKey", default:nil), "Test `asDictionary` failed!")
    }


    func test_NullValueKeyPath()
    {
        // test data
        let testDictionaryKeyPath:Dictionary<String, Any> = [
            "testKeyPath":["NullKey":NSNull()]
        ]

        // init with a `Dictionary`
        let jsonXOptionalFromDictionary:JSONX? = JSONX(dictionary:testDictionaryKeyPath)

        guard let jsonx:JSONX = jsonXOptionalFromDictionary else { print("Failed to create JSONX object!"); return }

        // the tests, key path
        XCTAssertNil(jsonx.asRaw(inKeyPath:"testKeyPath.NullKey", default:nil), "Test `asRaw` failed!")
        XCTAssertNil(jsonx.asRaw(inKeyPath:"NullKey", default:nil), "Test `asRaw` failed!")
        XCTAssertNil(jsonx.asRaw(inKeyPath:"testKeyPath.nonExistingKey", default:nil), "Test `asRaw` failed!")
        XCTAssertNil(jsonx.asRaw(inKeyPath:"nonExistingKey", default:nil), "Test `asRaw` failed!")

        XCTAssertNil(jsonx.asBool(inKeyPath:"testKeyPath.NullKey", default:nil), "Test `asBool` failed!")
        XCTAssertNil(jsonx.asBool(inKeyPath:"NullKey", default:nil), "Test `asBool` failed!")
        XCTAssertNil(jsonx.asBool(inKeyPath:"testKeyPath.nonExistingKey", default:nil), "Test `asBool` failed!")
        XCTAssertNil(jsonx.asBool(inKeyPath:"nonExistingKey", default:nil), "Test `asBool` failed!")

        XCTAssertNil(jsonx.asUInt(inKeyPath:"testKeyPath.NullKey", default:nil), "Test `asUInt` failed!")
        XCTAssertNil(jsonx.asUInt(inKeyPath:"NullKey", default:nil), "Test `asUInt` failed!")
        XCTAssertNil(jsonx.asUInt(inKeyPath:"testKeyPath.nonExistingKey", default:nil), "Test `asUInt` failed!")
        XCTAssertNil(jsonx.asUInt(inKeyPath:"nonExistingKey", default:nil), "Test `asUInt` failed!")

        XCTAssertNil(jsonx.asInt(inKeyPath:"testKeyPath.NullKey", default:nil), "Test `asInt` failed!")
        XCTAssertNil(jsonx.asInt(inKeyPath:"NullKey", default:nil), "Test `asInt` failed!")
        XCTAssertNil(jsonx.asInt(inKeyPath:"testKeyPath.nonExistingKey", default:nil), "Test `asInt` failed!")
        XCTAssertNil(jsonx.asInt(inKeyPath:"nonExistingKey", default:nil), "Test `asInt` failed!")

        XCTAssertNil(jsonx.asFloat(inKeyPath:"testKeyPath.NullKey", default:nil), "Test `asFloat` failed!")
        XCTAssertNil(jsonx.asFloat(inKeyPath:"NullKey", default:nil), "Test `asFloat` failed!")
        XCTAssertNil(jsonx.asFloat(inKeyPath:"testKeyPath.nonExistingKey", default:nil), "Test `asFloat` failed!")
        XCTAssertNil(jsonx.asFloat(inKeyPath:"nonExistingKey", default:nil), "Test `asFloat` failed!")

        XCTAssertNil(jsonx.asDouble(inKeyPath:"testKeyPath.NullKey", default:nil), "Test `asDouble` failed!")
        XCTAssertNil(jsonx.asDouble(inKeyPath:"NullKey", default:nil), "Test `asDouble` failed!")
        XCTAssertNil(jsonx.asDouble(inKeyPath:"testKeyPath.nonExistingKey", default:nil), "Test `asDouble` failed!")
        XCTAssertNil(jsonx.asDouble(inKeyPath:"nonExistingKey", default:nil), "Test `asDouble` failed!")

        XCTAssertNil(jsonx.asString(inKeyPath:"testKeyPath.NullKey", default:nil), "Test `asString` failed!")
        XCTAssertNil(jsonx.asString(inKeyPath:"NullKey", default:nil), "Test `asString` failed!")
        XCTAssertNil(jsonx.asString(inKeyPath:"testKeyPath.nonExistingKey", default:nil), "Test `asString` failed!")
        XCTAssertNil(jsonx.asString(inKeyPath:"nonExistingKey", default:nil), "Test `asString` failed!")

        XCTAssertNil(jsonx.asArray(inKeyPath:"testKeyPath.NullKey", default:nil), "Test `asArray` failed!")
        XCTAssertNil(jsonx.asArray(inKeyPath:"NullKey", default:nil), "Test `asArray` failed!")
        XCTAssertNil(jsonx.asArray(inKeyPath:"testKeyPath.nonExistingKey", default:nil), "Test `asArray` failed!")
        XCTAssertNil(jsonx.asArray(inKeyPath:"nonExistingKey", default:nil), "Test `asArray` failed!")

        XCTAssertNil(jsonx.asDictionary(inKeyPath:"testKeyPath.NullKey", default:nil), "Test `asDictionary` failed!")
        XCTAssertNil(jsonx.asDictionary(inKeyPath:"NullKey", default:nil), "Test `asDictionary` failed!")
        XCTAssertNil(jsonx.asDictionary(inKeyPath:"testKeyPath.nonExistingKey", default:nil), "Test `asDictionary` failed!")
        XCTAssertNil(jsonx.asDictionary(inKeyPath:"nonExistingKey", default:nil), "Test `asDictionary` failed!")
    }


    func test_DictionaryToJSONX()
    {
        // test data
        let testDictionary:Dictionary<String, Any> = [
            "key1":"value1",
            "key2":"value2"
        ]

        // JSONX from a dictionary
        let jsonXOptionalFromDictionary:JSONX? = testDictionary.toJSONX(context:"test_DictionaryToJSONX")

        guard let jsonx:JSONX = jsonXOptionalFromDictionary else { print("Failed to create JSONX object!"); return }

        // the tests, key path
        XCTAssertEqual(jsonx.asString(inKeyPath:"key1", default:"Default str 1"), "value1", "Test `asString` failed!")
        XCTAssertEqual(jsonx.asString(inKeyPath:"key2", default:"Default str 2"), "value2", "Test `asString` failed!")
    }
}

