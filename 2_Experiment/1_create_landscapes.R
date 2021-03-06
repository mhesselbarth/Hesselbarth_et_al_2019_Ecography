#### 1. Load libraries and source functions #### 
library(clustermq)
library(helpeR) # devtools::install_github("mhesselbarth/helpeR")
library(landscapetools)
library(NLMR)
library(purrr)

purrr::walk(list.files(path = "1_Setup_Functions", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

#### 2. Create landscapes ####  

# Landscapes are created using a high performance cluster 

# Low AC
landscapes_low_ac <- clustermq::Q(fun = simulate_landscapes, 
                                  user_seed = simulation_run,
                                  const = list(ac = "low"),
                                  n_jobs = length(simulation_run),
                                  template = list(queue = "mpi-short", 
                                                  walltime = "02:00", 
                                                  processes = 1))

# Medium AC
landscapes_medium_ac <- clustermq::Q(fun = simulate_landscapes, 
                                     user_seed = simulation_run,
                                     const = list(ac = "medium"),
                                     n_jobs = length(simulation_run),
                                     template = list(queue = "mpi-short", 
                                                     walltime = "02:00", 
                                                     processes = 1))

# High AC
landscapes_high_ac <- clustermq::Q(fun = simulate_landscapes, 
                                   user_seed = simulation_run,
                                   const = list(ac = "high"),
                                   n_jobs = length(simulation_run),
                                   template = list(queue = "mpi-short", 
                                                   walltime = "02:00", 
                                                   processes = 1))

#### 3. Save landscapes ####

overwrite <- FALSE # dont overwrite if file already exists

# Low AC
helpeR::save_rds(object = landscapes_low_ac, 
                 filename = "landscapes_low_ac.rds", 
                 path = paste0(getwd(), "/3_Output"),
                 overwrite = overwrite)

# Medium AC
helpeR::save_rds(object = landscapes_medium_ac, 
                 filename = "landscapes_medium_ac.rds", 
                 path = paste0(getwd(), "/3_Output"),
                 overwrite = overwrite)

# High AC
helpeR::save_rds(object = landscapes_high_ac, 
                 filename = "landscapes_high_ac.rds", 
                 path = paste0(getwd(), "/3_Output"),
                 overwrite = overwrite)
