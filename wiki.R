library(dplyr)
library(ggplot2)
library(tidyr)
library(tidytext)
library(rvest)
library(XML)
library(stringr)
library(ggthemes)
library(pdftools)



html_urls <- c('https://en.wikipedia.org/wiki/Tax_avoidance',
               'https://en.wikipedia.org/wiki/Tax_shelter',
               'https://en.wikipedia.org/wiki/Tax_haven',
               'https://en.wikipedia.org/wiki/Offshore_financial_centre',
               'https://en.wikipedia.org/wiki/Tax_residence',
               'https://en.wikipedia.org/wiki/Panama_Papers',
               'https://en.wikipedia.org/wiki/Money_laundering',
               'https://en.wikipedia.org/wiki/Suspicious_activity_report',
               'https://en.wikipedia.org/wiki/Financial_Action_Task_Force_on_Money_Laundering',
               'https://en.wikipedia.org/wiki/Bank_of_Credit_and_Commerce_International',
               'https://en.wikipedia.org/wiki/Paradise_Papers',
               'https://en.wikipedia.org/wiki/Bahamas_Leaks',
               'https://en.wikipedia.org/wiki/Operation_Car_Wash')

 wiki_urls <- lapply(html_urls, function(x) read_html(x) %>% html_text())
 
 
evasion <- do.call(rbind, Map(data.frame, text= wiki_urls))
evasion$text <- as.character(evasion$text)

evasion_words <- evasion %>%
  unnest_tokens(word, text) %>%
  filter(str_detect(word, "[a-z']$"),
         !word %in% stop_words$word)


evasion_words %>% 
  count(word, sort=TRUE)
 
evasion_words %>%
  count(word, sort = TRUE) %>%
  filter(n > 200) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() + ggtitle("The Most Common Words in Corpus") + theme_minimal()
 

 
contributions <- evasion_words %>%
  inner_join(get_sentiments("afinn"), by = "word") %>%
  group_by(word) %>%
  summarize(occurences = n(),
            contribution = sum(score))

contributions
 
contributions %>%
  top_n(25, abs(contribution)) %>%
  mutate(word = reorder(word, contribution)) %>%
  ggplot(aes(word, contribution, fill = contribution > 0)) +
  geom_col(show.legend = FALSE) +
  coord_flip() + ggtitle('Words with the Most Contributions to Positive/Negative Sentiment Scores') + theme_minimal()
 

evasion_words %>%
  count(word) %>%
  inner_join(get_sentiments("loughran"), by = "word") %>%
  group_by(sentiment) %>%
  top_n(5, n) %>%
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  coord_flip() +
  facet_wrap(~ sentiment, scales = "free") +
  ggtitle("Frequency of This Word in Buffett's Letters") + theme_minimal()


letters_bigrams <- letters %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2)
letters_bigram_counts <- letters_bigrams %>%
  count(year, bigram, sort = TRUE) %>%
  ungroup() %>%
  separate(bigram, c("word1", "word2"), sep = " ")
 
