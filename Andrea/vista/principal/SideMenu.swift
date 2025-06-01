//
//  SideMenu.swift
//  Andrea
//
//  Created by mgg on 30/5/25.
//

import Foundation
import SwiftUI

struct SideMenu: View {
    
    var colorPersonalizado: Color = .blue
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [self.colorPersonalizado.opacity(0.9), Color(UIColor.systemGray5).opacity(0.9)]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            HStack {
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    VStack(alignment: .leading) {
                        
                        Image("profile")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(UIColor.systemGray5), lineWidth: 2))
                            .shadow(color: .black.opacity(0.4), radius: 10, x: 6, y:0)
                        
                        Text("iREADER")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color(UIColor.systemGray5))
                        
                    }
                    .padding(.horizontal, 12)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 15) {
//                        MenuOption(icon: "house.fill", title: "Dashboard")
//                        MenuOption(icon: "house.fill", title: "Dashboard")
//                        MenuOption(icon: "house.fill", title: "Dashboard")
//                        MenuOption(icon: "house.fill", title: "Dashboard")
                    }
                    .padding(.horizontal, 12)
                    Spacer()
                }
                Spacer()
                
            }
            
        }
        .frame(maxWidth: 300, alignment: .leading)
        .foregroundColor(.white)
        .shadow(color: .black.opacity(0.4), radius: 10, x: 6, y:0)
    }
    
}
