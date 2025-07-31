//
//  CosmicHUDWidgetBundle.swift
//  CosmicHUDWidget
//
//  Created by Corey Davis on 7/30/25.
//

import WidgetKit
import SwiftUI

@main
struct CosmicHUDWidgetBundle: WidgetBundle {
    var body: some Widget {
        CosmicHUDWidget()
        CosmicHUDWidgetControl()
        CosmicHUDWidgetLiveActivity()
    }
}
