import SwiftUI

struct LeadView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.regularMaterial)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    LeadProfileHeaderView()
                    LeadDetailsView()

                    LeadSummaryCard()
                        .padding(.horizontal, LeadMetric.horizontalPadding)
                        .padding(.bottom, 16)
                }
                .frame(maxWidth: LeadMetric.contentWidth)
                .frame(maxWidth: .infinity)
            }
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
    }
}

#Preview {
    LeadView()
}
