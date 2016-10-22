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


public final class JSONX
{
    // MARK: Private Members
    fileprivate let mJSONDictionary:Dictionary<String, Any>!


    // MARK:- Life Cycle


    ///
    /// Init with `String`.
    ///
    public convenience init?(with inString:String, usesSingleQuotes:Bool=false)
    {
        // must have a string
        guard (inString.characters.count > 0) else { return nil }

        var stringToUse:String = inString

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
    /// Init with file contents at path.
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
    /// Init with file contents at `URL`.
    ///
    public convenience init?(with inFileURL:URL)
    {
        do
        {
            let data:Data = try Data(contentsOf:inFileURL)

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
    public init?(with inData:Data)
    {
        do
        {
            let dictionary:Dictionary<String, Any> = try JSONSerialization.jsonObject(with:inData, options:[.allowFragments]) as! Dictionary<String, Any>

            // must have a dictionary
            guard (dictionary.count > 0) else { return nil }

            mJSONDictionary = dictionary
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
    public init?(with inDictionary:Dictionary<String, Any>)
    {
        // must have a dictionary
        guard (inDictionary.count > 0) else { return nil }

        mJSONDictionary = inDictionary
    }


    /*deinit
    {
        print("JSONX deinit")
    }*/


    // MARK:- Accessors


    ///
    /// Return the keys value as it is in its raw format in JSON.
    /// I.e. there is no casting to a specific type like in the other "as" functions.
    ///
    public func asRaw(_ key:String, `default`:Any?=nil)
    -> Any?
    {
        let anyOptionalValue:Any? = mJSONDictionary[key]

        guard (anyOptionalValue != nil) else { return `default` }

        return anyOptionalValue
    }


    ///
    /// Return the keys value as a *Bool*.
    ///
    public func asBool(_ key:String, `default`:Bool?=nil)
    -> Bool?
    {
        let anyOptionalValue:Any? = mJSONDictionary[key]

        guard (anyOptionalValue != nil) else { return `default` }

        return (anyOptionalValue as? Bool)
    }


    ///
    /// Return the keys value as an *UInt*.
    ///
    public func asUInt(_ key:String, `default`:UInt?=nil)
    -> UInt?
    {
        let anyOptionalValue:Any? = mJSONDictionary[key]

        guard (anyOptionalValue != nil) else { return `default` }

        return UInt((anyOptionalValue as? Int)!)
    }


    ///
    /// Return the keys value as an *Int*.
    ///
    public func asInt(_ key:String, `default`:Int?=nil)
    -> Int?
    {
        let anyOptionalValue:Any? = mJSONDictionary[key]

        guard (anyOptionalValue != nil) else { return `default` }

        return (anyOptionalValue as? Int)
    }


    ///
    /// Return the keys value as a *Float*.
    ///
    public func asFloat(_ key:String, `default`:Float?=nil)
    -> Float?
    {
        let anyOptionalValue:Any? = mJSONDictionary[key]

        guard (anyOptionalValue != nil) else { return `default` }

        return Float((anyOptionalValue as? Double)!)
    }


    ///
    /// Return the keys value as a *Double*.
    ///
    public func asDouble(_ key:String, `default`:Double?=nil)
    -> Double?
    {
        let anyOptionalValue:Any? = mJSONDictionary[key]

        guard (anyOptionalValue != nil) else { return `default` }

        return (anyOptionalValue as? Double)
    }


    ///
    /// Return the keys value as a *String*.
    ///
    public func asString(_ key:String, `default`:String?=nil)
    -> String?
    {
        let anyOptionalValue:Any? = mJSONDictionary[key]

        guard (anyOptionalValue != nil) else { return `default` }

        return (anyOptionalValue as? String)
    }


    ///
    /// Return the keys value as an *Array*.
    ///
    public func asArray(_ key:String, `default`:Array<Any>?=nil)
    -> Array<Any>?
    {
        let anyOptionalValue:Any? = mJSONDictionary[key]

        guard (anyOptionalValue != nil) else { return `default` }

        return (anyOptionalValue as? Array<Any>)
    }


    ///
    /// Return the keys value as a *Dictionary*.
    ///
    public func asDictionary(_ key:String, `default`:Dictionary<String, Any>?=nil)
    -> Dictionary<String, Any>?
    {
        let anyOptionalValue:Any? = mJSONDictionary[key]

        guard (anyOptionalValue != nil) else { return `default` }

        return (anyOptionalValue as? Dictionary<String, Any>)
    }


    // MARK:- Key Path Accessors


    ///
    /// Return the keys value in the key path as it is in its raw format in JSON.
    /// I.e. there is no casting to a specific type like in the other "find" functions.
    ///
    public func asRaw(inKeyPath keyPath:String, `default`:Any?=nil, usingDelimiter delimiter:String=".")
    -> Any?
    {
        // must have a key path
        guard (keyPath.characters.count > 0) else { return `default` }

        // key path must not begin with the delimiter
        guard (keyPath.hasPrefix(delimiter) == false) else { return `default` }

        // key path must not end with the delimiter
        guard (keyPath.hasSuffix(delimiter) == false) else { return `default` }

        let keyPathComponents:[String] = keyPath.components(separatedBy:delimiter)

        let searchResult:Any? = searchDictionary(keyPathComponents:keyPathComponents, keyPathIndex:0, dictionary:mJSONDictionary)
        guard (searchResult != nil) else { return `default` }

        return searchResult
    }


    ///
    /// Return the keys value in the key path as a *Bool*.
    ///
    public func asBool(inKeyPath keyPath:String, `default`:Bool?=nil, usingDelimiter delimiter:String=".")
    -> Bool?
    {
        let anyOptionalValue:Any? = asRaw(inKeyPath:keyPath, usingDelimiter:delimiter)

        guard (anyOptionalValue != nil) else { return `default` }

        return (anyOptionalValue as? Bool)
    }


    ///
    /// Return the keys value in the key path as a *UInt*.
    ///
    public func asUInt(inKeyPath keyPath:String, `default`:UInt?=nil, usingDelimiter delimiter:String=".")
    -> UInt?
    {
        let anyOptionalValue:Any? = asRaw(inKeyPath:keyPath, usingDelimiter:delimiter)

        guard (anyOptionalValue != nil) else { return `default` }

        return UInt((anyOptionalValue as? Int)!)
    }


    ///
    /// Return the keys value in the key path as a *Int*.
    ///
    public func asInt(inKeyPath keyPath:String, `default`:Int?=nil, usingDelimiter delimiter:String=".")
    -> Int?
    {
        let anyOptionalValue:Any? = asRaw(inKeyPath:keyPath, usingDelimiter:delimiter)

        guard (anyOptionalValue != nil) else { return `default` }

        return (anyOptionalValue as? Int)
    }


    ///
    /// Return the keys value in the key path as a *Float*.
    ///
    public func asFloat(inKeyPath keyPath:String, `default`:Float?=nil, usingDelimiter delimiter:String=".")
    -> Float?
    {
        let anyOptionalValue:Any? = asRaw(inKeyPath:keyPath, usingDelimiter:delimiter)

        guard (anyOptionalValue != nil) else { return `default` }

        return Float((anyOptionalValue as? Double)!)
    }


    ///
    /// Return the keys value in the key path as a *Double*.
    ///
    public func asDouble(inKeyPath keyPath:String, `default`:Double?=nil, usingDelimiter delimiter:String=".")
    -> Double?
    {
        let anyOptionalValue:Any? = asRaw(inKeyPath:keyPath, usingDelimiter:delimiter)

        guard (anyOptionalValue != nil) else { return `default` }

        return (anyOptionalValue as? Double)
    }


    ///
    /// Return the keys value in the key path as a *String*.
    ///
    public func asString(inKeyPath keyPath:String, `default`:String?=nil, usingDelimiter delimiter:String=".")
    -> String?
    {
        let anyOptionalValue:Any? = asRaw(inKeyPath:keyPath, usingDelimiter:delimiter)

        guard (anyOptionalValue != nil) else { return `default` }

        return (anyOptionalValue as? String)
    }


    ///
    /// Return the keys value in the key path as a *Array*.
    ///
    public func asArray(inKeyPath keyPath:String, `default`:Array<Any>?=nil, usingDelimiter delimiter:String=".")
    -> Array<Any>?
    {
        let anyOptionalValue:Any? = asRaw(inKeyPath:keyPath, usingDelimiter:delimiter)

        guard (anyOptionalValue != nil) else { return `default` }

        return (anyOptionalValue as? Array<Any>)
    }


    ///
    /// Return the keys value in the key path as a *Dictionary*.
    ///
    public func asDictionary(inKeyPath keyPath:String, `default`:Dictionary<String, Any>?=nil, usingDelimiter delimiter:String=".")
    -> Dictionary<String, Any>?
    {
        let anyOptionalValue:Any? = asRaw(inKeyPath:keyPath, usingDelimiter:delimiter)

        guard (anyOptionalValue != nil) else { return `default` }

        return (anyOptionalValue as? Dictionary<String, Any>)
    }


    // MARK:- Private


    fileprivate func searchDictionary(keyPathComponents:[String], keyPathIndex:Int, dictionary:Dictionary<String, Any>)
    -> Any?
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
                    if let d = dictValue as? Dictionary<String, Any>
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


    public class func convertSingleQuotesToDoubleQuotes(_ text:String)
    -> String
    {
        return text.replacingOccurrences(of:"'", with:"\"")
    }


    // MARK:- Info


    public func description()
    -> String
    {
        return mJSONDictionary.description
    }
}

