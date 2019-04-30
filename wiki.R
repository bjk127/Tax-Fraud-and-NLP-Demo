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

write.csv(evasion,'wikidocs.csv')  

evasion$text <- as.character(evasion$text)

evasion_words <- evasion %>%
  unnest_tokens(word, text) %>%
  filter(str_detect(word, "[a-z']$"),
         !word %in% stop_words$word)


top_words <- evasion_words %>% 
  count(word, sort=TRUE) %>%
  filter(n > 50)
 
evasion_words %>%
  count(word, sort = TRUE) %>%
  filter(n > 200) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() + ggtitle("Most Common Words in Corpus") + theme_minimal()
 

 
contributions <- evasion_words %>%
  inner_join(get_sentiments("afinn"), by = "word") %>%
  group_by(word) %>%
  summarize(occurences = n(),
            contribution = sum(score))

contributions
 
contributions %>%
  top_n(50, abs(contribution)) %>%
  mutate(word = reorder(word, contribution)) %>%
  ggplot(aes(word, contribution, fill = contribution > 0)) +
  geom_col(show.legend = FALSE) +
  coord_flip() + ggtitle('Words with the most contributions to positive/negative sentiment scores') + theme_minimal()
 

evasion_words %>%
  count(word) %>%
  inner_join(get_sentiments("loughran"), by = "word") %>%
  group_by(sentiment) %>%
  top_n(10, n) %>%
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  coord_flip() +
  facet_wrap(~ sentiment, scales = "free") +
  ggtitle("Frequency of words in corpus by sentiment category") + theme_minimal()


wiki_bigrams <- evasion_words %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2)
evasion_bigram_counts <- wiki_bigrams %>%
  count(bigram, sort = TRUE) %>%
  ungroup() %>%
  separate(bigram, c("word1", "word2"), sep = " ")
  
  


 
negate_words <- c("not", "without", "no", "can't", "don't", "won't")

evasion_bigram_counts %>%
  filter(word1 %in% negate_words) %>%
  count(word1, word2, wt = n, sort = TRUE) %>%
  inner_join(get_sentiments("afinn"), by = c(word2 = "word")) %>%
  mutate(contribution = score * nn) %>%
  group_by(word1) %>%
  top_n(10, abs(contribution)) %>%
  ungroup() %>%
  mutate(word2 = reorder(paste(word2, word1, sep = "__"), contribution)) %>%
  ggplot(aes(word2, contribution, fill = contribution > 0)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ word1, scales = "free", nrow = 3) +
  scale_x_discrete(labels = function(x) gsub("__.+$", "", x)) +
  xlab("Words followed by a negation") +
  ylab("Sentiment score * # of occurrences") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  coord_flip() + ggtitle("Words that contributed the most to sentiment when they followed a ‘negation'") + theme_minimal()



