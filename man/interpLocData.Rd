% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/interpLocData.R
\name{interpLocData}
\alias{interpLocData}
\title{Interpolate a dataset to a grid}
\usage{
interpLocData(obj, new.points = list(x = NULL, y = NULL),
  method = c("nearest", "bilinear"))
}
\arguments{
\item{obj}{A data object coming from \code{\link{loadGridData}}, \code{\link{loadStationData}} or the \pkg{ecomsUDG.Raccess}
package function \code{\link[ecomsUDG.Raccess]{loadECOMS}}.}

\item{new.points}{Definition of the new locations, in the form of a list with the x and y components, in thir order.
Each component consists of a vector of length three with components \emph{from}, \emph{to} and \emph{by},
 in this order, similar as the arguments passed to the \code{\link[base]{seq}} function, giving the
 westernmost, easternmost and grid cell width in the X axis and, in the same way,
 the southernmost, northernmost and grid cell resolution in the Y axis. See details.}

\item{method}{Method for interpolation. Currently implemented methods are either \code{bilinear},
for bilinear interpolation, and \code{nearest}, for nearest-neighbor interpolation (default).}
}
\value{
An interpolated object preserving the output structure of the input
 (See e.g. \code{\link{loadGridData}} for details on the output structure).
}
\description{
Performs interpolation of a gridded/location dataset into a new user-defined location using bilinear weights
or nearest-neighbour methods.
}
\details{
In case of default definition of either x, y or both coordinates, the default location
is the same than the locations considered in the data object \code{obj}.
The bilinear interpolator is a wrapper of the \code{\link[fields]{interp.surface}} function
in package \pkg{fields}.
The output has special attributes in the \code{xyCoords} element that indicate that the object
 has been interpolated. These attributes are \code{interpolation}, which indicates the method used and
 \code{resX} and \code{resY}, for the grid-cell resolutions in the X and Y axes respectively.
 It is also possible to pass the interpolator the grid of a previously existing grid dataset using the
 \code{\link{getGrid}} method.
}
\note{
To avoid unnecessary NA values, the function will not extrapolate using a new grid outside the
current extent of the dataset, returning an error message.
}
\author{
J. Bedia \email{joaquin.bedia@gmail.com} and S. Herrera
}
\seealso{
Other loading.grid: \code{\link{getGrid}};
  \code{\link{interpData}}; \code{\link{interpGridData}};
  \code{\link{loadGridData}}
}

