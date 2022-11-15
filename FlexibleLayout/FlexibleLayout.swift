//
//  FlexibleLayout.swift
//  FlexibleLayout
//
//  Created by François Boulais on 15/11/2022.
//

import SwiftUI

struct FlexibleLayout: Layout {
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat
    
    struct Row {
        var subviews: [Subviews.Element]
        let spacing: CGFloat
        
        var height: CGFloat {
            subviews
                .map { $0.sizeThatFits(.unspecified) }
                .map(\.height)
                .max() ?? 0
        }
        
        var width: CGFloat {
            let widths = subviews
                .map { $0.sizeThatFits(.unspecified) }
                .map(\.width)
            
            return Array(widths.map({ [$0] }).joined(separator: [spacing])).reduce(0, +)
        }
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = rows(for: subviews, in: proposal)
        let width = rows.map(\.width).max() ?? 0
        let height = Array(rows.map({ [$0.height] }).joined(separator: [verticalSpacing])).reduce(0, +)
        return .init(width: width, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = rows(for: subviews, in: proposal)

        _ = rows.reduce(into: CGFloat(bounds.minY)) { y, row in
            y += row.height / 2
            
            _ = row.subviews.reduce(into: CGFloat(bounds.minX)) { x, subview in
                let size = subview.sizeThatFits(.unspecified)
                subview.place(
                    at: .init(x: x, y: y),
                    anchor: .leading,
                    proposal: .init(width: size.width, height: size.height)
                )
                x += size.width
                x += horizontalSpacing
            }
            
            y += row.height / 2
            y += verticalSpacing
        }
    }
    
    // MARK: - Private functions
    
    private func rows(for subviews: Subviews, in proposal: ProposedViewSize) -> [Row] {
        subviews.reduce(into: [Row]()) { rows, subview in
            if let lastIndex = rows.indices.last, let proposalWidth = proposal.width {
                if proposalWidth - rows[lastIndex].width >= subview.sizeThatFits(.unspecified).width {
                    rows[lastIndex].subviews.append(subview)
                } else {
                    rows.append(.init(subviews: [subview], spacing: horizontalSpacing))
                }
            } else {
                rows.append(.init(subviews: [subview], spacing: horizontalSpacing))
            }
        }
    }
}
