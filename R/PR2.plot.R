#' Parity rule 2 (PR2) plot
#'
#' Make a Parity rule 2 (PR2) plot, where the AT-bias [A3/(A3 +T3)] at the third codon position of the four-codon amino acids of entire genes is the ordinate and the GC-bias [G3/(G3 +C3)] is the abscissa. The center of the plot, where both coordinates are 0.5, is where A = U and G = C (PR2), with no bias between the influence of the mutation and selection rates.
#'
#' For more information about PR2 plot \href{https://www.tandfonline.com/doi/full/10.1038/emi.2016.106}{Butt et al., 2016}.
#'
#' @usage PR2.plot(fasta.df)
#'
#' @param fasta.df  a data frame with seq_name and its DNA sequence.
#'
#' @return A ggplot object.
#'
#' @import ggplot2
#'
#' @examples
#' \dontshow{
#' file_path <- system.file("extdata", "sysdata.RData" ,package = "vhcub")
#' load(file = file_path)
#' }
#' \donttest{
#' # read DNA from fasta file
#' fasta <- fasta.read("virus.fasta", "host.fasta")
#' fasta.v <- fasta[[1]]
#' fasta.h <- fasta[[2]]
#' }
#'
#' PR2.plot(fasta.v)
#' 
#' @export
#'
#' @author Ali Mostafa Anwar \email{ali.mo.anwar@std.agr.cu.edu.eg} and Mohmed Soudy \email{MohmedSoudy2009@gmail.com}
#'

  PR2.plot <- function(fasta.df) {
  freq.nt.all <- data.frame()
  length <- 1:length(fasta.df$seq_name)
  for (i_seq in length) {
    sequence <- tolower(as.character(fasta.df$sequence[[i_seq]]))
    seq_name <- as.character(fasta.df$seq_name[[i_seq]])

    freq.nt <- count(s2c(sequence), wordsize = 1, by = 3, start = 2)
    freq.nt <- as.data.frame(freq.nt)
    col.name <- freq.nt$Var1
    freq.nt <- as.data.frame(t(as.data.frame(freq.nt)))
    colnames(freq.nt) <- col.name
    freq.nt <- freq.nt[-c(1), ]
    rownames(freq.nt) <- seq_name
    freq.nt.all <- rbind(freq.nt.all, freq.nt)
  }

  freq.nt.all$a <- as.numeric(freq.nt.all$a)
  freq.nt.all$t <- as.numeric(freq.nt.all$t)
  freq.nt.all$g <- as.numeric(freq.nt.all$g)
  freq.nt.all$c <- as.numeric(freq.nt.all$c)

  A3T3 <- NULL
  G3C3 <- NULL
  freq.nt.all$A3T3 <- freq.nt.all$a / (freq.nt.all$a + freq.nt.all$t)
  freq.nt.all$G3C3 <- freq.nt.all$g / (freq.nt.all$g + freq.nt.all$c)


  plot <- ggplot(freq.nt.all, aes(x = A3T3, y = G3C3)) + geom_point(size = 4) +
    ylab("A3/(A3 + T3)") + xlab("G3/(G3 + C3)") + ylim(0, 1) + xlim(0, 1) + theme_classic(base_size = 20) +
    geom_hline(yintercept = 0.5, color = "red", size = 1.2) + geom_vline(xintercept = 0.5, color = "red", size = 1.2)

  return(plot)
}
