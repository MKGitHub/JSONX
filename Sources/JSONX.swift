//
//  JSONX
//  Copyright © 2016/2017 Mohsan Khan. All rights reserved.
//

//
//  https://github.com/MKGitHub/JSONX
//  http://www.xybernic.com
//  http://www.khanofsweden.com
//

//
//  Copyright 2016/2017 Mohsan Khan
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


///
/// The core class of JSONX.
///
public final class JSONX
{
    // MARK: Private Members
    fileprivate let mJSONDictionary:Dictionary<String, Any>!
    fileprivate let mJSONNSDictionary:NSDictionary!


    // MARK:- Life Cycle


    ///
    /// Init with `String`.
    ///
    /// - Parameter initString: The string to init JSONX with.
    /// - Parameter usesSingleQuotes: Set to true and use single quotes in the string without the need to escape double quotes.
    ///
    public convenience init?(with initString:String, usesSingleQuotes:Bool=false)
    {
        // must have a string
        guard (initString.count > 0) else { return nil }

        var stringToUse:String = initString

        if (usesSingleQuotes) {
            stringToUse = JSONX.convertSingleQuotesToDoubleQuotes(stringToUse)
        }

        guard let data:Data = stringToUse.data(using:.utf8) else
        {
            print("JSONX failed: Could not convert string to JSON!")
            return nil
        }

        self.init(with:data)
    }


    ///
    /// Init with file path.
    ///
    /// - Parameter filepath: A path to a file.
    ///
    public convenience init?(with filepath:String)
    {
        do
        {
            let fileContents:String = try String(contentsOfFile:filepath, encoding:.utf8)

            if let data:Data = fileContents.data(using:.utf8)
            {
                self.init(with:data)
                return
            }

            return nil
        }
        catch let error
        {
            print("JSONX failed: \(error.localizedDescription)")
            return nil
        }
    }


    ///
    /// Init with file `URL`.
    ///
    /// - Parameter fileURL: An URL to a file.
    ///
    public convenience init?(with fileURL:URL)
    {
        do
        {
            let data:Data = try Data(contentsOf:fileURL)

            self.init(with:data)
        }
        catch let error
        {
            print("JSONX failed: \(error.localizedDescription)")
            return nil
        }
    }


    ///
    /// Init with `Data`.
    ///
    /// - Parameter initData: `Data` object.
    ///
    public init?(with initData:Data)
    {
        do
        {
            let dictionary:Dictionary<String, Any> = try JSONSerialization.jsonObject(with:initData, options:[.allowFragments]) as! Dictionary<String, Any>

            // must have a dictionary
            guard (dictionary.count > 0) else { return nil }

            mJSONDictionary = dictionary
            mJSONNSDictionary = dictionary as NSDictionary!
        }
        catch let error
        {
            print("JSONX failed: \(error.localizedDescription)")
            return nil
        }
    }


    ///
    /// Init with `Dictionary`.
    ///
    /// - Parameter initDictionary: `Dictionary` object.
    ///
    public init?(with initDictionary:Dictionary<String, Any>)
    {
        // must have a dictionary
        guard (initDictionary.count > 0) else { return nil }

        mJSONDictionary = initDictionary
        mJSONNSDictionary = initDictionary as NSDictionary!
    }


    /*deinit
    {
        print("JSONX deinit")
    }*/


    // MARK:- Accessors:Key


    ///
    /// The value as it is in its raw uncasted format.
    /// I.e. there is no casting to a specific type like in the other "as" functions.
    ///
    /// - Parameters:
    ///   - key: The key.
    ///   - `default`: Default value if the key is not found.
    /// - Returns: The value for the key, or the default value.
    ///
    public func asRaw(_ key:String, `default`:Any?=nil) -> Any?
    {
        // if key exists and value is a Any return Any
        // if key exists and value is null return `default`
        // if key does not exist, return `default`
        let v:Any? = mJSONDictionary[key]

        if (!(v is NSNull) && (v != nil))
        {
            return v
        }
        else {
            return `default`
        }
    }


