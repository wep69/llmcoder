# Verification Script for install_github() Compatibility
# This script verifies that the llmcoder package meets all requirements for install_github()

cat("============================================\n")
cat("   install_github() Compatibility Check\n") 
cat("============================================\n\n")

# 1. Check essential files exist
essential_files <- c("DESCRIPTION", "NAMESPACE", "LICENSE")
cat("1. Essential files:\n")
for (file in essential_files) {
  exists <- file.exists(file)
  cat(sprintf("   %s %s\n", if(exists) "✓" else "✗", file))
}

# 2. Check directory structure
required_dirs <- c("R", "man", "inst")
cat("\n2. Required directories:\n")
for (dir in required_dirs) {
  exists <- dir.exists(dir)
  cat(sprintf("   %s %s/\n", if(exists) "✓" else "✗", dir))
}

# 3. Check R source files
cat("\n3. R source files:\n")
r_files <- list.files("R", pattern = "\\.R$")
cat(sprintf("   Found %d R files: %s\n", length(r_files), paste(r_files, collapse=", ")))

# 4. Check documentation completeness
cat("\n4. Documentation files:\n")
man_files <- list.files("man", pattern = "\\.Rd$")
cat(sprintf("   Found %d .Rd files: %s\n", length(man_files), paste(man_files, collapse=", ")))

# 5. Check NAMESPACE exports vs man files
cat("\n5. Export/Documentation consistency:\n")
namespace_content <- readLines("NAMESPACE")
exports <- namespace_content[grepl("^export\\(", namespace_content)]
exported_functions <- gsub("export\\((.*)\\)", "\\1", exports)

man_functions <- gsub("\\.Rd$", "", man_files)
missing_docs <- setdiff(exported_functions, man_functions)
extra_docs <- setdiff(man_functions, exported_functions)

if (length(missing_docs) == 0 && length(extra_docs) == 0) {
  cat("   ✓ All exported functions have documentation\n")
} else {
  if (length(missing_docs) > 0) {
    cat("   ✗ Missing documentation:", paste(missing_docs, collapse=", "), "\n")
  }
  if (length(extra_docs) > 0) {
    cat("   ✗ Extra documentation:", paste(extra_docs, collapse=", "), "\n") 
  }
}

# 6. Check RStudio addins
cat("\n6. RStudio integration:\n")
addins_file <- "inst/rstudio/addins.dcf"
if (file.exists(addins_file)) {
  cat("   ✓ RStudio addins file exists\n")
  addins_content <- readLines(addins_file)
  addin_count <- sum(grepl("^Name:", addins_content))
  cat(sprintf("   Found %d addins defined\n", addin_count))
} else {
  cat("   ✗ RStudio addins file missing\n")
}

# 7. Test package build
cat("\n7. Package build test:\n")
build_result <- try({
  system("R CMD build . --quiet", intern = TRUE, ignore.stderr = TRUE)
}, silent = TRUE)

if (inherits(build_result, "try-error")) {
  cat("   ✗ Package build failed\n")
} else {
  tarball <- list.files(".", pattern = "\\.tar\\.gz$")
  if (length(tarball) > 0) {
    cat("   ✓ Package builds successfully\n")
    cat(sprintf("   Created: %s\n", tarball[1]))
    # Clean up
    unlink(tarball)
  } else {
    cat("   ✗ No tarball created\n")
  }
}

cat("\n============================================\n")
cat("   SUMMARY\n")
cat("============================================\n")
cat("The package is ready for install_github() if all\n")
cat("items above show ✓. You can now install with:\n\n")
cat('devtools::install_github("wep69/llmcoder")\n')
cat("============================================\n")