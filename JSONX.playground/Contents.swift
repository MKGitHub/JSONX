//
//  JSONX
//  Copyright © 2016 Mohsan Khan. All rights reserved.
//

//
//  https://github.com/MKGitHub/JSONX
//  http://www.xybernic.com
//  http://www.khanofsweden.com
//

//
//  Copyright 2016 Mohsan Khan
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation


func ExampleUsage()
{
    print("Example Usage:\n")

    // init with String
    let jsonXOptionalFromString:JSONX? = JSONX(with:"{'name':'Khan Solo'}", usesSingleQuotes:true)
    guard let jsonXFromString:JSONX = jsonXOptionalFromString else { print("Failed to create JSONX object!"); return }
    print("JSONX with String:", jsonXFromString.description(), "\n")

    // init with file contents at URL
    let filePath:String = Bundle.main.path(forResource:"example", ofType:"json")!
    let url:URL = URL(fileURLWithPath:filePath)
    let jsonXOptionalFileURL:JSONX? = JSONX(with:url)
    guard let jsonXFromFileURL:JSONX = jsonXOptionalFileURL else { print("Failed to create JSONX object!"); return }
    print("JSONX with file contents at URL:", jsonXFromFileURL.description(), "\n")

    // init with Data
    let data:Data? = JSONX.convertSingleQuotesToDoubleQuotes("{'name':'Khan Solo'}").data(using:String.Encoding.utf8)
    let jsonXOptionalFromData:JSONX? = JSONX(with:data!)
    guard let jsonXFromData = jsonXOptionalFromData else { print("Failed to create JSONX object!"); return }
    print("JSONX with Data:", jsonXFromData.description(), "\n")

    // init with Dictionary<String, Any>
    let jsonXOptionalFromDictionary:JSONX? = JSONX(with:["name":"Khan Solo", "level":50, "skills":[1,2,3], "droids":["shiny":9]])
    guard let jsonXFromDictionary:JSONX = jsonXOptionalFromDictionary else { print("Failed to create JSONX object!"); return }
    print("JSONX with Dictionary<String, Any>:", jsonXFromDictionary.description())

    print("\n")
}


func RunTestSuit1()
{
    print("Run Test Suit 1:")

    print("Test with wrong quotes should fail = ")

    // init with String
    let jsonXOptionalFromString1:JSONX? = JSONX(with:"{'name':'Khan Solo'}" /* , usesSingleQuotes:true */)
    let jsonXOptionalFromString2:JSONX? = JSONX(with:"{'name':'Khan Solo'}", usesSingleQuotes:true)

    // the tests
    assert((jsonXOptionalFromString1 == nil), "Should be nil because we use single quotes instead of the default double quotes!")
    assert((jsonXOptionalFromString2 != nil), "Should not be nil because we use single quotes!")

    print("All tests passed √\n\n")
}


func RunTestSuit2()
{
    print("Run Test Suit 2:")

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
    assert(jsonx.asBool("testBoolTrue") == true, "Test `asBool` failed!")
    assert(jsonx.asBool("testBoolFalse") == false, "Test `asBool` failed!")

    assert(jsonx.asUInt("testUInt") == 100, "Test `asUInt` failed!")

    assert(jsonx.asInt("testInt") == -100, "Test `asInt` failed!")

    assert(jsonx.asFloat("testFloat") == 12.3456, "Test `asFloat` failed!")

    assert(jsonx.asDouble("testDouble") == 12.3456789, "Test `asDouble` failed!")

    assert(jsonx.asString("testString") == "ThisStringWorks", "Test `asString` failed!")

    zip(jsonx.asArray("testArray")!, ["abc", 123, true]).map
    {
        (e1:Any, e2:Any) in
        assert((e1 as AnyObject).isEqual(e2), "Test `asArray` failed!")
    }

    let testNSDict1:Dictionary<String, Any> = jsonx.asDictionary("testDictionary")!
    let testNSDict2:Dictionary<String, Any> = ["abc":123, "xyz":true, "foo":12.3456]
    assert(NSDictionary(dictionary:testNSDict1).isEqual(to:testNSDict2), "Test `asDictionary` failed!")

    print("All tests passed √\n\n")
}