    ///
    /// The value as a `Bool`.
    ///
    /// - Parameters:
    ///   - key: The key.
    ///   - `default`: Default value if the key is not found.
    /// - Returns: The value for the key, or the default value.
    ///
    public func asBool(_ key:String, `default`:Bool?=nil) -> Bool?
    {
        // if key exists and value is a Bool return Bool
        // if key exists and value is null return `default`
        // if key does not exist, return `default`
        if let v:Bool = mJSONDictionary[key] as? Bool
        {
            return v
        }
        else {
            return `default`
        }
    }


    ///
    /// The value as a `UInt`.
    ///
    /// - Parameters:
    ///   - key: The key.
    ///   - `default`: Default value if the key is not found.
    /// - Returns: The value for the key, or the default value.
    ///
    public func asUInt(_ key:String, `default`:UInt?=nil) -> UInt?
    {
        // if key exists and value is a UInt return UInt
        // if key exists and value is null return `default`
        // if key does not exist, return `default`
        if let v:Int = mJSONDictionary[key] as? Int, (v >= 0)
        {
            return UInt(v)
        }
        else {
            return `default`
        }
    }


    ///
    /// The value as a `Int`.
    ///
    /// - Parameters:
    ///   - key: The key.
    ///   - `default`: Default value if the key is not found.
    /// - Returns: The value for the key, or the default value.
    ///
    public func asInt(_ key:String, `default`:Int?=nil) -> Int?
    {
        // if key exists and value is a Int return Int
        // if key exists and value is null return `default`
        // if key does not exist, return `default`
        if let v:Int = mJSONDictionary[key] as? Int
        {
            return v
        }
        else {
            return `default`
        }
    }


    ///
    /// The value as a `Float`.
    ///
    /// - Parameters:
    ///   - key: The key.
    ///   - `default`: Default value if the key is not found.
    /// - Returns: The value for the key, or the default value.
    ///
    public func asFloat(_ key:String, `default`:Float?=nil) -> Float?
    {
        // if key exists and value is a Float return Float
        // if key exists and value is null return `default`
        // if key does not exist, return `default`
        if let v:Double = mJSONDictionary[key] as? Double
        {
            return Float(v)    // loss of precision
        }
        else {
            return `default`
        }
    }


    ///
    /// The value as a `Double`.
    ///
    /// - Parameters:
    ///   - key: The key.
    ///   - `default`: Default value if the key is not found.
    /// - Returns: The value for the key, or the default value.
    ///
    public func asDouble(_ key:String, `default`:Double?=nil) -> Double?
    {
        // if key exists and value is a Double return Double
        // if key exists and value is null return `default`
        // if key does not exist, return `default`
        if let v:Double = mJSONDictionary[key] as? Double
        {
            return v
        }
        else {
            return `default`
        }
    }


    ///
    /// The value as a `String`.
    ///
    /// - Parameters:
    ///   - key: The key.
    ///   - `default`: Default value if the key is not found.
    /// - Returns: The value for the key, or the default value.
    ///
    public func asString(_ key:String, `default`:String?=nil) -> String?
    {
        // if key exists and value is a String return String
        // if key exists and value is null return `default`
        // if key does not exist, return `default`
        if let v:String = mJSONDictionary[key] as? String
        {
            return v
        }
        else {
            return `default`
        }
    }


    ///
    /// The value as a `Array`.
    ///
    /// - Parameters:
    ///   - key: The key.
    ///   - `default`: Default value if the key is not found.
    /// - Returns: The value for the key, or the default value.
    ///
    public func asArray(_ key:String, `default`:Array<Any>?=nil) -> Array<Any>?
    {
        // if key exists and value is a Array<Any> return Array<Any>
        // if key exists and value is null return `default`
        // if key does not exist, return `default`
        if let v:Array<Any> = mJSONDictionary[key] as? Array<Any>
        {
            return v
        }
        else {
            return `default`
        }
    }


    ///
    /// The value as a `Dictionary`.
    ///
    /// - Parameters:
    ///   - key: The key.
    ///   - `default`: Default value if the key is not found.
    /// - Returns: The value for the key, or the default value.
    ///
    public func asDictionary(_ key:String, `default`:Dictionary<String, Any>?=nil) -> Dictionary<String, Any>?
    {
        // if key exists and value is a Dictionary<String, Any> return Dictionary<String, Any>
        // if key exists and value is null return `default`
        // if key does not exist, return `default`
        if let v:Dictionary<String, Any> = mJSONDictionary[key] as? Dictionary<String, Any>
        {
            return v
        }
        else {
            return `default`
        }
    }


