#' @title get Shortgrass Steppe rodent data
#' 
#' Import Shortgrass Steppe rodent abundance from data files
#' 
#' @return list of two dataframes (one with abundance data, the other with 
#'   covariate data) and one list of metadata.
#'
#' @export
get_sgs_data <- function()
{
    
    # read in Shortgrass Steppe rodent data
    data_path <- system.file("extdata", "shortgrass_steppe_rodents.csv", 
                             package = "MATSS", mustWork = TRUE)
    sgs_data <- read.csv(data_path)
    
    # select key columns 
    # filter out unknown species and recaptures
    sgs_data <- dplyr::select(sgs_data, SESSION, YEAR, VEG, WEB, SPP) %>% 
        dplyr::filter(SPP != 'NA')
    
    # get data into wide format
    # summarize counts for each species in each period
    sgs_abundances <- sgs_data %>%
        dplyr::group_by(YEAR, SESSION, SPP) %>%
        dplyr::summarize(count = n())
    
    # put data in wide format
    sgs_abundance_table <- sgs_abundances %>%
        tidyr::spread(SPP, count, fill = 0)

    season <- rep(0, nrow(sgs_abundance_table))
    season[grepl("Sep", sgs_abundance_table$SESSION)] <- 0.5
    sgs_abundance_table$samples <- sgs_abundance_table$YEAR + season
    
    # split into two dataframes and save
    covariates <- sgs_abundance_table[,c("YEAR", "SESSION", "samples")]
    abundance <- sgs_abundance_table[,-which(colnames(sgs_abundance_table) %in% c("YEAR", "SESSION", "samples"))]

    metadata <- list(timename = "samples", effort = NULL)
    return(mget(c("abundance", "covariates", "metadata")))
}