//
//  ModeSelectionView.swift
//  marmor
//
//  Created by Noah Frahm on 6/7/22.
//

import SwiftUI

struct ModeSelectionView: View {
    
    @State var activeCamera = 0
    var cameraNames = ["front", "back", "wideview"]
    var size: Int {
        return cameraNames.count
    }
    
    var body: some View {
        ZStack{
            if activeCamera == 0 {
//                CameraNoBackendView(camera: CameraModel(.video, .back))
                CameraView(camera: CameraModel(.video, .back))
            }
            else if activeCamera == 1 {
//                CameraNoBackendView(camera: CameraModel(.video, .back))
                CameraView(camera: CameraModel(.video, .front))
//                Text("faceCam")
            }
            else{
                VStack{
//                  doesnt work for displaying live previews of both
//                  so we must make special modifications to cameramodel
//                  to support multiple devices
                    CameraNoBackendView(camera: CameraModel(.video, .back))
                    CameraNoBackendView(camera: CameraModel(.video, .front))
//                    CameraView(camera: CameraModel(.video, .back))
//                    CameraView(camera: CameraModel(.video, .front))
                }
            }

            VStack{
                Picker("Scheme", selection: $activeCamera) {
                    ForEach(0..<size, id: \.self) {current in
                        Text(cameraNames[current])
                    }
                }
                .pickerStyle(.segmented)
                .background(.gray)
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height * 0.1)
                Spacer()
                if (activeCamera == 0 || activeCamera == 1){
                    HStack{
                        Button(action: {
                            if activeCamera == 1 {
                                activeCamera = 0
                            }
                            else {
                                activeCamera = 1
                            }
                        }, label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        })
                        .padding()
                        Spacer()
                    }
                }
                
            }
        }
    }
}


struct ModeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
            ModeSelectionView()
    }
}
