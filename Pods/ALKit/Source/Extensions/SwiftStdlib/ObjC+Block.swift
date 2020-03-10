//
//                            Open Your Mind!
//
//                  .-~~~~~~~~~-._       _.-~~~~~~~~~-.
//              __.'              ~.   .~              `.__
//            .'//                  \./                  \\`.
//          .'//                     |                     \\`.
//        .'// .-~"""""""~~~~-._     |     _,-~~~~"""""""~-. \\`.
//      .'//.-"                 `-.  |  .-'                 "-.\\`.
//    .'//______.============-..   \ | /   ..-============.______\\`.
//  .'______________________________\|/______________________________`.
//
//  ObjC+Block.swift
//  ALAppCodesSwift
//
//  Created by Alirio.Lau on 2019/12/26.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import Foundation

public class ObjcBlock {
  private let block: AnyObject
  private(set) var signature: MethodSignature?

  var objcSignature: AnyObject? { signature?.objcMethodSignature }

  init(_ block: AnyObject) {
    self.block = block
    typeEncoding.map { signature = MethodSignature(objCTypes: $0) }
  }

  private var typeEncoding: String? {
    let block = unsafeBitCast(self.block, to: UnsafePointer<BlockInfo>.self).pointee
    let descriptor = block.descriptor.pointee

    //let copyDisposeHelperFlag: UInt32 = 1 << 25
    let signatureFlag: UInt32 = 1 << 30

    if block.flags & signatureFlag != 0 {
      let signature = String(cString: descriptor.signature)
      return signature
    }

    return nil
  }

  private struct BlockInfo {
    var isa: UnsafeRawPointer
    var flags: UInt32
    var reserved: UInt32
    var invoke: UnsafeRawPointer
    var descriptor: UnsafePointer<BlockDescriptor>
  }

  private struct BlockDescriptor {
    var reserved: UInt
    var size: UInt

    var copy_helper: UnsafeRawPointer
    var dispose_helper: UnsafeRawPointer
    var signature: UnsafePointer<Int8>
    var layout: UnsafePointer<Int8>
  }
}
