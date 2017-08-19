#' A class that defines a collection of Excel styles as used by the openxlsx
#' package.
#'
#' The PivotOpenXlsxStyles class stores a collection of PivotTableOpenXlsx style
#' objects.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @import jsonlite
#' @export
#' @return Object of \code{\link{R6Class}} with properties and methods that
#'   define styles/a theme for a pivot table.
#' @format \code{\link{R6Class}} object.
#' @examples
#' # This class is used internally by the Pivot Table.
#' @field parentPivot Owning pivot table.

#' @section Methods:
#' \describe{
#'   \item{Documentation}{For more complete explanations and examples please see
#'   the extensive vignettes supplied with this package.}
#'   \item{\code{new(...)}}{Create a new set of styles, specifying the field
#'   values documented above.}
#'
#'   \item{\code{addNamedStyles(mapFromCss=TRUE)}}{Populate the OpenXlsx styles
#'   based on the styles defined in the pivot table.}
#'   \item{\code{asList()}}{Get a list representation of the styles.}
#'   \item{\code{asJSON()}}{Get a JSON representation of the styles.}
#'   \item{\code{asString()}}{Get a text representation of the styles.}
#' }

PivotOpenXlsxStyles <- R6::R6Class("PivotOpenXlsxStyles",
  public = list(
    initialize = function(parentPivot) {
      if(parentPivot$argumentCheckMode > 0) {
        checkArgument(parentPivot$argumentCheckMode, FALSE, "PivotOpenXlsxStyles", "initialize", parentPivot, missing(parentPivot), allowMissing=FALSE, allowNull=FALSE, allowedClasses="PivotTable")
      }
      private$p_parentPivot <- parentPivot
      if(private$p_parentPivot$traceEnabled==TRUE) private$p_parentPivot$trace("PivotOpenXlsxStyles$new", "Creating new Pivot OpenXlsx Styles...")
      private$p_styles <- list()
      if(private$p_parentPivot$traceEnabled==TRUE) private$p_parentPivot$trace("PivotOpenXlsxStyles$new", "Created new Pivot OpenXlsx Styles.")
    },
    clearStyles = function() {
      if(private$p_parentPivot$traceEnabled==TRUE) p
      private$p_parentPivot$trace("PivotOpenXlsxStyles$clearStyles", "Clearin styles...")
      private$p_styles <- list()
      if(private$p_parentPivot$traceEnabled==TRUE) private$p_parentPivot$trace("PivotOpenXlsxStyles$clearStyles", "Cleared styles.")
    },
    addNamedStyles = function(mapFromCss=TRUE) {
      if(private$p_parentPivot$argumentCheckMode > 0) {
        checkArgument(private$p_parentPivot$argumentCheckMode, FALSE, "PivotOpenXlsxStyles", "initialize", mapFromCss, missing(mapFromCss), allowMissing=TRUE, allowNull=FALSE, allowedClasses="logical")
      }
      if(private$p_parentPivot$traceEnabled==TRUE) private$p_parentPivot$trace("PivotOpenXlsxStyles$addNamedStyles", "Adding named styles...")
      for(i in 1:length(private$p_parentPivot$styles$styles)) {
        style <- private$p_parentPivot$styles$styles[[i]]

        # base of style
        baseStyleName <- style$name
        isBaseStyle <- TRUE

        # font name
        fontName <- NULL
        xlStyleValue <- cleanCssValue(style$getPropertyValue("xl-font-name"))
        if(mapFromCss&&(!isTextValue(xlStyleValue))) {
          fontFamilyList <- style$getPropertyValue("font-family")
          if(isTextValue(fontFamilyList)) {
            fontFamilyList <- cleanCssValue(parseCssString(fontFamilyList))
            if(length(fontFamilyList)>0) xlStyleValue <- trimws(fontFamilyList[1])
          }
        }
        if(isTextValue(xlStyleValue)) fontName <- xlStyleValue

        # font size
        xlStyleValue <- cleanCssValue(style$getPropertyValue("xl-font-size"))
        if(isTextValue(xlStyleValue)) xlStyleValue <- suppressWarnings(max(min(as.numeric(xlStyleValue), 72), 4))
        if(is.null(xlStyleValue)||is.na(xlStyleValue)) xlStyleValue <- NULL
        if(mapFromCss&&(!isTextValue(xlStyleValue))) {
          fontSize <- style$getPropertyValue("font-size")
          xlStyleValue <- parseCssSizeToPt(fontSize)
        }
        if(!isNumericValue(xlStyleValue)) fontSize <- 11
        else fontSize <- xlStyleValue

        # bold
        bold <- FALSE
        xlStyleValue <- cleanCssValue(style$getPropertyValue("xl-bold"))
        if(isTextValue(xlStyleValue)) {
          if(tolower(xlStyleValue)=="bold") bold <- TRUE
          else bold <- FALSE
        }
        else if(mapFromCss) {
          fontWeight <- cleanCssValue(style$getPropertyValue("font-weight"))
          if(isTextValue(fontWeight)) {
            if(tolower(fontWeight) %in% c("bold", "bolder")) bold <- TRUE
            else {
              fontWeight <- suppressWarnings(as.numeric(fontWeight))
              if((isNumericValue(fontWeight))&&(fontWeight>=600)) bold <- TRUE
            }
          }
        }

        # italic
        italic <- FALSE
        xlStyleValue <- cleanCssValue(style$getPropertyValue("xl-italic"))
        if(isTextValue(xlStyleValue)) {
          if(tolower(xlStyleValue)=="italic") italic <- TRUE
          else italic <- FALSE
        }
        else if(mapFromCss) {
          fontStyle <- cleanCssValue(style$getPropertyValue("font-style"))
          if(isTextValue(fontStyle)&&(tolower(fontStyle) %in% c("italic", "oblique"))) italic <- TRUE
        }

        # underline
        underline <- FALSE
        xlStyleValue <- cleanCssValue(style$getPropertyValue("xl-underline"))
        if(isTextValue(xlStyleValue)) {
          if(tolower(xlStyleValue)=="underline") underline <- TRUE
          else underline <- FALSE
        }
        else if(mapFromCss) {
          textDecoration <- cleanCssValue(style$getPropertyValue("text-decoration"))
          if(isTextValue(textDecoration)&&(tolower(textDecoration)=="underline")) underline <- TRUE
        }

        # strikethrough
        strikethrough <- FALSE
        xlStyleValue <- cleanCssValue(style$getPropertyValue("xl-strikethrough"))
        if(isTextValue(xlStyleValue)) {
          if(tolower(xlStyleValue)=="strikethrough") strikethrough <- TRUE
          else strikethrough <- FALSE
        }
        else if(mapFromCss) {
          textDecoration <- cleanCssValue(style$getPropertyValue("text-decoration"))
          if(isTextValue(textDecoration)&&(tolower(textDecoration)=="line-through")) strikethrough <- TRUE
        }

        # superscript
        superscript <- FALSE
        xlStyleValue <- cleanCssValue(style$getPropertyValue("xl-superscript"))
        if(isTextValue(xlStyleValue)&&(tolower(xlStyleValue)=="superscript")) superscript <- TRUE

        # subscript
        subscript <- FALSE
        xlStyleValue <- cleanCssValue(style$getPropertyValue("xl-subscript"))
        if(isTextValue(xlStyleValue)&&(tolower(xlStyleValue)=="subscript")) subscript <- TRUE

        # fill color
        fillColor <- NULL
        xlStyleValue <- cleanCssValue(style$getPropertyValue("xl-fill-color"))
        check <- grep("#[0-9A-F]{6}", xlStyleValue)
        if((length(check)==0)||(check==FALSE)) xlStyleValue <- NULL
        if(mapFromCss && is.null(xlStyleValue)) {
          backgroundColor <- style$getPropertyValue("background-color")
          xlStyleValue <- parseColor(backgroundColor)
        }
        if(isTextValue(xlStyleValue)) fillColor <- xlStyleValue

        # text color
        textColor <- NULL
        xlStyleValue <- cleanCssValue(style$getPropertyValue("xl-text-color"))
        check <- grep("#[0-9A-F]{6}", xlStyleValue)
        if((length(check)==0)||(check==FALSE)) xlStyleValue <- NULL
        if(mapFromCss && is.null(xlStyleValue)) {
          color <- style$getPropertyValue("color")
          xlStyleValue <- parseColor(color)
        }
        if(isTextValue(xlStyleValue)) textColor <- xlStyleValue

        # horizontal alignment
        hAlign <- NULL
        xlStyleValue <- tolower(cleanCssValue(style$getPropertyValue("xl-h-align")))
        if(isTextValue(xlStyleValue)) {
          if(xlStyleValue=="left") hAlign <- "left"
          else if(xlStyleValue=="center") hAlign <- "center"
          else if(xlStyleValue=="right") hAlign <- "right"
        }
        else if(mapFromCss) {
          textAlign <- tolower(cleanCssValue(style$getPropertyValue("text-align")))
          if(isTextValue(textAlign)) {
            if(textAlign=="left") hAlign <- "left"
            else if(textAlign=="center") hAlign <- "center"
            else if(textAlign=="right") hAlign <- "right"
          }
        }

        # vertical alignment
        vAlign <- NULL
        xlStyleValue <- tolower(cleanCssValue(style$getPropertyValue("xl-v-align")))
        if(isTextValue(xlStyleValue)) {
          if(xlStyleValue=="top") vAlign <- "top"
          else if(xlStyleValue=="middle") vAlign <- "middle"
          else if(xlStyleValue=="bottom") vAlign <- "bottom"
        }
        else if(mapFromCss) {
          verticalAlign <- tolower(cleanCssValue(style$getPropertyValue("vertical-align")))
          if(isTextValue(verticalAlign)) {
            if(verticalAlign=="top") vAlign <- "top"
            else if(verticalAlign=="top") vAlign <- "text-top"
            else if(verticalAlign=="middle") vAlign <- "middle"
            else if(verticalAlign=="bottom") vAlign <- "text-bottom"
            else if(verticalAlign=="bottom") vAlign <- "bottom"
          }
        }

        # wrap text
        wrapText <- FALSE
        xlStyleValue <- cleanCssValue(style$getPropertyValue("xl-wrap-text"))
        if(isTextValue(xlStyleValue)&&(tolower(xlStyleValue)=="wrap")) wrapText <- TRUE

        # text rotation
        textRotation <- NULL
        xlStyleValue <- cleanCssValue(style$getPropertyValue("xl-text-rotation"))
        if(isTextValue(xlStyleValue)) xlStyleValue <- suppressWarnings(max(min(as.numeric(xlStyleValue), 359), 0))
        if(isNumericValue(xlStyleValue)) textRotation <- xlStyleValue

        # indent
        indent <- NULL
        xlStyleValue <- cleanCssValue(style$getPropertyValue("xl-indent"))
        if(isTextValue(xlStyleValue)) xlStyleValue <- suppressWarnings(max(min(as.numeric(xlStyleValue), 500), 0))
        if(isNumericValue(xlStyleValue)&&(xlStyleValue>0)) indent <- xlStyleValue

        # border all
        borderAll <- NULL
        xlStyleValue <- cleanCssValue(style$getPropertyValue("xl-border"))
        if(isTextValue(xlStyleValue)) borderAll <- parseXlBorder(xlStyleValue)
        else if(mapFromCss) {
          cssBorder <- style$getPropertyValue("border")
          if(isTextValue(cssBorder)) cssBorder <- getXlBorderFromCssBorder(cssBorder)
          if(!is.null(cssBorder)) borderAll <- cssBorder
        }

        # border left
        borderLeft <- NULL
        xlStyleValue <- cleanCssValue(style$getPropertyValue("xl-border-left"))
        if(isTextValue(xlStyleValue)) borderLeft <- parseXlBorder(xlStyleValue)
        else if(mapFromCss) {
          cssBorder <- style$getPropertyValue("border-left")
          if(isTextValue(cssBorder)) cssBorder <- getXlBorderFromCssBorder(cssBorder)
          if(!is.null(cssBorder)) borderLeft <- cssBorder
        }

        # border right
        borderRight <- NULL
        xlStyleValue <- cleanCssValue(style$getPropertyValue("xl-border-right"))
        if(isTextValue(xlStyleValue)) borderRight <- parseXlBorder(xlStyleValue)
        else if(mapFromCss) {
          cssBorder <- style$getPropertyValue("border-right")
          if(isTextValue(cssBorder)) cssBorder <- getXlBorderFromCssBorder(cssBorder)
          if(!is.null(cssBorder)) borderRight <- cssBorder
        }

        # border top
        borderTop <- NULL
        xlStyleValue <- cleanCssValue(style$getPropertyValue("xl-border-top"))
        if(isTextValue(xlStyleValue)) borderTop <- parseXlBorder(xlStyleValue)
        else if(mapFromCss) {
          cssBorder <- style$getPropertyValue("border-top")
          if(isTextValue(cssBorder)) cssBorder <- getXlBorderFromCssBorder(cssBorder)
          if(!is.null(cssBorder)) borderTop <- cssBorder
        }

        # border bottom
        borderBottom <- NULL
        xlStyleValue <- cleanCssValue(style$getPropertyValue("xl-border-bottom"))
        if(isTextValue(xlStyleValue)) borderBottom <- parseXlBorder(xlStyleValue)
        else if(mapFromCss) {
          cssBorder <- style$getPropertyValue("border-bottom")
          if(isTextValue(cssBorder)) cssBorder <- getXlBorderFromCssBorder(cssBorder)
          if(!is.null(cssBorder)) borderBottom <- cssBorder
        }

        # value format
        valueFormat <- NULL
        xlStyleValue <- cleanCssValue(style$getPropertyValue("xl-format"))
        if(isTextValue(xlStyleValue)) valueFormat <- xlStyleValue

        # minimum column width
        minColumnWidth <- NULL
        xlStyleValue <- cleanCssValue(style$getPropertyValue("xl-min-column-width"))
        if(isTextValue(xlStyleValue)) xlStyleValue <- suppressWarnings(max(min(as.numeric(xlStyleValue), 255), 0))
        if(isNumericValue(xlStyleValue)) minColumnWidth <- xlStyleValue

        # minimum row height
        minRowHeight <- NULL
        xlStyleValue <- cleanCssValue(style$getPropertyValue("xl-min-row-height"))
        if(isTextValue(xlStyleValue)) xlStyleValue <- suppressWarnings(max(min(as.numeric(xlStyleValue), 400), 0))
        if(isNumericValue(xlStyleValue)) minRowHeight <- xlStyleValue

        # create the new style and add it to the collection
        style <- PivotOpenXlsxStyle$new(private$p_parentPivot,
                                        baseStyleName=baseStyleName, isBaseStyle=isBaseStyle,
                                        fontName=fontName, fontSize=fontSize,
                                        bold=bold, italic=italic, underline=underline,
                                        strikethrough=strikethrough, superscript=superscript,
                                        subscript=subscript, fillColor=fillColor, textColor=textColor,
                                        hAlign=hAlign, vAlign=vAlign, wrapText=wrapText,
                                        textRotation=textRotation, indent=indent,
                                        borderAll=borderAll,
                                        borderLeft=borderLeft, borderRight=borderRight,
                                        borderTop=borderTop, borderBottom=borderBottom,
                                        valueFormat=valueFormat,
                                        minColumnWidth=minColumnWidth, minRowHeight=minRowHeight)
        private$p_styles[[length(private$p_styles)+1]] <- style
      }
      if(private$p_parentPivot$traceEnabled==TRUE) private$p_parentPivot$trace("PivotOpenXlsxStyles$addNamedStyles", "Added named styles.")
    },
    asList = function() {
      lst <- list()
      if(length(private$p_styles) > 0) {
        for (i in 1:length(private$p_styles)) {
          lst[[i]] = private$p_styles[[i]]$asList()
        }
      }
      return(invisible(lst))
    },
    asJSON = function() { return(jsonlite::toJSON(self$asList())) },
    asString = function(seperator=", ") {
      if(private$p_parentPivot$argumentCheckMode > 0) {
        checkArgument(private$p_parentPivot$argumentCheckMode, FALSE, "PivotOpenXlsxStyles", "asString", seperator, missing(seperator), allowMissing=TRUE, allowNull=FALSE, allowedClasses="character")
       }
      cstr <- ""
       if(length(private$p_styles)>0) {
         for(i in 1:length(private$p_styles)) {
           cg <- private$p_styles[[i]]
           sep <- ""
           if(i > 1) { sep <- seperator }
           cstr <- paste0(cstr, sep, cg$asString())
         }
       }
       return(cstr)
    }
  ),
  active = list(
    count = function(value) { return(invisible(length(private$p_styles))) },
    styles = function(value) { return(invisible(private$p_styles)) }
  ),
  private = list(
    p_parentPivot = NULL,
    p_styles = NULL
  )
)