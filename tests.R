#install.packages("base64")
library(base64)

#install.packages("base64enc")
library(base64enc)

#install.packages("gridSVG")
#require(devtools)
#setwd("c:/users/kent.tleavell_nt/dropbox/development/r/gridsvg/pkg")
#load_all()
library(gridSVG)

library(latticeExtra)


# a chart by http://www.fromthebottomoftheheap.net/2013/10/23/time-series-plots-with-lattice-and-ggplot/
set.seed(1)
tdat <- data.frame(Site = rep(paste0("Site", c("A","B")),
                              each = 100),
                   Date = rep(seq(Sys.Date(), by = "1 day", length = 100), 2),
                   Fitted = c(cumsum(rnorm(100)), cumsum(rnorm(100))),
                   Signif = rep(NA, 200))
tdat <- transform(tdat, Upper = Fitted + 1.5, Lower = Fitted - 1.5)
## select 1 region per Site as signif
take <- sample(10:70, 2)
take[2] <- take[2] + 100
tdat$Signif[take[1]:(take[1]+25)] <- tdat$Fitted[take[1]:(take[1]+25)]
tdat$Signif[take[2]:(take[2]+25)] <- tdat$Fitted[take[2]:(take[2]+25)]

xyplot(Fitted + Upper + Lower + Signif ~ Date | Site,
               data = tdat,
               type = "l",
               lty = c(1, 2, 2, 1),
               lwd = c(1, 1, 1, 3),
               col.line = c(rep("black",3), "red"),
       #lattice.options = theEconomist.opts(),
       par.settings = theEconomist.theme(),
       scales = list(alternating=c(1,0),x=list(tck=c(1,0))))

testsvg <- grid.export()
testsvg_output <- saveXML(testsvg$svg,"testsvg.svg")


cat(
  "<img src = data:image/svg+xml;base64,",
  base64encode(testsvg_output),
  ">"
)
