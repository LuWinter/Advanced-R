

# Load packages -----------------------------------------------------------

library(Rcpp)
library(RMySQL)
library(readxl)
library(stringr)
library(purrr)


# Build string function ---------------------------------------------------

sourceCpp(file = "temp/string_tools.cpp")
rcpp_string_include("万科", "深圳市万科")

is_string_include <- function(v, w) {
    v_vec <- strsplit(v, split = "")[[1]]
    w_vec <- strsplit(w, split = "")[[1]]
    for (char in v_vec) {
        if (!(char %in% w_vec)) {
            return(FALSE)      
        }
    }
    return(TRUE)
}
is_string_include("apple", "banana")
is_string_include("万科", "深圳市万科")

bench::mark(
    baseR = {is_string_include("万科", "深圳市万科企业股份有限公司")},
    Rcpp = {rcpp_string_include("万科", "深圳市万科企业股份有限公司")}
)
microbenchmark::microbenchmark(
    baseR = {is_string_include("盐田港", "深圳市万科企业股份有限公司")},
    Rcpp = {rcpp_string_include("盐田港", "深圳市万科企业股份有限公司")}, 
    times = 10000
)

# Connect MySQL -----------------------------------------------------------

con_mysql <- dbConnect(
  drv = MySQL(),
  host = "localhost",
  dbname = "accounting",
  user = "root",
  password = "shw981120"
)
dbListTables(con_mysql)

audit_info <- dbReadTable(
  conn = con_mysql, 
  name = "listedcompany_auditinformation"
)
head(audit_info)
# dbDisconnect(con_mysql)


# Clean listed company info -----------------------------------------------

listed_basic_info <- read_xlsx(
  path = "F:\\FileRecv\\MobileFile\\STK_LISTEDCOINFOANL.xlsx",
  sheet = 1
)
colnames(listed_basic_info)
sample(listed_basic_info$ShortName, 100)


get_origin_name <- function(old_name) {
  # remove *ST
  temp <- str_remove_all(
    string = old_name, 
    pattern = "^(\\*ST )" # TODO
  )
  # remove last A
  str_remove_all(
    string = temp,
    pattern = "([A-Z])$"
  )
}

short_name_vec <- map_chr(
  .x = listed_basic_info$ShortName,
  .f = get_origin_name
)

map2_lgl(
  .x = short_name_vec[1:50],
  .y = listed_basic_info$FullName[1:50], 
  .f = rcpp_string_include
)


