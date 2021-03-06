#' @title Interpolate a dataset
#' 
#' @description Performs interpolation of a gridded dataset into a new user-defined grid using bilinear weights 
#' or nearest-neighbour methods.
#' 
#' @importFrom fields interp.surface.grid
#' @importFrom fields interp.surface
#' @importFrom abind abind
#' 
#' @param obj A data object coming from \code{\link{loadGridData}}, \code{\link{loadStationData}} or the \pkg{ecomsUDG.Raccess} 
#' package function \code{\link[ecomsUDG.Raccess]{loadECOMS}}.
#' @param new.Coordinates Definition of the new coordinates (grid or locations), in the form of a list with the x and y components, in thir order.
#' Each component consists of a vector of length three with components \emph{from}, \emph{to} and \emph{by},
#'  in this order, similar as the arguments passed to the \code{\link[base]{seq}} function, giving the 
#'  westernmost, easternmost and grid cell width in the X axis and, in the same way,
#'  the southernmost, northernmost and grid cell resolution in the Y axis. See details.
#' @param method Method for interpolation. Currently implemented methods are either \code{bilinear},
#' for bilinear interpolation, and \code{nearest}, for nearest-neighbor interpolation (default).
#' @return An interpolated object preserving the output structure of the input
#'  (See e.g. \code{\link{loadGridData}}) for details on the output structure. 
#' @details  In case of default definition of either x, y or both grid coordinates, the default grid
#' is calculated taking the corners of the current grid and assuming x and y resolutions equal to 
#' the default \code{by} argument value in function \code{\link[base]{seq}}: \emph{by = ((to - from)/(length.out - 1))}.
#' The bilinear interpolator is a wrapper of the \code{\link[fields]{interp.surface.grid}} function
#' in package \pkg{fields}.
#' The output has special attributes in the \code{xyCoords} element that indicate that the object
#'  has been interpolated. These attributes are \code{interpolation}, which indicates the method used and
#'  \code{resX} and \code{resY}, for the grid-cell resolutions in the X and Y axes respectively.
#'  It is also possible to pass the interpolator the grid of a previously existing grid dataset using the
#'  \code{\link{getGrid}} method.
#' @note To avoid unnecessary NA values, the function will not extrapolate using a new grid outside the
#' current extent of the dataset, returning an error message.
#' @family loading.grid
#' @author J. Bedia \email{joaquin.bedia@@gmail.com} and S. Herrera
#' @export
#' @examples \dontrun{
#' # Download NCEP (model data) datasets
#' dir.create("mydirectory")
#' download.file("http://meteo.unican.es/work/downscaler/data/Iberia_NCEP.tar.gz",
#'               destfile = "mydirectory/Iberia_NCEP.tar.gz")
#' # Extract files from the tar.gz file
#' untar("mydirectory/NCEP_Iberia.tar.gz", exdir = "mydirectory")
#' # Path to the NCEP ncml file.
#' ncep <- "mydirectory/Iberia_NCEP/Iberia_NCEP.ncml"
#' # Load air temperature at 1000 mb isobaric pressure level for boreal winter (DJF) 1991-2000
#' t1000.djf <- loadGridData(ncep, var = "ta@@1000", lonLim = c(-12,10), latLim = c(33,47),
#'  season = c(12,1,2), years = 1991:2000)
#' par(mfrow = c(2,1))
#' plotMeanField(t1000.djf)
#' # Bilinear interpolation to a smaller domain centered in Spain using a 0.5 degree resolution 
#' # in both X and Y axes
#' t1000.djf.05 <- interpData(t1000.djf, new.Coordinates = list(x = c(-10,5,.5), y = c(36,44,.5)),
#'  method = "bilinear")
#' plotMeanField(t1000.djf.05)
#' par(mfrow=c(1,1))
#' # New attributes "interpolation", "resX" and "resY" indicate that the original data have been
#' # interpolated:
#' attributes(t1000.djf.05$xyCoords)
#' }


interpData <- function(obj, new.Coordinates = list(x = NULL, y = NULL), method = c("nearest", "bilinear")) {
  method <- match.arg(method, choices = c("nearest", "bilinear"))
  if (any(attr(obj$Data, "dimensions") == "station")){
    x <- as.numeric(obj$xyCoords[,1])
    y <- as.numeric(obj$xyCoords[,2])
  }else{
    x <- obj$xyCoords$x
    y <- obj$xyCoords$y
  }
  if (is.null(new.Coordinates)) {
    new.Coordinates <- getGrid(obj)
  }else{
    if (is.null(new.Coordinates$x)) {
      new.Coordinates$x <- x
    }
    if (is.null(new.Coordinates$y)) {
      new.Coordinates$y <- y
    }
  }
  if (any(attr(new.Coordinates,"type") == "location")) {
    obj <- interpLocData(obj, new.points = new.Coordinates, method = method)
  }else{
    obj <- interpGridData(obj, new.grid = new.Coordinates, method = method)
  }
  return(obj)
}
# End   
