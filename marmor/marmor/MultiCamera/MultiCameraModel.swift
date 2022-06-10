//
//  MultiCameraModel.swift
//  marmor
//
//  Created by Noah Frahm on 6/9/22.
//

import Foundation
import SwiftUI
import AVFoundation
import Photos

class MultiCameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    
    @Published var isTaken = false
    @Published var dualVideoSession = AVCaptureMultiCamSession()

    @Published var alert = false
    
//    captures photo
    @Published var faceOutput = AVCapturePhotoOutput()
    @Published var backOutput = AVCapturePhotoOutput()
    
//    preview
    @Published var preview = AVCaptureVideoPreviewLayer()
    
//    pic data
    @Published var isSaved = false
    @Published var picData = Data(count: 0)
 
    
    func Check() {
        //permissions
        switch AVCaptureDevice.authorizationStatus(for: .video
        ) {
        case .authorized:
            //setup session
            setUp()
        case .notDetermined:
            //ask for permission
            AVCaptureDevice.requestAccess(for: .video) {
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
            self.dualVideoSession.beginConfiguration()
            
            let faceCam = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            let inputFaceCam = try AVCaptureDeviceInput(device: faceCam!)
            //checks and adds input to session
            if self.dualVideoSession.canAddInput(inputFaceCam){
                self.dualVideoSession.addInputWithNoConnections(inputFaceCam)
            }
            // seach back video port
            let faceCamVideoPort = inputFaceCam.ports(for: .video, sourceDeviceType: faceCam?.deviceType, sourceDevicePosition: faceCam?.position ?? .front).first
            
            // append back video output
            if self.dualVideoSession.canAddOutput(self.faceOutput){
                self.dualVideoSession.addOutputWithNoConnections(self.faceOutput)
            }

            //connect back output to dual video session
            let faceCamOutputConnection = AVCaptureConnection(inputPorts: [faceCamVideoPort!], output: self.faceOutput)
            if dualVideoSession.canAddConnection(faceCamOutputConnection) {
                dualVideoSession.addConnection(faceCamOutputConnection)
            }
            
            
            let backCam = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
            let inputBackCam = try AVCaptureDeviceInput(device: backCam!)
            //checks and adds input to session
            if self.dualVideoSession.canAddInput(inputFaceCam){
                self.dualVideoSession.addInputWithNoConnections(inputFaceCam)
            }
            // seach back video port
            let backCamVideoPort = inputBackCam.ports(for: .video, sourceDeviceType: backCam?.deviceType, sourceDevicePosition: backCam?.position ?? .front).first
            
            // append back video output
            if self.dualVideoSession.canAddOutput(self.backOutput){
                self.dualVideoSession.addOutputWithNoConnections(self.backOutput)
            }

            //connect back output to dual video session
            let backCamOutputConnection = AVCaptureConnection(inputPorts: [backCamVideoPort!], output: self.faceOutput)
            if dualVideoSession.canAddConnection(backCamOutputConnection) {
                dualVideoSession.addConnection(backCamOutputConnection)
            }
            
            
            self.dualVideoSession.commitConfiguration()
            
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    
    func takePic(){
        DispatchQueue.global(qos: .background).async {
            self.faceOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            self.backOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            
            DispatchQueue.main.async {
                withAnimation{
                    self.isTaken.toggle()
                }
            }
            self.dualVideoSession.stopRunning()
        }
    }
    
    
    func reTake(){
        DispatchQueue.global(qos: .background).async{
            self.dualVideoSession.startRunning()
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
