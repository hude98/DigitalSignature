//
//  UserDefaultValue.swift
//  Habitify
//
//  Created by Peter Vu on 4/16/20.
//  Copyright © 2020 Peter Vu. All rights reserved.
//

import Foundation

public protocol UserDefaultValue { }
extension Int: UserDefaultValue {  }
extension Float: UserDefaultValue {  }
extension Double: UserDefaultValue {  }
extension String: UserDefaultValue {  }
extension Bool: UserDefaultValue {  }
extension Date: UserDefaultValue {  }
extension Data: UserDefaultValue {  }

extension Optional: UserDefaultValue where Wrapped: UserDefaultValue { }
