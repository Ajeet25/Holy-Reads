import Foundation

import SystemConfiguration


extension NSDictionary{
    
    private func httpStringRepresentation(value: Any) -> String {
        switch value {
        case let boolean as Bool:
            return boolean ? "true" : "false"
        default:
            return "\(value)"
        }
    }
    
    func dataFromHttpParameters() -> NSData? {
        
        var parameterArray = [String]()
        for (key, value) in self {
            let string = httpStringRepresentation(value: value)
            
            if let escapedString = string.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) {
                parameterArray.append("\(key)=\(escapedString)")
            }
        }
        
        let parameterString = parameterArray.joined(separator: "&")
        #if DEBUG
        print(parameterString)
        #endif
        return parameterString.data(using: String.Encoding.utf8) as NSData?
    }
    
}



class DataManager {
    
    class func isConnectedToNetwork()->Bool{
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
        
    }
    
    class func getVal(_ param:Any!) -> AnyObject {
        
        // let objectClass : AnyClass! = object_getClass(param)
        // let className = objectClass.description()
        
        if param == nil
        {
            return "" as AnyObject
        }
        else if param is NSNull
        {
            return "" as AnyObject
        }
        else if param is NSNumber
        {
            let aString:String = "\(param!)"
            return aString as AnyObject
        }
        else if param is Double
        {
            return "\(param)" as AnyObject
        }
        else
        {
            return param as AnyObject
        }
    }
    
    class func getVal(_ param:AnyObject!,typeObj:AnyObject) -> AnyObject {
        
        // let objectClass : AnyClass! = object_getClass(param)
        // let className = objectClass.description()
        
        if param == nil
        {
            return typeObj
        }
        else if param is NSNull
        {
            return typeObj
        }
        else if param is NSNumber
        {
            return typeObj
        }
        else if param is Double
        {
            return typeObj
        }
        else
        {
            return typeObj
        }
        
    }
    class func saveinDefaults(_ responseData:[String:Any]){
        
        let userId = DataManager.getVal(responseData["user_id"])
        let email = DataManager.getVal(responseData["email"])
        let userName = DataManager.getVal(responseData["username"])
        let profile_picture = DataManager.getVal(responseData["profile_picture"])

        Config().AppUserDefaults.set(userId, forKey: "user_id")
        Config().AppUserDefaults.set(email, forKey: "email")
        Config().AppUserDefaults.set(userName, forKey: "username")
        Config().AppUserDefaults.set(profile_picture, forKey: "profile_picture")

        Config().AppUserDefaults.synchronize()
    }
    class func ClearUserDetails() {
        Config().AppUserDefaults.removeObject(forKey: "user_id")
        Config().AppUserDefaults.removeObject(forKey: "email")
        Config().AppUserDefaults.removeObject(forKey: "username")
        Config().AppUserDefaults.removeObject(forKey: "profile_picture")
        Config().AppUserDefaults.removeObject(forKey: "isCurrentUser")
        Config().AppUserDefaults.removeObject(forKey: "notification_status")
       // Config().AppUserDefaults.removeObject(forKey: "isIntroSkipped")

    }
   
    class func getValForIndex(_ arrayValues:AnyObject!,index:Int) -> AnyObject {
        
        ////print("getVal = \(arrayValues)")
                let arrayVal: AnyObject! = getVal(arrayValues)
        
        if arrayVal is NSArray || arrayVal is NSMutableArray
        {
            let arr = arrayValues as! NSArray
            if index < arr.count {
                return arr.object(at: index) as AnyObject
            }else{
                return "" as AnyObject
            }
        }
        else
        {
            return "" as AnyObject
        }
    }
    
    
    class func JSONStringify(_ value: AnyObject, prettyPrinted: Bool = false) -> String {
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : []
        if JSONSerialization.isValidJSONObject(value) {
            if let data = try? JSONSerialization.data(withJSONObject: value, options: options) {
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }
        }
        return ""
    }
    
    class func getAPIResponseFileSingleImage(_ parameterDictionary :NSMutableDictionary,methodName:NSString, dataArray:NSArray, success: @escaping ((_ iTunesData: NSDictionary?,_ error:NSError?) -> Void)) {
        
        var deviceToken = DataManager.getVal(Config().AppUserDefaults.object(forKey: "deviceToken") as AnyObject?) as! String
        deviceToken = deviceToken == "" ? "a3d96a79b66288250f4cc837e73500f5024c4d702071156f55e54c01684f41bc" : deviceToken
        parameterDictionary.setValue(deviceToken, forKey: "device_id")
        
        let apiPath = "\(Config().API_URL)\(methodName)"
        
        let request = NSMutableURLRequest(url:NSURL(string: apiPath)! as URL);
        request.httpMethod = "POST"
        
