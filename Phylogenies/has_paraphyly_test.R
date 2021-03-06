source("~/GitHubs/R/Phylogenies/has_paraphyly.R")
source("~/GitHubs/R/Phylogenies/get_correct_test_newicks.R")
source("~/GitHubs/R/Phylogenies/convert_newick_to_phylogeny.R")
source("~/GitHubs/R/Phylogenies/get_correct_paraphyletic_test_newicks.R")
source("~/GitHubs/R/Phylogenies/strip_subspecies_label_from_tip_labels.R")

has_paraphyly_test <- function() {

  phylogeny <- read.tree(text="(A:2.0,(B:1.0,C:1.0):1.0):1.0;")
  #
  #      +------- C
  #      |
  #  +---+
  #  |   |
  # -+   +------- B
  #  |
  #  |
  #  |
  #  +----------- A
  #
  plot(phylogeny,show.node.label=TRUE,root.edge = TRUE)
  nodelabels( , col = "black", bg = "gray")
  assert(!has_paraphyly(phylogeny))

  phylogeny <- read.tree(text="(A:2.0,(B:1.0,A:1.0):1.0):1.0;")
  #
  #      +------- A
  #      |
  #  +---+
  #  |   |
  # -+   +------- B
  #  |
  #  |
  #  |
  #  +----------- A
  #
  plot(phylogeny,show.node.label=TRUE,root.edge = TRUE)
  nodelabels( , col = "black", bg = "gray")
  assert(has_paraphyly(phylogeny))
  
  for (monophyletic_newick in get_correct_test_newicks()) {
    monophyletic_phylogeny <- convert_newick_to_phylogeny(monophyletic_newick)
    plot(monophyletic_phylogeny,show.node.label=TRUE,root.edge = TRUE)
    nodelabels( , col = "black", bg = "gray")
    assert(!has_paraphyly(monophyletic_phylogeny))
  }

  for (paraphyletic_newick in get_correct_paraphyletic_test_newicks()) {
    paraphyletic_phylogeny <- convert_newick_to_phylogeny(paraphyletic_newick)
    paraphyletic_phylogeny$tip.label <- strip_subspecies_label_from_tip_labels(paraphyletic_phylogeny$tip.label)
    plot(paraphyletic_phylogeny,show.node.label=TRUE,root.edge = TRUE)
    nodelabels( , col = "black", bg = "gray")
    assert(has_paraphyly(paraphyletic_phylogeny))
  }
}

has_paraphyly_test()