func RunTestSuit3()
{
    print("Run Test Suit 3:")

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
    assert((foundValue1 as! String) == "Cute little baby!", "Test `asRaw` 1 failed!")

    assert(jsonx.asRaw(inKeyPath:"", usingDelimiter:".") == nil, "Test `asRaw` 2 failed!")

    assert(jsonx.asRaw(inKeyPath:".testKeyPath", usingDelimiter:".") == nil, "Test `asRaw` 3 failed!")

    assert(jsonx.asRaw(inKeyPath:"testKeyPath.", usingDelimiter:".") == nil, "Test `asRaw` 4 failed!")

    assert(jsonx.asRaw(inKeyPath:"nonExistingKey", usingDelimiter:".") == nil, "Test `asRaw` 4 failed!")

    assert(jsonx.asRaw(inKeyPath:"testKeyPath.parent.child.grandChild.nonExistingKey") == nil, "Test `asRaw` 5 failed!")

    let foundValue2:Any? = jsonx.asRaw(inKeyPath:"testKeyPath->parent->child->grandChild", usingDelimiter:"->")
    assert((foundValue2 as! String) == "Cute little baby!", "Test `asRaw` 6 failed!")

    assert(jsonx.asRaw(inKeyPath:"testKeyPath.parent.child.grandChild", usingDelimiter:"") == nil, "Test `asRaw` 7 failed!")

    assert(jsonx.asRaw(inKeyPath:"testKeyPath.parent.child.grandChild", usingDelimiter:"_") == nil, "Test `asRaw` 8 failed!")

    //

    assert(jsonx.asBool(inKeyPath:"testKeyPath.parent.child.testBoolTrue") == true, "Test `asBool` failed!")

    assert(jsonx.asBool(inKeyPath:"testKeyPath.parent.child.testBoolFalse") == false, "Test `asBool` failed!")

    assert(jsonx.asUInt(inKeyPath:"testKeyPath.parent.child.testUInt") == 100, "Test `asUInt` failed!")

    assert(jsonx.asInt(inKeyPath:"testKeyPath.parent.child.testInt") == -100, "Test `asInt` failed!")

    assert(jsonx.asFloat(inKeyPath:"testKeyPath.parent.child.testFloat") == 12.3456, "Test `asFloat` failed!")

    assert(jsonx.asDouble(inKeyPath:"testKeyPath.parent.child.testDouble") == 12.3456789, "Test `asDouble` failed!")

    assert(jsonx.asString(inKeyPath:"testKeyPath.parent.child.testString") == "ThisStringWorks", "Test `asString` failed!")

    zip(jsonx.asArray(inKeyPath:"testKeyPath.parent.child.testArray")!, ["abc", 123, true]).map
    {
        (e1:Any, e2:Any) in
        assert((e1 as AnyObject).isEqual(e2), "Test `asArray` failed!")
    }

    let testNSDict1:Dictionary<String, Any> = jsonx.asDictionary(inKeyPath:"testKeyPath.parent.child.testDictionary")!
    let testNSDict2:Dictionary<String, Any> = ["abc":123, "xyz":true, "foo":12.3456]
    assert(NSDictionary(dictionary:testNSDict1).isEqual(to:testNSDict2), "Test `asDictionary` failed!")

    print("All tests passed √\n\n")
}


func RunTestSuit4()
{
    print("Run Test Suit 4:")

    // test data
    let testDictionary:Dictionary<String, Any> = [:]

    // init with Dictionary<String, Any>
    let jsonXOptionalFromDictionary:JSONX? = JSONX(with:testDictionary)

    guard let jsonx:JSONX = jsonXOptionalFromDictionary else { print("Failed to create JSONX object!"); return }

    // the tests
    assert(jsonx.asBool("nonExistingKey", default:true) == true, "Test `asBool` failed!")

    assert(jsonx.asUInt("nonExistingKey", default:100) == 100, "Test `asUInt` failed!")

    assert(jsonx.asInt("nonExistingKey", default:-100) == -100, "Test `asInt` failed!")

    assert(jsonx.asFloat("nonExistingKey", default:12.3456) == 12.3456, "Test `asFloat` failed!")

    assert(jsonx.asDouble("nonExistingKey", default:12.3456789) == 12.3456789, "Test `asDouble` failed!")

    assert(jsonx.asString("nonExistingKey", default:"Default string") == "Default string", "Test `asString` failed!")

    zip(jsonx.asArray("nonExistingKey", default:["abc", 123, true])!, ["abc", 123, true]).map
    {
        (e1:Any, e2:Any) in
        assert((e1 as AnyObject).isEqual(e2), "Test `asArray` failed!")
    }

    let testNSDict2:Dictionary<String, Any> = ["abc":123, "xyz":true, "foo":12.3456]
    let testNSDict1:Dictionary<String, Any> = jsonx.asDictionary("nonExistingKey", default:testNSDict2)!
    assert(NSDictionary(dictionary:testNSDict1).isEqual(to:testNSDict2), "Test `asDictionary` failed!")

    print("All tests passed √\n\n")
}


