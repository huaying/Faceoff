//
//  CameraViewController.swift
//  BTtest
//
//  Created by Huaying Tsai on 11/12/15.
//  Copyright © 2015 Liang. All rights reserved.
//


import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var photoPickButton = UIView()
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
//    NSNotificationCenter.defaultCenter().addObserverForName("AVCaptureDeviceDidStartRunningNotification", object:nil, queue:nil, usingBlock: { note in
//        
//        })
        
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        //let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let videoDevices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        var frontCamera: AVCaptureDevice!
        for device in videoDevices {
            if let device = device as? AVCaptureDevice {
                if device.position == AVCaptureDevicePosition.Front {
                    frontCamera = device
                    break
                }
            }
        }
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: frontCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if error == nil && captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if captureSession!.canAddOutput(stillImageOutput) {
                captureSession!.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer!.frame = self.view.frame
                
                previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
                previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.LandscapeLeft
                //previewLayer!.backgroundColor = UIColor.blackColor().CGColor
                self.view.layer.addSublayer(previewLayer!)
                self.view.addSubview(self.createCameraOverlay())
                self.view.addSubview(self.createPhotoPickButton())
                captureSession!.startRunning()
   
            }
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: "handlePhotoPickButtonTap:")
        self.photoPickButton.addGestureRecognizer(gesture)
    }
    
    func handlePhotoPickButtonTap(sender:UITapGestureRecognizer){
        photoPick()
    }
    
    func photoPick(){
        if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.LandscapeLeft
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil) {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    
                    let image = UIImage(CGImage: cgImageRef!, scale: 10, orientation: UIImageOrientation.Up)
                  
                    CharacterManager.saveCandidateCharacterToLocalStorage(self.cropImageToCircle(image))
                    //CharacterManager.saveCharacterToLocalStorage(self.cropImageToCircle(image))
                    
                    self.dismissViewControllerAnimated(true, completion: {
                        NSNotificationCenter.defaultCenter().postNotificationName("PhotoPickerFinishedNotification", object: self, userInfo: nil)
                        
                    })
                }
            })
        }

    }
    
    func cropImageToCircle(image: UIImage) -> UIImage{
        let photoView = UIImageView(frame: CGRectMake(0,0,image.size.height,image.size.height))
        photoView.image = image
        photoView.contentMode = .Center
        photoView.layer.borderWidth = 5
        photoView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(0.3).CGColor
        photoView.layer.cornerRadius = image.size.height/2;
        photoView.layer.masksToBounds = true
        
        var layer1: CALayer = CALayer()
        
        layer1 = photoView.layer
        UIGraphicsBeginImageContext(CGSize(width:image.size.height,height:image.size.height))
        layer1.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func createCameraOverlay() -> UIView
    {
        let overlayView = UIView(frame: self.view.frame)
        overlayView.alpha = 0.7
        overlayView.backgroundColor = UIColor.blackColor()
        overlayView.frame = self.view.frame
        
        let maskLayer = CAShapeLayer()
        
        // Create a path with the rectangle in it.
        let path = CGPathCreateMutable()
        let circleRadius : CGFloat = overlayView.frame.height/2 - 10.0
        let yCircleCenter: CGFloat = overlayView.frame.height/2
        let xCircleCenter: CGFloat = overlayView.frame.width/2
        let rectWidth: CGFloat = overlayView.frame.width
        let rectHeight: CGFloat = overlayView.frame.height
        
        CGPathAddArc(path, nil, xCircleCenter, yCircleCenter, circleRadius, 0.0, 2 * 3.14, false)
        CGPathAddRect(path, nil, CGRectMake(0, 0, rectWidth, rectHeight))
        maskLayer.backgroundColor = UIColor.blackColor().CGColor
        
        maskLayer.path = path;
        maskLayer.fillRule = kCAFillRuleEvenOdd
        
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
        
        return overlayView
    }
    
    func createPhotoPickButton() -> UIView{
        
        let rectWidth: CGFloat = self.view.frame.width
        let rectHeight: CGFloat = self.view.frame.height

        var path = CGPathCreateMutable()
        //CGPathAddArc(path, nil, rectWidth-120, rectHeight-60, 38, 0.0, CGFloat(2.0 * M_PI), false)
        CGPathAddArc(path, nil, 40, 40, 38, 0.0, CGFloat(2.0 * M_PI), false)
        var buttonLayer = CAShapeLayer()
        buttonLayer.path = path
        buttonLayer.fillColor =  UIColor.whiteColor().CGColor
        photoPickButton.layer.addSublayer(buttonLayer)
        
        path = CGPathCreateMutable()
        //CGPathAddArc(path, nil, rectWidth-120, rectHeight-60, 30, 0.0, CGFloat(2.0 * M_PI), false)
        CGPathAddArc(path, nil, 40, 40, 30, 0.0, CGFloat(2.0 * M_PI), false)
        buttonLayer = CAShapeLayer()
        buttonLayer.path = path
        buttonLayer.lineWidth = 3.0
        buttonLayer.strokeColor = UIColor.blackColor().CGColor
        buttonLayer.fillColor =  UIColor.whiteColor().CGColor
        photoPickButton.layer.addSublayer(buttonLayer)
        self.view.addSubview(photoPickButton)
        photoPickButton.frame = CGRectMake(rectWidth-160, rectHeight-100,80,80)
        return photoPickButton
    }
}

