import Foundation
import SystemConfiguration

open class VPNServiceConfig: NSObject {
  public var type: UInt8 = 0
  public var serviceID: String?
  public var name: String?
  public var endpoint: String?
  public var username: String?
  public var password: String?
  public var sharedSecret: String?
  public var localIdentifier: String?
  public var enableSplitTunnel: Bool = false
  public var disconnectOnSwitch: Bool = false
  public var disconnectOnLogout: Bool = false
  
  public var humanType: String?
  
  public var l2TPPPPConfig: CFDictionary {
    var keys: [CFString?] = [nil, nil, nil, nil, nil, nil]
    var vals: [CFString?] = [nil, nil, nil, nil, nil, nil]
    var count = CFIndex(0)
    
    keys[count] = kSCPropNetPPPCommRemoteAddress
    vals[count] = endpoint as CFString?
    count += 1
    
    keys[count] = kSCPropNetPPPAuthName
    vals[count] = username as CFString?
    count += 1
    
    keys[count] = kSCPropNetPPPAuthPassword
    vals[count] = serviceID as CFString?
    count += 1
    
    keys[count] = kSCPropNetPPPAuthPasswordEncryption
    vals[count] = kSCValNetPPPAuthPasswordEncryptionKeychain
    count += 1
    
    let switchOne = disconnectOnSwitch ? "1" : "0"
    keys[count] = kSCPropNetPPPDisconnectOnFastUserSwitch
    // CFNumber is the correct type I think, as you can verify in the resulting /Library/Preferences/SystemConfiguration/preferences.plist file.
    // However, the documentation says CFString, so I'm not sure whom to believe.
    // See https://developer.apple.com/documentation/systemconfiguration/kscpropnetpppdisconnectonfastuserswitch
    // See also https://developer.apple.com/library/prerelease/ios/documentation/CoreFoundation/Conceptual/CFPropertyLists/Articles/Numbers.html
    // vals[count] = (CFNumberCreate(nil, CFNumberType.intType, &switchOne) as! CFString)
    vals[count] = switchOne as CFString?
    count += 1
    
    let logoutOne = disconnectOnLogout ? "1" : "0"
    keys[count] = kSCPropNetPPPDisconnectOnLogout
    // vals[count] = (CFNumberCreate(nil, CFNumberType.intType, &logoutOne) as! CFString)
    vals[count] = logoutOne as CFString?
    count += 1
    
    let d = [
        keys,
        vals,
        count,
        kCFTypeDictionaryKeyCallBacks,
        kCFTypeDictionaryValueCallBacks
      ] as! CFDictionary
    
    return d
    
    //return CFDictionaryCreate(nil, &keys, &vals, count, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks)
  }
  
  public var l2TPIPSecConfig: CFDictionary? {
    return nil
  }

  public var l2TPIPv4Config: CFDictionary? {
    return nil
  }

  public var ciscoConfig: CFDictionary? {
    return nil
  }
}