func RunTestSuit5()
{
    print("Run Test Suit 5:")

    // test data
    let testDictionary:Dictionary<String, Any> = [:]

    // init with Dictionary<String, Any>
    let jsonXOptionalFromDictionary:JSONX? = JSONX(with:testDictionary)

    guard let jsonx:JSONX = jsonXOptionalFromDictionary else { print("Failed to create JSONX object!"); return }

    // the tests
    assert(jsonx.asRaw(inKeyPath:"nonExistingKey", default:"raw food", usingDelimiter:".") as? String == "raw food", "Test `asRaw` failed!")

    assert(jsonx.asBool(inKeyPath:"nonExistingKey", default:true, usingDelimiter:".") == true, "Test `asBool` failed!")

    assert(jsonx.asBool(inKeyPath:"nonExistingKey", default:false, usingDelimiter:".") == false, "Test `asBool` failed!")

    assert(jsonx.asUInt(inKeyPath:"nonExistingKey", default:100, usingDelimiter:".") == 100, "Test `asUInt` failed!")

    assert(jsonx.asInt(inKeyPath:"nonExistingKey", default:-100, usingDelimiter:".") == -100, "Test `asInt` failed!")

    assert(jsonx.asFloat(inKeyPath:"nonExistingKey", default:12.34, usingDelimiter:".") == 12.34, "Test `asFloat` failed!")

    assert(jsonx.asDouble(inKeyPath:"nonExistingKey", default:12.3456789, usingDelimiter:".") == 12.3456789, "Test `asDouble` failed!")

    assert(jsonx.asString(inKeyPath:"nonExistingKey", default:"Default str", usingDelimiter:".") == "Default str", "Test `asRaw` failed!")

    zip(jsonx.asArray(inKeyPath:"nonExistingKey", default:["abc", 123, true])!, ["abc", 123, true]).map
    {
        (e1:Any, e2:Any) in
        assert((e1 as AnyObject).isEqual(e2), "Test `asArray` failed!")
    }

    let testNSDict2:Dictionary<String, Any> = ["abc":123, "xyz":true, "foo":12.3456]
    let testNSDict1:Dictionary<String, Any> = jsonx.asDictionary(inKeyPath:"nonExistingKey", default:testNSDict2)!
    assert(NSDictionary(dictionary:testNSDict1).isEqual(to:testNSDict2), "Test `asDictionary` failed!")

    print("All tests passed √\n\n")
}


ExampleUsage()
RunTestSuit1()
RunTestSuit2()
RunTestSuit3()
RunTestSuit4()
RunTestSuit5()


/*
    Console Output – Xcode 8.0 (8A218a), Swift 3.0, 2016-Oct-14
     ̅‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
    Example Usage:

    JSONX with String: ["name": Khan Solo]

    JSONX with file contents at URL: ["testString": Hello World!, "testStatus": 1, "testArray": <__NSArrayI 0x7fcdea668520>(
    First,
    2,
    {
        third = 4;
    }
    )
    , "testDictionary": {
        level = 200;
        name = "Khan Solo";
    }] 

    JSONX with Data: ["name": Khan Solo] 

    JSONX with Dictionary<String, Any>: ["name": "Khan Solo", "level": 50, "skills": [1, 2, 3], "droids": ["shiny": 9]]


    Run Test Suit 1:
    Test with wrong quotes should fail = 
    JSONX failed: The data couldn’t be read because it isn’t in the correct format.
    All tests passed √


    Run Test Suit 2:
    All tests passed √


    Run Test Suit 3:
    All tests passed √


    Run Test Suit 4:
    All tests passed √


    Run Test Suit 5:
    All tests passed √
*/













































