//
//  CMarkParsing.swift
//  GistHub
//
//  Created by Khoa Le on 04/01/2023.
//

import UIKit
import StyledTextKit
import cmark_gfm_swift
import HTMLString

private struct CMarkOptions {
    let contentSizeCategory: UIContentSizeCategory
    let viewerCanUpdate: Bool
    let width: CGFloat
}

private struct CMarkContext {
    let inLink: Bool
    init(inLink: Bool = false) {
        self.inLink = inLink
    }
}

private enum TextElementPosition {
    case first
    case neck
    case last
}

private extension TextElement {
    @discardableResult
    func build(
        _ builder: StyledTextBuilder,
        options: CMarkOptions,
        position: TextElementPosition,
        context: CMarkContext = CMarkContext(),
        userInterfaceStyle: UIUserInterfaceStyle
    ) -> StyledTextBuilder {
        builder.save()
        defer {
            builder.restore()
        }

        switch self {
        case .text(let text):
            let text = text
                .strippingHTMLComments
                .removingHTMLEntities()
            builder.add(text: text)
        case .softBreak:
            switch position {
            case .first, .last:
                break
            case .neck:
                builder.add(text: "\u{2028}")
            }
        case .lineBreak:
            builder.add(text: "\n")
        case .code(let text):
            let backgroundColor = userInterfaceStyle == .light ? Colors.Palette.Gray.gray0.light : Colors.Palette.Gray.gray8.dark
            let foregroundColor: UIColor = userInterfaceStyle == .light ? Colors.Palette.Gray.gray9.light : Colors.Palette.Gray.gray1.dark
            builder.add(styledText: StyledText(
                text: text,
                style: MarkdownText.code.with(foreground: foregroundColor, background: backgroundColor)
            ))
        case .emphasis(let children):
            builder.add(traits: .traitItalic)
            children.build(builder, options: options, context: context, userInterfaceStyle: userInterfaceStyle)
        case .strong(let children):
            builder.add(traits: .traitBold)
            children.build(builder, options: options, context: context, userInterfaceStyle: userInterfaceStyle)
        case .strikethrough(let children):
            builder.add(attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: builder.tipAttributes?[.foregroundColor] ?? Colors.MarkdownColorStyle.foreground as AnyHashable
            ])
            children.build(builder, options: options, context: context, userInterfaceStyle: userInterfaceStyle)
        case .link(let children, _, let url):
            let backgroundColor = userInterfaceStyle == .light ? UIColor.white : Colors.systemGroupedBackgroundDark
            var attributes: [NSAttributedString.Key: AnyHashable] = [
                .foregroundColor: Colors.MarkdownColorStyle.accentForeground as AnyHashable,
                .backgroundColor: backgroundColor,
                .highlight: true
            ]

            attributes[MarkdownAttribute.url] = url ?? ""
            builder.add(attributes: attributes)
            children.build(builder, options: options, context: CMarkContext(inLink: true), userInterfaceStyle: userInterfaceStyle)

//        case .mention(let login):
        case .checkbox(let checked, let originalRange):
            builder.addCheckbox(
                checked: checked,
                range: originalRange,
                viewerCanUpdate: options.viewerCanUpdate)
        default:
            break
        }
        return builder
    }
}

private extension Array where Iterator.Element == TextElement {
    @discardableResult
    func build(
        _ builder: StyledTextBuilder,
        options: CMarkOptions,
        context: CMarkContext = CMarkContext(),
        userInterfaceStyle: UIUserInterfaceStyle
    ) -> StyledTextBuilder {
        for (i, el) in enumerated() {
            let position: TextElementPosition
            switch i {
            case 0: position = .first
            case count - 1: position = .last
            default: position = .neck
            }
            el.build(
                builder,
                options: options,
                position: position,
                context: context,
                userInterfaceStyle: userInterfaceStyle
            )
        }
        return builder
    }
}

private extension ListElement {
    @discardableResult
    func build(_ builder: StyledTextBuilder, options: CMarkOptions, userInterfaceStyle: UIUserInterfaceStyle) -> StyledTextBuilder {
        switch self {
        case .text(let text):
            text.build(builder, options: options, userInterfaceStyle: userInterfaceStyle)
        case .list(let childer, let type, let level):
            childer.build(builder, options: options, type: type, level: level, userInterfaceStyle: userInterfaceStyle)
        }
        return builder
    }
}

