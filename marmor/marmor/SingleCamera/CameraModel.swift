//
//  CameraModel.swift
//  marmor
//
//  Created by Noah Frahm on 6/7/22.
//

import Foundation
import SwiftUI
import AVFoundation

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    
//    captures photo
    @Published var output = AVCapturePhotoOutput()
    
//    preview
    @Published var preview = AVCaptureVideoPreviewLayer()
    
//    pic data
    @Published var isSaved = false
    @Published var picData = Data(count: 0)
    
    var mediaType: AVMediaType
    var CameraPosition: AVCaptureDevice.Position

    init(_ mediaType: AVMediaType, _ cameraPosition: AVCaptureDevice.Position) {
        self.mediaType = mediaType
        self.CameraPosition = cameraPosition
    }

    convenience override init() {
        self.init(.video, .back )
    }
    
    func Check() {
        //permissions
        switch AVCaptureDevice.authorizationStatus(for: self.mediaType
        ) {
        case .authorized:
            //setup session
            setUp()
        case .notDetermined:
            //ask for permission
            AVCaptureDevice.requestAccess(for: self.mediaType) {
                (status) in
                if status {
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    }
    
    
    func setUp(){
        do{
            self.session.beginConfiguration()
            
            var camtype: AVCaptureDevice.DeviceType {
                if self.CameraPosition == .front {
                    return AVCaptureDevice.DeviceType.builtInWideAngleCamera
                }
                else {
                    return AVCaptureDevice.DeviceType.builtInDualCamera
                }
                
            }
            
            let device = AVCaptureDevice.default(
                camtype, for: self.mediaType, position: self.CameraPosition
//                .builtInDualCamera, for: self.mediaType, position: self.CameraPosition
//                    .builtInWideAngleCamera, for: self.mediaType, position: .front
            )
            
            let input = try AVCaptureDeviceInput(device: device!)
            
            //checks and adds to session
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            
            //checks and adds to output
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    
    func takePic(){
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            
            DispatchQueue.main.async {
                withAnimation{
                    self.isTaken.toggle()
                }
            }
            self.session.stopRunning()
        }
    }
    
    
    func reTake(){
        DispatchQueue.global(qos: .background).async{
            self.session.startRunning()
            DispatchQueue.main.async {
                withAnimation{
                    self.isTaken.toggle()
                }
//                clearing
                self.isSaved = false
            }
        }
    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {return}
        print("pic taken")

        guard let imageData = photo.fileDataRepresentation() else {return}

        self.picData = imageData
    }
    
    
    func savePic() {
        let image = UIImage(data: self.picData)!
        
        //saving image
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        self.isSaved = true
        
        print("saved Sucessfully")
    
        
    }
}
