library(dplyr)
library(ggplot2)
library(tidyr)
library(tidytext)
library(rvest)
library(XML)
library(stringr)
library(ggthemes)
library(pdftools)
library(tm)
library(tidytext)
library(purrr)


directory <- "/Users/benjaminkinsella/Documents/GitHub/Tax-Fraud-and-NLP-Demo/pdfs"


all_pdfs <- list.files(pattern = ".pdf$")


Corpus <- map_df(all_pdfs, ~ data_frame(txt = pdf_text(.x)
  
write.csv(Corpus,'policydocs.csv')         
                 
unnested_words <- map_df(all_pdfs, ~ data_frame(txt = pdf_text(.x)) %>%
                   mutate(filename = .x) %>%
                   unnest_tokens(word, txt))




              
 
         


