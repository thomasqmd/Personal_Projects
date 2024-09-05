process_file <- \(file, type = ".Rmd") {
  # .Rmd -> .R
  knitr::purl(paste0(file, type))
  # .Rmd -> .pdf & .tex
  rmarkdown::render(paste0(file, type))
  
  zip(zipfile = file,
      files = c(
        paste0(file, "_files"),
        paste0(file, ".R"),
        paste0(file, ".tex"),
        paste0(file, ".pdf")
      ))
}

process_files <- \(files, type = ".Rmd") {
  # files must all be of the same type
  for (f in files) {
    process_file(f, type)
  }
}

lis <- c("Report-1_1", "Report-1_2", "Report-1_3", "Report-1_4")

process_files(lis)
