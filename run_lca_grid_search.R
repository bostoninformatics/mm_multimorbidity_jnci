library(parallel)
library(poLCA)

run_lca_grid_search <- function(ccw_tb, nclasses_grid = 4:7, num_reps = 500, mc.cores = 24) {
  # Determine condition names.
  ccw_condition_names = colnames(ccw_tb)
  ccw_condition_names = ccw_condition_names[!(ccw_condition_names %in% c("PatientICN", "IndexDate"))]

  # Define LCA formula.
  lca_formula = as.formula(sprintf("cbind(%s) ~ 1", paste(sprintf("%s", ccw_condition_names), collapse=", ")))

  # Convert condition data to integers coded as 1/2 instead of 0/1.
  ccw_12 = ccw_tb
  for (n in ccw_condition_names) {
    ccw_12[[n]] = as.integer(ccw_12[[n]]) + 1
  }

  # Make the final LCA input table and doublecheck that each row corresponds to
  # a unique patient.
  input_tb = ccw_12
  stopifnot(nrow(input_tb) == length(unique(input_tb$PatientICN)))

  # Define how to run LCA grid search.
  # #nclasses_grid = 2:7
  # #nclasses_grid = 6:10
  # #nclasses_grid = 2:12
  # nclasses_grid = 4:7
  # num_reps = 500
  # #num_reps = 50
  grid_search_preinput_tb = data_frame(nclass = nclasses_grid)
  grid_search_input_tb = bind_rows(lapply(1:num_reps, function(rep) {
    grid_search_preinput_tb %>% mutate(rep = rep)
  }))

  # Carry out LCA grid search.
  lca_results = mclapply(1:nrow(grid_search_input_tb), function(i) {
    nclass = grid_search_input_tb$nclass[[i]]
    rep = grid_search_input_tb$rep[[i]]
    set.seed(1234+i)
    poLCA(lca_formula, input_tb, nclass=nclass, graphs=FALSE, nrep=1, maxiter=10000)
  }, mc.cores = mc.cores)

  # Collate data to select the best number of classes.
  bics_tb = grid_search_input_tb
  bics_tb$aic = sapply(lca_results, function(x) x$aic)
  bics_tb$bic = sapply(lca_results, function(x) x$bic)
  bics_tb$neg_llik = -sapply(lca_results, function(x) x$llik)
  bics_tb$Gsq = sapply(lca_results, function(x) x$Gsq)
  bics_tb$Chisq = sapply(lca_results, function(x) x$Chisq)
  bics_tb$index = 1:nrow(bics_tb)

  # Select the best (minimizing) fit for each number of classes and each criterion.
  best_lca_map = list()
  best_lca_fits = list()
  for (cr in c("aic", "bic", "neg_llik", "Gsq", "Chisq")) {
    crit = rlang::sym(cr)
    best_lca_map[[cr]] = bics_tb %>% group_by(nclass) %>% arrange(!!crit) %>% slice(1) %>% arrange(nclass)
    best_lca_fits[[cr]] = lapply(best_lca_map[[cr]]$index, function(i) lca_results[[i]])
  }

  list(bics_tb = bics_tb,
       best_lca_map = best_lca_map,
       best_lca_fits = best_lca_fits)
}