        let boundary = self.generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var imageData = Data()
        var imageName  = ""
        
        for dataDict in dataArray {
            let dataDictionary = dataDict as! NSDictionary
            
            imageName = dataDictionary.object(forKey: "image") as! String
            imageData = dataDictionary.object(forKey: "imageData") as! Data
            
        }
        
        var param : [String:String] = [:]
        
        for (key,val) in parameterDictionary {
            param[key as! String] = val as! String
        }
        
        param["device_id"] = deviceToken
        param["device_type"] = "iphone"
        
        request.httpBody = createBodyWithParametersSingleImage(parameters: param, filePathKey: imageName, imageDataKey: imageData as NSData, boundary: boundary) as Data
        
        loadDataFromURL(request, completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                success(urlData,error)
            }
            else
            {
                print(error!)
            }
        })
        
    }
    class func createBodyWithParametersSingleImage(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append(("--\(boundary)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
                body.append(("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
                body.append(("\(value)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            }
        }
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.append(("--\(boundary)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(("Content-Type: \(mimetype)\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(imageDataKey as Data)
        body.append(("\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        
        body.append(("--\(boundary)--\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        
        return body
    }
    
    class func getAPIResponse(_ parameterDictionary :NSMutableDictionary,methodName:String,methodType:String, success: @escaping ((_ iTunesData: NSDictionary?,_ error:NSError?) -> Void)) {
        
        //print(parameterDictionary)
        
        
        var deviceToken = DataManager.getVal(Config().AppUserDefaults.object(forKey: "deviceToken") as AnyObject?) as! String
        
        deviceToken = deviceToken == "" ? "a3d96a79b66288250f4cc837e73500f5024c4d702071156f55e54c01684f41bc" : deviceToken
        
        parameterDictionary.setObject(deviceToken, forKey: "device_id" as NSCopying)
        parameterDictionary.setObject("iphone", forKey: "device_type" as NSCopying)
        
        var request: NSMutableURLRequest!
        
        let apiPath = "\(Config().API_URL)\(methodName)"
        print(apiPath)
        
        request = NSMutableURLRequest(url: NSURL(string: apiPath)! as URL)
        
        request.httpMethod = methodType
        if methodType == "POST" {
            request.httpBody = parameterDictionary.dataFromHttpParameters() as Data?
        }
        loadDataFromURL(request, completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                //3
                success(urlData,error)
            }
        })
    }

    class func getAPIResponse(_ parameterDictionary :NSMutableDictionary,methodName:String, success: @escaping ((_ iTunesData: NSDictionary?,_ error:NSError?) -> Void)) {
        
        var deviceToken = DataManager.getVal(Config().AppUserDefaults.object(forKey: "deviceToken") as AnyObject?) as! String
        
        deviceToken = deviceToken == "" ? "a3d96a79b66288250f4cc837e73500f5024c4d702071156f55e54c01684f41bc" : deviceToken
        
        parameterDictionary.setObject(deviceToken, forKey: "device_id" as NSCopying)
        parameterDictionary.setObject("2", forKey: "device_type" as NSCopying)
        
        var request: NSMutableURLRequest!
        
        let apiPath = "\(Config().API_URL)\(methodName)"
        #if DEBUG
          print(apiPath)
        #endif
      
        
        request = NSMutableURLRequest(url: NSURL(string: apiPath)! as URL)
        
        request.httpMethod = "POST"
        request.httpBody = parameterDictionary.dataFromHttpParameters() as Data?
        
        loadDataFromURL(request, completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                //3
                success(urlData,error)
            }
        })
    }
    
    class func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append(("--\(boundary)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
                body.append(("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
                body.append(("\(value)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            }
        }
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.append(("--\(boundary)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(("Content-Type: \(mimetype)\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(imageDataKey as Data)
        body.append(("\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        
        body.append(("--\(boundary)--\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        
        return body
    }
    
     class func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

    
    
    class func getAPIResponseFile(_ parameterDictionary :NSMutableDictionary,methodName:NSString, dataArray:NSArray, success: @escaping ((_ iTunesData: NSDictionary?,_ error:NSError?) -> Void)) {
        
        var deviceToken = DataManager.getVal(Config().AppUserDefaults.object(forKey: "deviceToken") as AnyObject?) as! String
        deviceToken = deviceToken == "" ? "a3d96a79b66288250f4cc837e73500f5024c4d702071156f55e54c01684f41bc" : deviceToken
        parameterDictionary.setValue(deviceToken, forKey: "device_id")
        let apiPath = "\(Config().API_URL)\(methodName)"
        
        let request = NSMutableURLRequest(url:NSURL(string: apiPath)! as URL);
        request.httpMethod = "POST"
        
        let boundary = self.generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var param : [String:String] = [:]
        
        for (key,val) in parameterDictionary {
            param[key as! String] = val as! String
        }
        
        param["device_id"] = deviceToken
        param["device_type"] = "iphone"
        
        request.httpBody = createBodyWithParameters(parameters: param, imageArray: dataArray, boundary: boundary) as Data
        
        loadDataFromURL(request, completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                success(urlData,error)
            }
            else
            {
                print(error!)
            }
        })
        
    }
    class func createBodyWithParameters(parameters: [String: String]?, imageArray: NSArray, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append(("--\(boundary)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
                body.append(("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
                body.append(("\(value)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            }
        }
        
        
        var imageData = Data()
        var imageName  = ""
        // print(imageArray)
        for index in 0..<imageArray.count {
            
            let dataDictionary = imageArray[index] as! NSDictionary
            
            imageName = dataDictionary.object(forKey: "image") as! String
            imageData = dataDictionary.object(forKey: "imageData") as! Data
            
            let mimetype = "application/octet-stream"
            
            let imageName = dataDictionary.object(forKey: "image") as! NSString
            let imageExt = dataDictionary.object(forKey: "ext") as! NSString
            let imageData = dataDictionary.object(forKey: "imageData") as! Data
            //  let imageType = dataDictionary.object(forKey: "imagetype") as! NSString
            
            let randmstr = self.randomStringWithLength(8)
            
            body.append(("--\(boundary)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            body.append(("Content-Disposition: form-data; name=\"\(imageName)[\(index)]\"; filename=\"\(randmstr).\(imageExt)\"\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            body.append(("Content-Type: \(mimetype)\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            body.append(imageData as Data)
            body.append(("\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            body.append(("--\(boundary)--\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            
        }
        
        
        return body
    }

    class func randomStringWithLength (_ len : Int) -> NSString {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for i in 0 ..< len{
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString
    }
    class func getOtherAPI(_ str:NSString,success:( (_ itunesdata:Data,_ error:NSError ) -> Void )){
        //println(str)
        
    }
    
    class func getSubmitAPIResponse(_ parameterDictionary :NSDictionary,MethodName: String, success: @escaping ((_ iTunesData: NSDictionary?,_ error:NSError?) -> Void)) {
        let MethodURL = Config().API_URL+MethodName
        print(MethodURL)
        let deviceToken = DataManager.getVal(Config().AppUserDefaults.object(forKey: "deviceToken")) as! String
        let  parameterDic  =  ["data":parameterDictionary,"device_type":"iPhone","device_id":deviceToken ,"device_token":deviceToken] as [String : Any];
        
        var request: NSMutableURLRequest!
        request = NSMutableURLRequest(url: URL(string: MethodURL)!)
        request.httpBody = parameterDictionary.dataFromHttpParameters() as Data?
        request.httpMethod = "POST"
        
        loadDataFromURL(request, completion:{(data, error) -> Void in
             #if DEBUG
            print(request)
            print(data!)
            #endif
            if let urlData = data {
                success(urlData,error)
            }
        })
    }
    
    class func loadDataFromURL(_ request: NSMutableURLRequest, completion:@escaping (_ data: NSDictionary?, _ error: NSError?) -> Void) {
        // Use NSURLSession to get data from an NSURL
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main)
        {(response, data, error) in
            //print(error)
            if let responseError = error {
                #if DEBUG
                Config().printData(responseError as NSObject)
                #endif
                var jsonResult  = NSDictionary()
                jsonResult = ["status":"error","message":responseError.localizedDescription]
                //  jsonResult = ["status":"error","message":"Make sure your device is connected to the internet."]
                completion(jsonResult, responseError as NSError?)
            } else if let httpResponse = response as? HTTPURLResponse {
                Config().printData(httpResponse.statusCode as NSObject)
                if httpResponse.statusCode != 200 {
                    let base64String = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    #if DEBUG
                    Config().printData(base64String!)
                    #endif
                    var jsonResult  = NSDictionary()
                    jsonResult = ["status":"error","message":base64String!]
                    //  jsonResult = ["status":"error","message":"There is a problem with server, kindly try again."]
                    completion(jsonResult, nil)
                } else {
                    let base64String = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    #if DEBUG
                    Config().printData(base64String!)
                    #endif
                    var jsonResult  = NSDictionary()
                    
                    let decodedString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    if((try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                        
                        jsonResult  = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    } else {
                        #if DEBUG
                        Config().printData(decodedString!)
                        #endif
                        jsonResult = ["status":"error","message":decodedString!]
                        //  jsonResult = ["status":"error","message":"There is a problem with server, kindly try again."]
                    }
                    #if DEBUG
                    Config().printData(jsonResult)
                    #endif
                    completion(jsonResult, nil)
                }
            }
        }
        //loadDataTask.resume()
    }
    
}

