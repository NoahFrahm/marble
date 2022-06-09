//
//  CameraNoBackendView.swift
//  marmor
//
//  Created by Noah Frahm on 6/7/22.
//

import SwiftUI
import AVFoundation

struct CameraNoBackendView: View {
    
    @StateObject var camera: CameraModel
    
    var body: some View{
        ZStack{
            Color.black
                .ignoresSafeArea(.all, edges: .all)
//            CameraPreview(camera: camera)
//                .ignoresSafeArea(.all, edges: .all)
            
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
                        
//                        Button(action: {camera.isTaken = false}, label: {
//                            Image(systemName: "cross")
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
                        Button(action: {camera.isTaken = false}, label: {
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
                        Button(action: {camera.isTaken = true}, label: {
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

struct CameraNoBackendView_Previews: PreviewProvider {
    static var previews: some View {
        CameraNoBackendView(camera: CameraModel(.video, .back))
    }
}
