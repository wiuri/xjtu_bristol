//==============================================
// University of Bristol theme for Typst slides.
// Based on a previous version of David Barton's 
// UoB LaTeX Beamer template, found at
// https://github.com/dawbarton/UoB-beamer-theme
// =============================================

#import "../../xjtu_bristol.typ": *
#let bristol-theme(

    // reference: http://vi.xjtu.edu.cn/jcbf/scgf.htm
    color: cmyk(100%, 60%, 0%, 20%), // rgb(0, 78, 151) 校徽辅助蓝 深蓝 可代替黑色
    second_color: cmyk(20%, 100%, 80%, 10%), // 校徽辅助红 深红/暗红 

    // font
    font: "Tahoma", // TODO: 目前只写了英文字体

    // second_font: "Tahoma",
    watermark: "../../resources/motto_65transparent.png",
    logo: "../../resources/logo_blue.png",

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
    authors: "WQ",
    short-authors: "School of Economics and Finance",
    title: "Literature Research of Financial Engineering",
    subtitle: "original paper: Hedging With Linear Regressions and Neural Networks",
    short-title: "Xi'an Jiaotong University",
    date: "July 2023",
    aspect-ratio: "4-3",
    theme: bristol-theme()
)

#slide(theme-variant: "title slide")


#slide(title: "Highlights of our study")[
  - We study neural networks as nonparametric estimation tools for the hedging of options.
  - We design a network, named HedgeNet, that directly outputs a hedging strategy.
  - The network reduces the hedging error significantly.
  - A similar and even more outstanding benefit arises by simple linear regressions that incorporate the leverage effect.
]

#slide(title: "Background")[
  - Different practitioners will adopt different treatment methods for their assets based on their own utility. For an instance, if the financial entity was on the “buy-side,” taking on short positions in options to collect the volatility risk premium, and interested in maximizing the Sharpe ratio of her position. This entity would then try to hedge the exposure to the price movements in the underlying by trading it.
// 如果该金融实体处于“买方”，则在期权中持有空头头寸以收取波动性风险溢价，并有兴趣最大化其头寸的夏普比率。然后，该实体将试图通过交易来对冲标的资产价格波动的风险敞口
]

#slide(title: "Background")[
  - The mark-to-market accounting convention requires a good control of the hedging error for short periods, even when onsidering long-dated options.
  - Beginning with Hutchinson, Lo, and Poggio (1994) and Malliaris and Salchenberger (1993), artificial neural networks (ANNs) are being proposed as a nonparametric tool for the risk management of options.
]

#slide(title: "Background")[
  - Supplementary explanation: hedging error. The BS model is universally recognized as correct. Black-Scholes performs the best if implied volatility is plugged in. On one hand, since here we hedge only discretely, using the BS Delta leads to an error even if the data are simulated from the Black-Scholes model. On the other hand, the practitioner lacks perfect knowledge about the true market model but who is able to partially access the market prices.
]

#slide(title: "Background")[
    In the literature, other volatilities, such as historical volatility estimates or GARCH predicted volatilities have been used. The hedger would conduct a data-driven, nonparametric regression strategy in discrete time, based on the price data available to the hedger. We evaluate the hedging error of a historical delta-hedging strategy - a regression strategy based on the discrete observations. 
]

#slide(title: "Background")[    
    Since the regression-based strategy is free of parametric model assumptions about the securities, it is robust to misspecifi-cation of models and their parameters. Thus it is expected to serve as a benchmark for evaluating various parametric strategies; any existing parametric strategies would be justifiable only if they "outperform" this benchmark strategy when there is uncertainty about the true model.
]

#slide(title: "Theoretical Analysis")[
  - The variance of the hedged portfolio is approximated by the MSHE. Let's assume a situation. The mark-to-market accounting convention requires a good control of the hedging error for short periods, even when considering long-dated options. To reduce the variance of her portfolio the operator is allowed to buy or sell the underlying. 
]

#slide(title: "Theoretical Analysis")[  
  Today, she sells the option, say at price $C_0$. She is now allowed to buy delta shares of the underlying at price $S_0$ and $C_0 - delta$ units of the risk-free asset. Today's portfolio value equals $V_0$ = 0. Tomorrow The portfolio value is then given by 
  $ V_1^delta = delta S_1 + (1 + r_"ovn" Delta t)(C_0 - delta S_0) - C_1 $
]

#slide(title: "Theoretical Analysis")[  
  Since $Delta t$ is small and presumably the expected return on the risky asset happens to be equal to the risk-free return, var[$V_1^delta$] = E[$(V_1^delta)^2$], which is called mean squared hedging error (MSHE), namely
  $ E[(delta S_1 + (1 + r_"overnight" Delta t)(C_0 - delta S_0) - C_1)^2] $
]

#slide(title: "Theoretical Analysis")[  
  Hedged positions. Black-Scholes Delta (BS Delta): $delta_"BS" = N(d_1)$ where N denotes the cumulative normal distribution function. It is derived from the BS model That means 
  $ delta_"BS" = f_"BS"(M, sigma_"impl" sqrt(tau)) $
  Here the moneyness $M = S_0 / K$ and the square root of total implied variance $sigma_"impl" sqrt(tau))$. 
]

#slide(title: "Theoretical Analysis")[  
Similarly, we get
  $ delta_"ANN" = f_"ANN"(M, sigma_"impl" sqrt(tau)) $
  $ delta_"LN" = f_"LN"(M, sigma_"impl" sqrt(tau)) $
]

