//
//  TImerView.swift
//  Minesweeper
//
//  Created by Stas Kochkin on 30/06/2019.
//  Copyright © 2019 appodeal. All rights reserved.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var timing: Timing
    
    var body: some View {
        Text(timing.playingTime.str)
            .foregroundColor(Color.secondary)
            .fontWeight(.semibold)
            .font(Font.system(size: 14))
            .shadow(radius: 5)
    }
}

private extension TimeInterval {
    var str: String {
        return String(Int(self / 60)) +
            ":" +
            String(Int(truncatingRemainder(dividingBy: 60)))
    }
}

#if DEBUG
struct TimerView_Previews : PreviewProvider {
    static var previews: some View {
        TimerView(timing: Timing())
    }
}
#endif
