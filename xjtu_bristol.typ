//==============================================
// University of Bristol theme for Typst slides.
// Based on a previous version of David Barton's 
// UoB LaTeX Beamer template, found at
// https://github.com/dawbarton/UoB-beamer-theme
// =============================================

#import "resources/slides.typ": *
#let bristol-theme(

    // reference: http://vi.xjtu.edu.cn/jcbf/scgf.htm
    color: cmyk(100%, 60%, 0%, 20%), // rgb(0, 78, 151) 校徽辅助蓝 深蓝 可代替黑色
    second_color: cmyk(20%, 100%, 80%, 10%), // 校徽辅助红 深红/暗红 

    // font
    font: "Tahoma", // TODO: 目前只写了英文字体

    // second_font: "Tahoma",
    watermark: "resources/motto_65transparent.png",
    logo: "resources/logo_blue.png",

    // secondlogo: "second_logo.png" // 原图为经济与金融学院 若添加second_logo则需同步修改35、36行

) = data => {
    
    let title-slide(slide-info, bodies) = {

     	place(image(watermark, width:100%))

        v(5%)

        grid(columns: (5%, 1fr, 1fr, 5%),
            [],
            align(horizon + left)[#image(logo, width:60%)],
            // align(horizon + right)[#image(secondlogo, width:60%)], // 如果使用secondlogo则取消该行注释
            [], // 如果使用secondlogo则注释该行
            []
        )

        v(-5%)

        align(center + horizon)[ // 结合v(5%)和v(-5%) 表示上下左右居中
            #block(
                stroke: ( y: 1mm + color ),
                inset: .75em,
                breakable: false,
                [
                    #text(font: font, 1.6em, color)[*#data.title*] 
                    \ // title之后的换行符
                    #{
                        if data.subtitle != none {
                            text(1.2em, color)[#data.subtitle]
                        }
                    }
                ]
            )

            #v(2em)
            #set text(font: font, .8em, color)
            #grid(
                columns: (1fr,) * calc.min(data.authors.len(), 3),
                column-gutter: .375em,
                row-gutter: .5em,
                ..data.authors // 适用于多个作者
            )
            #v(2pt)

            #set text(font: font, .7em, color)
            #data.date
        ]
    }

    let default(slide-info, bodies) = {
        place(image(watermark, width:100%))
        let body = none
        if bodies.len() == 1 {
            body = bodies.first()
        } else{ // 适用于多栏 reference: https://andreaskroepelin.github.io/typst-slides/book/slide.html#slides-with-multiple-content-bodies
            let colwidths = (1fr,) * bodies.len()
            let thisgutter = .2em

            if "colwidths" in slide-info{ 
                colwidths = slide-info.colwidths
                if colwidths.len() != bodies.len(){
                    panic("Provided colwidths must be of same length as bodies")
                }
            }

            if "gutter" in slide-info{
                thisgutter = slide-info.gutter
            }

            body = grid(
                columns: colwidths,
                gutter: thisgutter,
                ..bodies
            )
        }

        let decoration(type, body) = {
            let border = 0.6mm + second_color
            let strokes = (
                header: ( bottom: border ),
                footer: ( top: border )
            )
            let insets = (
                header: ( x: .5em, y: .4em ),
                footer: ( x: 15%, y: .24em )
            )
            grid(
                columns: (3%, 94%, 3%), 
                [], 
                block(
                    stroke: strokes.at(type),
                    width: 100%,
                    inset: insets.at(type),
                    body
                ),
                []
            )
        }


        // header
        if "title" in slide-info {
            v(.2em)
            decoration("header")[
                #text(font: font, second_color)[#slide-info.title] 
                #h(1fr)
                #text(font: font, second_color, .75em)[#section.display()] 
            ]
        }
        
        // body
        block(
            width: 100%, inset: (x: 8%, y: 1.2em), 
            breakable: false, 
            outset: 0em,
            text(32pt, color)[#body]
        )

        v(1fr)

        // footer
        decoration("footer")[
            #text(font: font, second_color, .6em)[#data.short-authors] 
            #h(1fr)
            #text(second_color, .6em)[#logical-slide.display()]
        ]
    }

    let wake-up(slide-info, bodies) = {  // TODO: 原封未动
        if bodies.len() != 1 {
            panic("wake up variant of bristol theme only supports one body per slide")
        }
        let body = bodies.first()

        block(
            width: 100%, height: 100%, inset: 2em, breakable: false, outset: 0em,
            fill: color,
            text(size: 1.5em, fill: white, {v(1fr); body; v(1fr)})
        )
    }

    (
        "title slide": title-slide, 
        "default": default, 
        "wake up": wake-up,
    )
}

#show: slides.with(
    authors: ("my Author A", "my Author B"), 
    short-authors: "my Short author",
    title: "my Title", 
    subtitle: "my Subtitle",
    short-title: "my Short title", 
    date: "my Date",
    theme: bristol-theme(),
)

#slide(theme-variant: "title slide")

#new-section("my section name")

#slide(title: "my Slide title")[
    A slide of mine.
]

#slide()[
    A slide without a title of mine.
]

#slide()[
    #lorem(60) // a full slide
]

#slide(title: "a full slide of mine with title")[
    #lorem(50) // a full slide
]

// #slide(title: "Two column", gutter: .5em)[
// Column A goes on the left...
// ][
// And column B goes on the right!
// ]

// #slide(title: "Variable column sizes", colwidths: (2fr, 1fr, 3fr))[
// This is a medium-width column
// ][
// This is a rather narrow column
// ][
// This is a quite a wide column
// ]

// #slide(theme-variant: "wake up")[
//   Wake up!
// ]