    // MARK:- Accessors:Key Path


    ///
    /// The value as it is in its raw uncasted format.
    /// I.e. there is no casting to a specific type like in the other "as" functions.
    ///
    /// - Parameters:
    ///   - keyPath: The key path.
    ///   - `default`: Default value if the key in the path is not found.
    /// - Returns: The value for the key path, or the default value.
    ///
    public func asRaw(inKeyPath keyPath:String, `default`:Any?=nil) -> Any?
    {
        ///
        /// Note!
        /// We can't use NSDictionary.value(forKeyPath:keyPath) here since there may be non-existing keys in the path,
        /// and that will make the call crash. Until future fix by Apple.
        ///

        // must have a key path
        guard (keyPath.count > 0) else { return `default` }

        // key path must not begin with the delimiter
        guard (keyPath.hasPrefix(".") == false) else { return `default` }

        // key path must not end with the delimiter
        guard (keyPath.hasSuffix(".") == false) else { return `default` }

        let keyPathComponents:[String] = keyPath.components(separatedBy:".")

        // if key exists and value is a Any return Any
        // if key exists and value is null return `default`
        // if key does not exist, return `default`
        let v:Any? = searchDictionary(keyPathComponents:keyPathComponents, keyPathIndex:0, dictionary:mJSONDictionary)

        if (!(v is NSNull) && (v != nil))
        {
            return v
        }
        else {
            return `default`
        }
    }


    ///
    /// The value as a `Bool`.
    ///
    /// - Parameters:
    ///   - key: The key path.
    ///   - `default`: Default value if the key in the path is not found.
    /// - Returns: The value for the key path, or the default value.
    ///
    public func asBool(inKeyPath keyPath:String, `default`:Bool?=nil) -> Bool?
    {
        // if key exists and value is a Bool return Bool
        // if key exists and value is null return `default`
        // if key does not exist, return `default`
        if let v:Bool = asRaw(inKeyPath:keyPath) as? Bool
        {
            return v
        }
        else {
            return `default`
        }
    }


    ///
    /// The value as a `UInt`.
    ///
    /// - Parameters:
    ///   - key: The key path.
    ///   - `default`: Default value if the key in the path is not found.
    /// - Returns: The value for the key path, or the default value.
    ///
    public func asUInt(inKeyPath keyPath:String, `default`:UInt?=nil) -> UInt?
    {
        // if key exists and value is a UInt return UInt
        // if key exists and value is null return `default`
        // if key does not exist, return `default`
        if let v:Int = asRaw(inKeyPath:keyPath) as? Int, (v >= 0)
        {
            return UInt(v)
        }
        else {
            return `default`
        }
    }


    ///
    /// The value as a `Int`.
    ///
    /// - Parameters:
    ///   - key: The key path.
    ///   - `default`: Default value if the key in the path is not found.
    /// - Returns: The value for the key path, or the default value.
    ///
    public func asInt(inKeyPath keyPath:String, `default`:Int?=nil) -> Int?
    {
        // if key exists and value is a Int return Int
        // if key exists and value is null return `default`
        // if key does not exist, return `default`
        if let v:Int = asRaw(inKeyPath:keyPath) as? Int
        {
            return v
        }
        else {
            return `default`
        }
    }


    ///
    /// The value as a `Float`.
    ///
    /// - Parameters:
    ///   - key: The key path.
    ///   - `default`: Default value if the key in the path is not found.
    /// - Returns: The value for the key path, or the default value.
    ///
    public func asFloat(inKeyPath keyPath:String, `default`:Float?=nil) -> Float?
    {
        // if key exists and value is a Float return Float
        // if key exists and value is null return `default`
        // if key does not exist, return `default`
        if let v:Double = asRaw(inKeyPath:keyPath) as? Double
        {
            return Float(v)    // loss of precision
        }
        else {
            return `default`
        }
    }