#slide(title: "Linear Regression Models")[
  - We introduce linear regression models that lead to hedging ratios that are linear in several option sensitivities, which are motivated by the #emph("leverage effect"). (Plus: In the original paper, the author used the linear regression model as a reference benchmark, but I have presented the experimental results comprehensively here)
]

#set text(font: "Tahoma", 24pt, cmyk(100%, 60%, 0%, 20%))

#slide(title: "Linear Regression Models")[
  #set text(font: "Tahoma", 20pt, cmyk(100%, 60%, 0%, 20%))
  #figure(
    image("resources/possible_LR_model.jpg", width: 50%),
    caption: [
        possible_LR_model
    ]
  )<possible_LR_model>
]

#slide(title: "Supplementary: BSM equation")[
  #set text(font: "Tahoma", 20pt, cmyk(100%, 60%, 0%, 20%))
  // BSM PDE
  #figure(
    image("resources/Solutions_to_the_BSM_equation.jpg", width: 100%),
    caption: [
        Solutions_to_the_BSM_equation
    ]
  )<Solutions_to_the_BSM_equation>
]

#slide(title: "Supplementary: BSM equation")[
    #set text(font: "Tahoma", 20pt, cmyk(100%, 60%, 0%, 20%))
    #figure(
      image("resources/Greek_alphabet.jpg", width: 95%),
      caption: [
          Greek_alphabet
      ]
  )<Greek_alphabet>
]

#set text(font: "Tahoma", 32pt, cmyk(100%, 60%, 0%, 20%))

#slide(title: "Artificial Neural Network Models")[
  - ANN. An ANN is a composition of simple elements called neurons, which maps input features to outputs. Such an ANN then forms a directed, weighted graph. Due to different motivations, We consider three different feature sets for the trainable part of HedgeNet(the ANN we design here). They are
]

#slide(title: "Artificial Neural Network Models")[
  $ "ANN"(M; sigma_"impl" sqrt(tau)) $
  $ "ANN"(delta_"BS"; V_"BS"; tau) $
  $ "ANN"(delta_"BS"; V_"BS"; "Va"_"BS"; tau) $
  Here, $delta_"BS"$denotes $delta_"BS"$; $V_"BS"$ denotes Vega, the sensitivity of the option price with respect to the implied volatility; $"Va"_"BS"$ denotes Vanna namely the sensitivity of Delta with respect to volatility.
]

#slide(title: "Output and Result")[
  Like this, we output the Hedging Ratio $delta$ directly. And we show the MSHE of different models.
]


#slide(title: "Output and Result")[
  #set text(font: "Tahoma", 20pt, cmyk(100%, 60%, 0%, 20%))
  #figure(
    image("resources/Performance_of_main_expr.jpg", width: 100%),
    caption: [
      Performance of the linear regressions and ANNs on the S&P 500 dataset. the unit of line 1 and the ones from line 3 on are percentage.
    ]
  )<Performance_of_main_expr>
]

#slide(title: "Output and Result")[
  We now present the results on the performance of the various statistical hedging models in terms of MSHE reduction. As a quick summary, the hedging ratios of the ANNs do not outperform the linear regression models. 
]

#slide(title: "Output and Result")[
  On the S&P 500 dataset, the Hull-White and Delta-Vega-Vanna regressions tend to perform the best, with Hull-White better on the one-day hedging period, and the Delta-Vega-Vanna regression better on the two-day period. On the Euro Stoxx 50 dataset, the Delta-Vega-Gamma-Vanna regression tends to perform the best.
]

#slide(title: "Conclusion")[
  In this work, we consider the problem of hedging an option over one period. We consider statistical, regression-type hedging ratios (in contrast to model-implied hedging ratios). To study whether the option sensitivities already capture the relevant nonlinearities we develop a suitable ANN architecture. 
]

#slide(title: "Conclusion")[
  Experiments involving both quoted prices (S&P 500 options) and high-frequency tick data (Euro Stoxx 50 options) show that the ANNs perform roughly as well (but not better) as the sensitivity-based linear regression models. However, the ANNs are not able to find additional nonlinear features. 
]

#slide(title: "Conclusion")[  
  Hence, option sensitivities by themselves (in particular, Delta, Vega, and Vanna) in combination with a linear regression are sufficient for a good hedging performance.
]

#slide(title: "Conclusion")[
  The linear regression models improve the hedging performance (in terms of MSHE) of the BS Delta by about 15-20% in real-world datasets. An explanation is the leverage effect that allows the partial hedging of changes in the implied volatility by using the underlying. 
]
  
#slide(title: "Conclusion")[  
  As a rule of thumb, historical data seem to imply that calls should be hedged with about $0.9 delta_"BS"$ and puts with about $1.1 delta_"BS"$. With the presence of sufficient historic data, we recommend to follow a hedging strategy obtained from a linear regression on the BS Delta, BS Vega, BS Vanna, and possibly the BS Gamma.
]

#slide(title: "References")[
  #par(text(size: 24pt)[
    + Ruf, J., and Wang, W. (2020), "Neural Networks for Option Pricing and Hedging: A Literature Review," Journal of Computational Finance, 24, 1-46.
    + Hutchinson, J. M., Lo, A. W., and Poggio, T. (1994), "A Nonparametric Approach to Pricing and Hedging Derivative Securities Via Learning Networks," The Journal of Finance, 49, 851-889. DOI: 10.1111/j.1540-6261.1994.tb00081.x. 
    + Hayashi, T. and Mykland, P.A. (2005), EVALUATING HEDGING ERRORS: AN ASYMPTOTIC APPROACH. Mathematical Finance, 15: 309-343.
    + Bergomi, L. (2009), "Smile Dynamics IV, Risk, 22, 94-100.
  ])
]