library(dplyr)
library(ggplot2)
library(tidyr)
library(tidytext)
library(rvest)
library(XML)
library(stringr)
library(ggthemes)
library(pdftools)

urls <- c('')

nyt_urls <- lapply(urls, function(x) read_html(x) %>% html_text())


evasion <- do.call(rbind, Map(data.frame, text= wiki_urls))
evasion$text <- as.character(evasion$text)

evasion_words <- evasion %>%
  unnest_tokens(word, text) %>%
  filter(str_detect(word, "[a-z']$"),
         !word %in% stop_words$word)