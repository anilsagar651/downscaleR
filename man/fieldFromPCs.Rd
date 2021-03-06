% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/fieldFromPCs.R
\name{fieldFromPCs}
\alias{fieldFromPCs}
\title{Reconstruct a Field from EOFs and principal components}
\usage{
fieldFromPCs(prinCompObj, var)
}
\arguments{
\item{prinCompObj}{A EOF analysis object as returned by \code{\link{prinComp}}}

\item{var}{Character string indicating the variable to be re-constructed. In case of
PCA analyses performed on a single variable (either multimember or not), this can be omitted.}
}
\value{
A list similar to the \code{\link{loadGridData}} output, but simplified. See details.
}
\description{
Reconstructs a field of a climatic variable from the outputs of a
principal components analysis
}
\details{
The output of this function returns the minimum required information to use the
 \code{\link{plotMeanField}} method, and is intended for comparison and visual analysis
 of the differences between the original fields and the reconstructed ones, for instance
 in determining an optimal number of PCs etc... Hence, the temporal information (i.e.,
  the \code{Dates} object) is lost, and should be retrieved from the original field/multifield
  object used to compute the PC/EOF analysis.
}
\examples{
\dontrun{
# First a multifield containing a set of variables is loaded (e.g. data for spring spanning the
# 30-year period 1981--2010):
dir.create("mydirectory")
download.file("http://meteo.unican.es/work/downscaler/data/Iberia_NCEP.tar.gz",
destfile = "mydirectory/Iberia_NCEP.tar.gz")
# Extract files from the tar.gz file
untar("mydirectory/NCEP_Iberia.tar.gz", exdir = "mydirectory")
# First, the path to the ncml file is defined:
ncep <- "mydirectory/Iberia_NCEP/Iberia_NCEP.ncml"
multifield <- loadMultiField(ncep, vars = c("hus@850", "ta@850", "psl"),
                             season = c(3:5), years = 1981:2010)
# In this example, we retain the first 10 PCs
pca <- prinComp(multifield, n.eofs = 10)
# We now recover the sea-level pressure field from the PCs:
names(pca)
psl2 <- fieldFromPCs(pca, "psl")
str(psl2)
# The attributes of psl2 indicate that this is a reconstructed field from 10 PCs,
# explaining 99\\\% of the variance:
attributes(psl2)
multifield$Variable$varName
# psl is the 3rd one
# The mean fields of both the original and the reconstructed fields is computed:
psl.orig <- multifield$Data[3,,,]
psl.reconstructed <- psl2$Data
z <- apply(psl.orig, c(3,2), mean)
z1 <- apply(psl.reconstructed, c(3,2), mean)
# These are the spatial coordinates
x <- psl2$xyCoords$x
y <- psl2$xyCoords$y
require(fields)
par(mfrow = c(2,2))
image.plot(x,y,z, asp = 1, horizontal = TRUE)
world(add = TRUE)
title("Original SLP field")
image.plot(x,y,z1, asp = 1, horizontal = TRUE)
world(add = TRUE)
title("Reconstructed SLP field")
mtext("(Using the first 10 PCs)")
image.plot(x,y,z1-z, asp = 1)
world(add = TRUE)
title("Difference (bias)")
par(mfrow = c(1,1))

# An example of multimember reconstruction from a multimember PC analysis:
data(tasmax_forecast)
# Note that multimember pca analysis takes some time, depending on the computer
pca2 <- prinComp(tasmax_forecast, n.eofs = 10)
tasmax_recovered <- fieldFromPCs(pca2)
plotMeanField(tasmax_recovered, multi.member = TRUE)
# Also note that now the length of the "nPCs" and "explained_variance" matches
# the number of members:
attributes(tasmax_recovered)
}
}
\author{
J. Bedia \email{joaquin.bedia@gmail.com}
}
\seealso{
\code{\link{prinComp}}, \code{\link{plotEOF}}
}

