//
//  approvalView.swift
//  SmallRotateGame
//
//  Created by Тимофій Безверхий on 04.08.2024.
//

import SwiftUI

struct approvalView: View {
    @State var isApproved = false

    var body: some View {
            VStack{
                ZStack{
                    let picture = isApproved ? "checkmark" : "xmark"
                    let color = isApproved ? Color.green : Color.red
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(color.opacity(0.2))
                        .shadow(radius: 10)
                        .frame(width: 125, height: 125)
                        .aspectRatio(1, contentMode: .fit)
                        
                        Image(systemName: picture)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(color)
                        .padding()
                }
            }
    }
}

#Preview {
    approvalView()
}