    ///
    /// The value as a `Double`.
    ///
    /// - Parameters:
    ///   - key: The key path.
    ///   - `default`: Default value if the key in the path is not found.
    /// - Returns: The value for the key path, or the default value.
    ///
    public func asDouble(inKeyPath keyPath:String, `default`:Double?=nil) -> Double?
    {
        // if key exists and value is a Double return Double
        // if key exists and value is null return `default`
        // if key does not exist, return `default`
        if let v:Double = asRaw(inKeyPath:keyPath) as? Double
        {
            return v
        }
        else {
            return `default`
        }
    }


    ///
    /// The value as a `String`.
    ///
    /// - Parameters:
    ///   - key: The key path.
    ///   - `default`: Default value if the key in the path is not found.
    /// - Returns: The value for the key path, or the default value.
    ///
    public func asString(inKeyPath keyPath:String, `default`:String?=nil) -> String?
    {
        // if key exists and value is a String return String
        // if key exists and value is null return `default`
        // if key does not exist, return `default`
        if let v:String = asRaw(inKeyPath:keyPath) as? String
        {
            return v
        }
        else {
            return `default`
        }
    }


    ///
    /// The value as a `Array`.
    ///
    /// - Parameters:
    ///   - key: The key path.
    ///   - `default`: Default value if the key in the path is not found.
    /// - Returns: The value for the key path, or the default value.
    ///
    public func asArray(inKeyPath keyPath:String, `default`:Array<Any>?=nil) -> Array<Any>?
    {
        // if key exists and value is a Array<Any> return Array<Any>
        // if key exists and value is null return `default`
        // if key does not exist, return `default`
        if let v:Array<Any> = asRaw(inKeyPath:keyPath) as? Array<Any>
        {
            return v
        }
        else {
            return `default`
        }
    }


    ///
    /// The value as a `Dictionary`.
    ///
    /// - Parameters:
    ///   - key: The key path.
    ///   - `default`: Default value if the key in the path is not found.
    /// - Returns: The value for the key path, or the default value.
    ///
    public func asDictionary(inKeyPath keyPath:String, `default`:Dictionary<String, Any>?=nil) -> Dictionary<String, Any>?
    {
        // if key exists and value is a Dictionary<String, Any> return Dictionary<String, Any>
        // if key exists and value is null return `default`
        // if key does not exist, return `default`
        if let v:Dictionary<String, Any> = asRaw(inKeyPath:keyPath) as? Dictionary<String, Any>
        {
            return v
        }
        else {
            return `default`
        }
    }


    // MARK:- Helpers


    ///
    /// Convert all single quotes to escaped double quotes.
    ///
    /// - Parameter text: A string containing single quotes.
    /// - Returns: The string containing escaped double quotes.
    ///
    public class func convertSingleQuotesToDoubleQuotes(_ text:String) -> String
    {
        return text.replacingOccurrences(of:"'", with:"\"")
    }


    // MARK:- Info


    ///
    /// The description of the JSONX contents.
    ///
    /// - Returns: String description of the JSONX contents.
    ///
    public func description() -> String
    {
        return mJSONDictionary.description
    }


    // MARK:- Private


    fileprivate func searchDictionary(keyPathComponents:[String], keyPathIndex:Int, dictionary:Dictionary<String, Any>) -> Any?
    {
        let currentComponentKey:String = keyPathComponents[keyPathIndex]
        let numOfKeyPathComponentIndexes:Int = (keyPathComponents.count - 1)

        for (dictKey, dictValue) in dictionary
        {
            //print("keyPathIndex: \(keyPathIndex) / \(keyPathComponents.count - 1)")
            //print("Component At Level:\(currentComponentKey)    Test = dictKey:\(dictKey)    dictValue:\(dictValue)")

            // key found/match in key path
            if (currentComponentKey == dictKey)
            {
                //print("Matches key path component √\n")

                if (keyPathIndex < numOfKeyPathComponentIndexes)
                {
                    if let d:Dictionary<String, Any> = dictValue as? Dictionary<String, Any>
                    {
                        //print("Continue search…\n")

                        return searchDictionary(keyPathComponents:keyPathComponents, keyPathIndex:(keyPathIndex + 1), dictionary:d)
                    }
                    else
                    {
                        //print("Keypath wants to continue, but dictionary has run out of values…\n")
                    }
                }
                else
                {
                    // found it
                    return dictValue
                }
            }
            else
            {
                // Key not found in key path. //

                //print("No match in key path, continue search…\n")
            }
        }

        return nil
    }
}