private extension Array where Iterator.Element == [ListElement] {
    /// Build Unordered and Ordered list
    @discardableResult
    func build(
        _ builder: StyledTextBuilder,
        options: CMarkOptions,
        type: ListType,
        level: Int = 0,
        userInterfaceStyle: UIUserInterfaceStyle
    ) -> StyledTextBuilder {
        builder.save()

        defer { builder.restore() }

        // unicode character to newline without creating a new paragraph to avoid NSParagraphStyle spacing
        let newline = "\u{2028}"

        for (i, c) in enumerated() {
            let tick: String
            switch type {
            case .unordered:
                tick = level % 2 == 0
                    ? MarkdownConstants.Strings.bullet
                    : MarkdownConstants.Strings.bulletHollow
            case .ordered:
                tick = "\(i + 1)."
            }

            var spaces = ""
            for _ in 0 ..< level {
                spaces += "  "
            }

            builder.add(text: "\(spaces)\(tick) ")

            c.forEach({ cc in
                cc.build(builder, options: options, userInterfaceStyle: userInterfaceStyle)
            }, joined: { _ in
                builder.add(text: newline)
            })

            // never append whitespace on the last comment
            if i != count - 1 {
                builder.add(text: newline)
            }
        }
        return builder
    }
}

private extension Array where Iterator.Element == TableRow {
    func build(
        options: CMarkOptions,
        userInterfaceStyle: UIUserInterfaceStyle
    ) -> [(cells: [StyledTextRenderer], fill: Bool)] {
        var rowIndex = 0
        return map {
            let fill = rowIndex % 2 == 1
            if case .row = $0 {
                rowIndex += 1
            }
            return ($0.build(options: options, userInterfaceStyle: userInterfaceStyle), fill)
        }
    }
}

private extension TableRow {
    func build(options: CMarkOptions, userInterfaceStyle: UIUserInterfaceStyle) -> [StyledTextRenderer] {
        let builders: [StyledTextBuilder]

        let foregroundColor: UIColor = userInterfaceStyle == .light ? Colors.Palette.Gray.gray9.light : Colors.Palette.Gray.gray1.dark

        switch self {
        case .header(let cells):
            builders = cells.map {
                $0.build(
                    StyledTextBuilder.markdownBase()
                        .add(traits: .traitBold, attributes: [.foregroundColor: foregroundColor]),
                    options: options,
                    userInterfaceStyle: userInterfaceStyle
                )
            }
        case .row(let cells):
            builders = cells.map {
                $0.build(
                    StyledTextBuilder.markdownBase()
                        .add(attributes: [.foregroundColor: foregroundColor]),
                    options: options,
                    userInterfaceStyle: userInterfaceStyle
                )
            }
        }

        // don't warm, sized when building TableModel
        return builders.map {
            StyledTextRenderer(
                string: $0.build(),
                contentSizeCategory: options.contentSizeCategory,
                inset: MarkdownTableCollectionCell.inset
            )
        }
    }
}

private extension Array {
    func forEach(_ body: (Element) -> Void, joined: (Element) -> Void) {
        for (i, e) in enumerated() {
            body(e)
            if i != count - 1 {
                joined(e)
            }
        }
    }
}

