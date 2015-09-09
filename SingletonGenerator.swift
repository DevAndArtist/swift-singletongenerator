//
//  SingletonGenerator.swift
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Adrian Zubarev (a.k.a. DevAndArtist)
//  Created on 06.07.15.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

public protocol SingletonType { /* private */ init() } // wait for this feature to create a true singleton

private var singletonInstances = [String: SingletonType]()

public extension SingletonType {
	
	typealias SingletonInstance = Self
	typealias SingletonMetatype = Self.Type
	
	public static var getSingleton: SingletonInstance { return setSingleton { $0 } }
	
	public static var setSingleton: SingletonMetatype { return self }
	
	public static func setSingleton(setter: (_: SingletonInstance) -> SingletonInstance) -> SingletonInstance {
		
		guard let instance = singletonInstances["\(self)"] as? Self else {
			
			return setInstance(self.init(), withSetter: setter, overridable: true)
		}
		return setInstance(instance, withSetter: setter, overridable: false)
	}
	
	private static func setInstance(var instance: Self, withSetter setter: (_: Self) -> Self, overridable: Bool) -> Self {
		
		instance = restoreInstanceIfNeeded(instance1: instance, instance2: setter(instance), overridable: overridable)
		
		singletonInstances["\(self)"] = instance
		
		return instance
	}
	
	private static func restoreInstanceIfNeeded(instance1 i1: Self, instance2 i2: Self, overridable: Bool) -> Self {
		// i1.dynamicType is AnyClass is bugged in Swift 2.0 beta
		guard i1.dynamicType is AnyClass else { return i2 }
		
		return ((i1 as! AnyObject) !== (i2 as! AnyObject)) && !overridable ? i1 : i2
	}
}

infix operator « { associativity none }

func « <Instance: SingletonType>(type: Instance.Type, newInstance: Instance) -> Instance {
	
	return type.setSingleton { (_) -> Instance in newInstance }
}
