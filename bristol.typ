//==============================================
// University of Bristol theme for Typst slides.
// Based on a previous version of David Barton's 
// UoB LaTeX Beamer template, found at
// https://github.com/dawbarton/UoB-beamer-theme
// =============================================

#import "slides.typ": *
#let bristol-theme(
    color: rgb("#00008b"), 
    second_color: rgb(200, 22, 30),
    font: "Tahoma",
    // second_font: "Tahoma",
    watermark: "slogn_65transparent.png",
    logo: "logo_blue.png",
    secondlogo: "second_logo.png"
) = data => {
    
    let title-slide(slide-info, bodies) = {

     	place(image(watermark, width:100%))

        v(5%)

        grid(columns: (5%, 1fr, 1fr, 5%),
            [],
            align(horizon + left)[#image(logo, width:60%)],
            align(horizon + right)[#image(secondlogo, width:60%)],
            [])

        v(-10%)

        align(center + horizon)[
            #block(
                stroke: ( y: 1mm + color ),
                inset: .8em,
                breakable: false,
                [
                    #text(font: font, 1.5em, color)[*#data.title*] \
                    #{
                        if data.subtitle != none {
                            parbreak()
                            text(1.2em, color)[#data.subtitle]
                        }
                    }
                ]
            )

            #v(1em)
            #set text(font: font, .8em, color)
            #grid(
                columns: (1fr,) * calc.min(data.authors.len(), 3),
                column-gutter: .375em,
                row-gutter: .5em,
                ..data.authors
            )
            #v(2pt)
            #data.date
        ]
    }

    let default(slide-info, bodies) = {
        place(image(watermark, width:100%))
        let body = none
        if bodies.len() == 1 {
            body = bodies.first()
        } else{
            let colwidths = none
            let thisgutter = .2em

            if "colwidths" in slide-info{
                colwidths = slide-info.colwidths
                if colwidths.len() != bodies.len(){
                    panic("Provided colwidths must be of same length as bodies")
                }
            } else{
                colwidths = (1fr,) * bodies.len()
            }

            if "gutter" in slide-info{
                thisgutter = slide-info.gutter
            }

            // v(1em)
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
                header: ( x: .5em, y: .7em ),
                footer: ( x: .5em, y: .4em )
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
        // decoration("header", grid(columns: (1fr, 1fr),
	    //         align(left, image(logo, width:35%)),
        //         align(
        //             right, 
        //             grid(
        //                 rows: (.5em, .5em),
        //                 text(color, .7em)[#data.short-title],
        //                 [],
        //                 text(color, .7em)[#section.display()]
        //             )
        //         )
        //     )
        // )

        if "title" in slide-info {
            // header
            decoration("header")[
                // #heading(level: 2, text(font: font, second_color)[
                //     #slide-info.title 
                //     #h(1fr) 
                //     #text(font: font, .8em)[#section.display()]
                // ])
                // text(font: font, second_color)[
                //     #slide-info.title 
                //     #h(1fr) 
                //     #text(font: font, .8em)[#section.display()]
                // ]
                // #h(1fr)
                #text(font: font, second_color)[#slide-info.title] 
                #h(1fr)
                #text(font: font, second_color, .6em)[#section.display()] 
            ]
            // block(
            //     width: auto,
            //     fill: rgb(255, 255, 255),
            //     inset: (x: 4.5%, y: 1.2em), 
            //     breakable: false,
            //     outset: 0em,
            //     heading(level: 1, text(color)[#slide-info.title])
            // )
        }
        
        v(0.6fr)

        block(
            width: 100%, inset: (x: 2em), breakable: false, outset: 0em,
            body
            // fill: color, 
            // text(fill: color)[body]
        )

        v(2fr)

        // footer
        decoration("footer")[
            #text(font: font, second_color, .6em)[#data.short-authors] 
            #h(1fr)
            #text(second_color, .6em)[#logical-slide.display()]
        ]
    }

    let wake-up(slide-info, bodies) = {
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
        "title slide": title-slide, "default": default, "wake up": wake-up,
    )
}

#show: slides.with(
    authors: ("Author A", "Author B"), short-authors: "Short author",
    title: "Title", short-title: "Short title", subtitle: "Subtitle",
    date: "Date",
    theme: bristol-theme(),
)

#slide(theme-variant: "title slide")

#new-section("section name")

#slide(title: "Slide title")[
  A slide
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