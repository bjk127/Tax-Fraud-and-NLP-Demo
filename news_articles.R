library(dplyr)
library(ggplot2)
library(tidyr)
library(tidytext)
library(rvest)
library(XML)
library(stringr)
library(ggthemes)


urls <- c('https://www.nytimes.com/2012/10/27/world/europe/berlusconi-convicted-and-sentenced-in-tax-fraud.html?searchResultPosition=2',
          'https://www.nytimes.com/2016/06/06/us/panama-papers.html?hp=&action=click&pgtype=Homepage&clickSource=story-heading&module=inline&region=top-news&WT.nav=top-news&_r=0&login=email&auth=login-email',
          'https://www.nytimes.com/2016/06/07/opinion/panama-papers-point-to-tax-evasion.html?searchResultPosition=3',
          'https://www.nytimes.com/2016/04/04/us/politics/leaked-documents-offshore-accounts-putin.html?module=inline',
          '',
          '',
          '',
          '',
          '',
          '',
          )


nyt_urls <- lapply(urls, function(x) read_html(x) %>% html_text())


evasion <- do.call(rbind, Map(data.frame, text= wiki_urls))
evasion$text <- as.character(evasion$text)

evasion_words <- evasion %>%
  unnest_tokens(word, text) %>%
  filter(str_detect(word, "[a-z']$"),
         !word %in% stop_words$word)