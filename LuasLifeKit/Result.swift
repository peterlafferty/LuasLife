//
//  Result.swift
//  LuasLife
//
//  Created by Peter Lafferty on 29/02/2016.
//  Copyright © 2016 Peter Lafferty. All rights reserved.
//

import Foundation

/**
 Used to represent whether an asynchronous request was successful or encountered an error.
 
 - Success: The request was successful.
 - Error: The request failed
 */

public enum Result<T> {
    case Success(T)
    case Error(ErrorType)
}
