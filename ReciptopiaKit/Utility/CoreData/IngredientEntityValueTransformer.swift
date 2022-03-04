//
//  ReciptopiaValueTransformer.swift
//  ReciptopiaKit
//
//  Created by 김세영 on 2022/03/03.
//

import Foundation
import CoreData

@objc(IngredientEntityValueTransformer)
public class IngredientEntityValueTransformer: NSSecureUnarchiveFromDataTransformer {
  
  public override class func transformedValueClass() -> AnyClass { return IngredientEntities.self }
  
  public override class func allowsReverseTransformation() -> Bool { return true }
  
//  public override func transformedValue(_ value: Any?) -> Any? {
//    print("\(#function) check nil")
//    guard let value = value as? IngredientEntities else {
//      print("\(#function) -> nil")
//      return nil
//    }
//    return try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true)
//  }
//  
//  public override func reverseTransformedValue(_ value: Any?) -> Any? {
//    print("\(#function) check nil")
//    guard let data = value as? NSData else {
//      print("\(#function) -> nil")
//      return nil
//    }
//    
//    let result = try? NSKeyedUnarchiver.unarchivedObject(ofClass: IngredientEntities.self, from: data as Data)
//    return result
//  }
  
  
  public static var transformerName: NSValueTransformerName {
    let className = "\(Self.self.classForCoder())"
    return NSValueTransformerName("\(className)")
  }
  
  public static func registerTransformer() {
    let transformer = IngredientEntityValueTransformer()
    print(transformerName.rawValue)
    ValueTransformer.setValueTransformer(transformer, forName: transformerName)
  }
}
