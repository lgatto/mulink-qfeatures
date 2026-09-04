library(QFeatures)

convert_date_df <- function(df) {
    for (col in names(df)) {
      x <- df[[col]]

      if (inherits(x, "POSIXt")) {
        df[[col]] <- format(as.POSIXct(x), "%Y-%m-%d %H:%M:%S")
      } else if (inherits(x, "Date")) {
        df[[col]] <- format(x, "%Y-%m-%d")
      }
    }

    df
  }

convert_date_qfeatures <- function(object) {
    colData(object) <- convert_date_df(colData(object))
    for (set in names(object)) {
        colData(object[[set]]) <- convert_date_df(colData(object[[set]]))
        rowData(object[[set]]) <- convert_date_df(rowData(object[[set]]))
    }
    object
}
