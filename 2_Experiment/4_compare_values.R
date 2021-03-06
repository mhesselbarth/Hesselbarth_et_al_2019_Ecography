#### 1. Load libraries and source functions #### 
library(dplyr)
library(helpeR) # devtools::install_github("mhesselbarth/helpeR")
library(purrr)
library(readr)

purrr::walk(list.files(path = "1_Setup_Functions", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

# metrics not comparable between landscapes with different area
absolute_metrics <- c("ca", "ndca", "np", "pafrac", "pr", "ta", "tca", "te")

# if of repetition
simulation_design$id <- rep(1:(nrow(simulation_design) / 50), times = 50)

overwrite <- FALSE # dont overwrite if file already exists

#### 1. Low AC ####
sampling_low_ac <- readr::read_rds(path = paste0(getwd(), 
                                                 "/3_Output/sampling_low_ac_50.rds"))

true_value_low_ac <- readr::read_rds(path = paste0(getwd(), 
                                                   "/3_Output/true_value_low_ac_50.rds"))

# remove non-comparable metrics and add unique id
for(i in 1:length(true_value_low_ac)) {
  true_value_low_ac[[i]] <- dplyr::filter(true_value_low_ac[[i]], 
                                          !(metric %in% absolute_metrics))
  
  true_value_low_ac[[i]] <- dplyr::mutate(true_value_low_ac[[i]], layer = i)
}

true_value_low_ac <- dplyr::bind_rows(true_value_low_ac)

# remove non-comparable metrics and add unique ids
for(i in 1:length(sampling_low_ac)) {
  sampling_low_ac[[i]] <-  dplyr::filter(sampling_low_ac[[i]],
                                         !(metric %in% absolute_metrics))

    sampling_low_ac[[i]] <- dplyr::mutate(sampling_low_ac[[i]], 
                                          landscape_id = simulation_design$i[i],
                                          simulation_id = simulation_design$id[i])
}

# join value of whole landscape, calculate sample mean and calculate nRMSE
deviation_low_ac <- bind_rows(sampling_low_ac) %>%
  dplyr::left_join(true_value_low_ac, 
                   by = c("landscape_id" = "layer", 
                          "level" = "level",
                          "class" = "class",
                          "id" = "id",
                          "metric" = "metric"), 
                   suffix = c("_sample", "_true")) %>%
  dplyr::group_by(simulation_id, landscape_id, level, class, metric) %>%
  dplyr::summarise(n = n(),
                   value_true = unique(value_true),
                   estimate = mean(value_sample, na.rm = TRUE),
                   var = var(value_sample, na.rm = TRUE) / (n - 1)) %>% 
  dplyr::mutate(bias = estimate - value_true, 
                mse = var + (bias ^ 2), 
                rmse = sqrt(mse), 
                nrmse = rmse / estimate)

helpeR::save_rds(object = deviation_low_ac, 
                 filename = "deviation_low_ac_50.rds", 
                 path = paste0(getwd(), "/3_Output"),
                 overwrite = overwrite)

# rm(sampling_low_ac, true_value_low_ac)

#### 2. Medium AC ####
sampling_medium_ac <- readr::read_rds(path = paste0(getwd(), 
                                                 "/3_Output/sampling_medium_ac_50.rds"))

true_value_medium_ac <- readr::read_rds(path = paste0(getwd(), 
                                                   "/3_Output/true_value_medium_ac_50.rds"))

# remove non-comparable metrics and add unique id
for(i in 1:length(true_value_medium_ac)) {
  true_value_medium_ac[[i]] <- dplyr::filter(true_value_medium_ac[[i]], 
                                             !(metric %in% absolute_metrics))
  
  true_value_medium_ac[[i]] <- dplyr::mutate(true_value_medium_ac[[i]], layer = i)
}

true_value_medium_ac <- dplyr::bind_rows(true_value_medium_ac)

# remove non-comparable metrics and add unique id
for(i in 1:length(sampling_medium_ac)) {
  sampling_medium_ac[[i]] <- dplyr::filter(sampling_medium_ac[[i]],
                                           !(metric %in% absolute_metrics))
    
  sampling_medium_ac[[i]] <- dplyr::mutate(sampling_medium_ac[[i]], 
                                           landscape_id = simulation_design$i[i],
                                           simulation_id = simulation_design$id[i])

}

# join value of whole landscape, calculate sample mean and calculate nRMSE
deviation_medium_ac <- bind_rows(sampling_medium_ac) %>%
  dplyr::left_join(true_value_medium_ac, 
                   by = c("landscape_id" = "layer", 
                          "level" = "level",
                          "class" = "class",
                          "id" = "id",
                          "metric" = "metric"), 
                   suffix = c("_sample", "_true")) %>%
  dplyr::group_by(simulation_id, landscape_id, level, class, metric) %>%
  dplyr::summarise(n = n(),
                   value_true = unique(value_true),
                   estimate = mean(value_sample, na.rm = TRUE),
                   var = var(value_sample, na.rm = TRUE) / (n - 1)) %>% 
  dplyr::mutate(bias = estimate - value_true, 
                mse = var + (bias ^ 2), 
                rmse = sqrt(mse), 
                nrmse = rmse / estimate)

helpeR::save_rds(object = deviation_medium_ac, 
                 filename = "deviation_medium_ac_50.rds", 
                 path = paste0(getwd(), "/3_Output"),
                 overwrite = overwrite)

# rm(sampling_medium_ac, true_value_medium_ac)

#### 3. High AC ####
sampling_high_ac <- readr::read_rds(path = paste0(getwd(), 
                                                 "/3_Output/sampling_high_ac_50.rds"))

true_value_high_ac <- readr::read_rds(path = paste0(getwd(), 
                                                   "/3_Output/true_value_high_ac_50.rds"))

# remove non-comparable metrics and add unique id
for(i in 1:length(true_value_high_ac)) {
  true_value_high_ac[[i]] <- dplyr::filter(true_value_high_ac[[i]],
                                           !(metric %in% absolute_metrics))
  
  true_value_high_ac[[i]] <- dplyr::mutate(true_value_high_ac[[i]], layer = i)
}

true_value_high_ac <- dplyr::bind_rows(true_value_high_ac)

# remove non-comparable metrics and add unique id
for(i in 1:length(sampling_high_ac)) {
  sampling_high_ac[[i]] <- dplyr::filter(sampling_high_ac[[i]],
                                         !(metric %in% absolute_metrics))
    
  sampling_high_ac[[i]] <- dplyr::mutate(sampling_high_ac[[i]], 
                                         landscape_id = simulation_design$i[i],
                                         simulation_id = simulation_design$id[i])
}

# join value of whole landscape, calculate sample mean and calculate nRMSE
deviation_high_ac <- bind_rows(sampling_high_ac) %>%
  dplyr::left_join(true_value_high_ac, 
                   by = c("landscape_id" = "layer", 
                          "level" = "level",
                          "class" = "class",
                          "id" = "id",
                          "metric" = "metric"), 
                   suffix = c("_sample", "_true")) %>%
  dplyr::group_by(simulation_id, landscape_id, level, class, metric) %>%
  dplyr::summarise(n = n(),
                   value_true = unique(value_true),
                   estimate = mean(value_sample, na.rm = TRUE),
                   var = var(value_sample, na.rm = TRUE) / (n - 1)) %>% 
  dplyr::mutate(bias = estimate - value_true, 
                mse = var + (bias ^ 2), 
                rmse = sqrt(mse), 
                nrmse = rmse / estimate)

helpeR::save_rds(object = deviation_high_ac, 
                 filename = "deviation_high_ac_50.rds", 
                 path = paste0(getwd(), "/3_Output"),
                 overwrite = overwrite)

# rm(sampling_high_ac, true_value_high_ac)