private func makeModels(elements: [Element], options: CMarkOptions, userInterfaceStyle: UIUserInterfaceStyle) -> [BlockNode] {
    var models = [BlockNode]()
    var runningBuilder: StyledTextBuilder?
    let backgroundColor = userInterfaceStyle == .light ? UIColor.white : Colors.systemGroupedBackgroundDark

    let makeBuilder: () -> StyledTextBuilder = {
        let builder: StyledTextBuilder
        if let current = runningBuilder {
            builder = current
                .add(text: "\n")
        } else {
            builder = StyledTextBuilder.markdownBase()
        }
        runningBuilder = builder
        return builder
    }

    let endRunningText: (Bool) -> Void = { _ in
        if let builder = runningBuilder {
            models.append(
                StyledTextRenderer(
                    string: builder.build(),
                    contentSizeCategory: options.contentSizeCategory,
                    inset: UIEdgeInsets(top: 2, left: 0, bottom: 8, right: 0),
                    backgroundColor: Colors.MarkdownColorStyle.background
                )
                .warm(width: options.width)
            )
        }
        runningBuilder = nil
    }

    for (i, el) in elements.enumerated() {
        let isLast = i == elements.count - 1

        switch el {
        case .text(let items):
            let foregroundColor: UIColor = userInterfaceStyle == .light ? Colors.Palette.Gray.gray9.light : Colors.Palette.Gray.gray1.dark
            let builder = makeBuilder().add(attributes: [.foregroundColor: foregroundColor, .backgroundColor: backgroundColor])
            items.build(builder, options: options, userInterfaceStyle: userInterfaceStyle)
        case .heading(let text, let level):
            let style: TextStyle
            switch level {
            case 1: style = MarkdownText.h1
            case 2: style = MarkdownText.h2
            case 3: style = MarkdownText.h3
            case 4: style = MarkdownText.h4
            case 5: style = MarkdownText.h5
            default:
                style = MarkdownText.h6
            }

            let builder = makeBuilder()
                .save()
                .add(style: style)

            builder.add(attributes: [
                .baselineOffset: 12,
                .foregroundColor: Colors.MarkdownColorStyle.foreground,
                .backgroundColor: backgroundColor
            ])
            text.build(builder, options: options, userInterfaceStyle: userInterfaceStyle)

            builder.restore()
        case .quote(let items, let level):
            endRunningText(isLast)

            let builder = StyledTextBuilder.markdownBase()
                .add(attributes: [
                    .foregroundColor: Colors.MarkdownColorStyle.mutedForeground,
                    .backgroundColor: backgroundColor
                ])

            let string = StyledTextRenderer(
                string: items.build(builder, options: options, userInterfaceStyle: userInterfaceStyle).build(),
                contentSizeCategory: options.contentSizeCategory,
                inset: MarkdownQuoteCell.inset(quoteLevel: level),
                backgroundColor: backgroundColor
            ).warm(width: options.width)

            models.append(MarkdownQuoteModel(level: level, string: string))
        case .image(let title, let href):
            endRunningText(isLast)

            guard let url = URL(string: href) else { continue }

            if url.pathExtension.lowercased() == "svg" {

            } else {
                models.append(MarkdownImageModel(url: url, title: title))
            }

        case .html(let text):
            endRunningText(isLast)

            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

            guard !trimmed.isEmpty else { continue }
            models.append(MarkdownHtmlModel(html: trimmed))
        case .table(let rows):
            endRunningText(isLast)

            var buckets = [TableBucket]()
            var rowHeights = [CGFloat]()

            let results = rows.build(options: options, userInterfaceStyle: userInterfaceStyle)
            results.forEach {
                fillBuckets(rows: $0.cells, buckets: &buckets, rowHeights: &rowHeights, fill: $0.fill)
            }

            models.append(MarkdownTableModel(buckets: buckets, rowHeights: rowHeights))
//        case .hr:
//
        case .codeBlock(let text, let language):
            endRunningText(true)
            models.append(MarkdownCodeBlockModel.makeModel(
                text: text,
                language: language,
                contentSizeCategory: options.contentSizeCategory,
                userInterfaceStyle: userInterfaceStyle)
            )
        case .list(let items, let type):
            items.build(makeBuilder(), options: options, type: type, userInterfaceStyle: userInterfaceStyle)
        default: break

        }
    }

    endRunningText(true)

    return models
}

struct MarkdownModels {
    func build(
        _ markdown: String,
        width: CGFloat,
        viewerCanUpdate: Bool,
        contentSizeCategory: UIContentSizeCategory,
        userInterfaceStyle: UIUserInterfaceStyle
    ) -> [BlockNode] {
        let cleaned = markdown.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let node = Node(markdown: cleaned) else { return [] }

        let options = CMarkOptions(
            contentSizeCategory: contentSizeCategory,
            viewerCanUpdate: viewerCanUpdate,
            width: width)

        let models = makeModels(elements: node.flatElements, options: options, userInterfaceStyle: userInterfaceStyle)

        return models
    }
}
