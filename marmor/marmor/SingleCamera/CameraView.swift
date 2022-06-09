//
//  CameraView.swift
//  marmor
//
//  Created by Noah Frahm on 6/7/22.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    
    @StateObject var camera: CameraModel
    
    var body: some View{
        ZStack{
            Color.black
                .ignoresSafeArea(.all, edges: .all)
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack{
                if camera.isTaken{
                    HStack{
                        Spacer()
                        Button(action: {camera.isTaken = false}, label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .padding()
                        })
                        .padding(.leading)
//                        Button(action: camera.reTake, label: {
//                            Image(systemName: "arrow.triangle.2.circlepath.camera")
//                                .foregroundColor(.black)
//                                .padding()
//                                .background(Color.white)
//                                .clipShape(Circle())
//                        })
//                        .padding(.leading)
                    }
                }
                
                Spacer()
                
                HStack{
                    if camera.isTaken {
                        Button(action: {if !camera.isSaved{camera.savePic()}}, label: {
                            Text(camera.isSaved ? "saved" : "save")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical, 20)
                                .padding(.horizontal, 20)
                                .background(Color.white)
                                .clipShape(Capsule())
                        })
                        .padding(.leading)
                        
                        Spacer()
                    }
                    else {
                        Button(action: camera.takePic, label: {
                            ZStack{
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75, height: 75)
                            }
                        })
                    }
                }
                .frame(height: 75)
            }
        }
        .onAppear(perform: {
            camera.Check()
        })
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView(camera: CameraModel(.video, .back))
    }
}

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera: CameraModel
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        //my own properties?
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        //start session
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiViewType: UIViewType, context: Context) {
        
    }
    
}
