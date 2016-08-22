//
//  ViewController.swift
//  ios_picture_upload
//
//  Created by 赤井橋 健2 on 2016/08/18.
//  Copyright © 2016年 ken akaibashi. All rights reserved.
//

import UIKit
import AWSS3
import Photos
import AWSCore
//import SwiftTask

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var userDefault: NSUserDefaults?
    var uploadedFileName: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // button
        let btn: UIButton = UIButton(frame: CGRectMake(100 , 100, 200, 30))
        btn.setTitle("カメラで撮る", forState: UIControlState.Normal)
        btn.backgroundColor = UIColor.redColor()
        btn.layer.position = CGPoint(x: 200, y: 150)
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: "pickImageFromCamera", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn)

        
        
/*
        let btn2: UIButton = UIButton(frame: CGRectMake(100 , 100, 200, 30))
        btn2.setTitle("アルバムから選択", forState: UIControlState.Normal)
        btn2.backgroundColor = UIColor.redColor()
        btn2.layer.position = CGPoint(x: 200, y: 300)
        btn2.layer.cornerRadius = 8
        //        btn.addTarget(self, action: "onClickBtn", forControlEvents: UIControlEvents.TouchUpInside)
        btn2.addTarget(self, action: "pickImageFromLibrary", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn2)
*/
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
//    @IBAction func uploadButtonTapped(sender: AnyObject) {
    func uploadButtonTapped(sender: AnyObject) {
        
//        myImageUploadRequest()
    }
    
//    @IBOutlet weak var myimageView: UIImageView!
    weak var myimageView: UIImageView!
    var imageForUpload: UIImage!
    
//    @IBAction func selectPhotoButtonTapped(sender: AnyObject) {
    func selectPhotoButtonTapped(sender: AnyObject) {
        
        
print("select!!")
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    
    
    

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
print("aaaa")
        self.dismissViewControllerAnimated(true, completion: nil)
        // from camaera
//        if (info.indexForKey(UIImagePickerControllerOriginalImage) != nil) {
//            let tookImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//            var imagePath = NSHomeDirectory()
//            imagePath = imagePath.stringByAppendingPathComponent("Documents/face.png")
        
        
        let directoryPath           =  try! NSFileManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        let imagePath       = directoryPath.URLByAppendingPathComponent("Image1.png").path
/*
            let dir = "Documents"
            let imagePath = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("face.jpg").path
*/
        
        
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        
//        var imageData: NSData = UIImagePNGRepresentation(tookImage)!
//        var imageData: NSData = UIImagePNGRepresentation(self.imageForUpload)!
        let imageData = UIImageJPEGRepresentation(image, 1)!
            let isSuccess = imageData.writeToFile(imagePath!, atomically: true)
        
print(isSuccess)
        
            if isSuccess {
                let fileUrl: NSURL = NSURL(fileURLWithPath: imagePath!)
//                uploadToS3(fileUrl)
                myImageUploadRequest(fileUrl)
            }
            return
//        }

    }
    
/*
    func uploadToS3(fileUrl: NSURL) {
        //make a timestamp variable to use in the key of the video I'm about to upload
        let date:NSDate = NSDate()
        var unixTimeStamp:NSTimeInterval = date.timeIntervalSince1970
        var unixTimeStampString:String = String(format:"%f", unixTimeStamp)
        
        // set upload settings
        var myTransferManagerRequest:AWSS3TransferManagerUploadRequest = AWSS3TransferManagerUploadRequest()
        myTransferManagerRequest.bucket = "labbit-hint"
//        var myId = userDefault.stringForKey(Conf.KEY_USER_ID)
        var myId = userDefault!.stringForKey("hoge")
        self.uploadedFileName = "\(myId!)_\(unixTimeStampString).jpg"
        myTransferManagerRequest.key = self.uploadedFileName
        myTransferManagerRequest.body = fileUrl
        myTransferManagerRequest.ACL = AWSS3ObjectCannedACL.PublicRead
        
//        var myBFTask:BFTask = BFTask()
//        var myMainThreadBFExecutor:BFExecutor = BFExecutor.mainThreadExecutor()
        var myTransferManager:AWSS3TransferManager = AWSS3TransferManager.defaultS3TransferManager()
        myTransferManager.upload(myTransferManagerRequest).continueWithExecutor(myMainThreadBFExecutor, withBlock: { (myBFTask) -> AnyObject! in
            if((myBFTask.result) != nil){
                println("Success!!")
                // send api?
                let s3Path = Conf.AWS_S3_URL + self.uploadedFileName
                println("uploaded s3 path is \(s3Path)")
                
            } else {
                println("upload didn't seem to go through..")
                var myError = myBFTask.error
                println("error: \(myError)")
            }
            return nil
        })       
    }
*/
    
    
    
    
    
    //画像のアップロード処理
    func myImageUploadRequest(fileUrl: NSURL){
        
        
print("upload!!")
        
        
        

        
        
//        let imageData = UIImageJPEGRepresentation(self.imageForUpload, 1)
//        if(imageData==nil) { return; }
        
        
//print(imageData)
        
//        let docDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
//        let text = "Upload File."
//        let fileName = "test.jpg"
//        let filePath = "\(docDir)/\(fileName)"
//        let filePath = "\("file")/\(fileName)"
//        let filePath = "\(imageData)"
//        try! text.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest.bucket = "labbit-hint"
        
        let time:Int = Int(NSDate().timeIntervalSince1970)
        
        uploadRequest.key = "test_" + String(time) + ".jpg"
//        uploadRequest.body = NSURL(string: "file://\(filePath)")
//        uploadRequest.body = NSURL(string: "file://\(filePath)")
        uploadRequest.body = fileUrl
        uploadRequest.ACL = .PublicRead
        uploadRequest.contentType = "image/jpg"
        
        transferManager.upload(uploadRequest).continueWithBlock { (task: AWSTask) -> AnyObject? in
            if task.error == nil && task.exception == nil {
                print("success")
            } else {
                print("fail")
                print(task.error)
                print(task.exception)
            }
            return nil
        }
        
        
        
/*
        //myUrlにはphpファイルのアドレスを入れる
        let myUrl = NSURL(string:"http://example.com/upload.php")
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "POST"
        
        //下記のパラメータはあくまでもPOSTの例
        let param = [
            "userId" : "1234"
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(self.imageForUpload, 1)
        
        if(imageData==nil) { return; }
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        //myActivityIndicator.startAnimating();
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            if error != nil {
                print("error=\(error)")
                return
            }
            // レスポンスを出力
            print("******* response = \(response)")
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("****** response data = \(responseString!)")
            
            dispatch_async(dispatch_get_main_queue(),{
                //アップロード完了
            });
        }
        task.resume()
 */
 
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData()
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        body.appendString("--\(boundary)--\r\n")
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    //カメラで写真を取る
    func pickImageFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    //写真をライブラリから選択
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
/*
    //画像が選択されたら呼び出される
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            //iamgeForUploadというUIImageを用意しておいてそこに一旦預ける
            self.imageForUpload = image
            self.myImageUploadRequest()
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
*/
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}

