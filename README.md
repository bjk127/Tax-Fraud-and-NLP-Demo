# Tax Fraud and NLP Demo


## Introduction 
This document delineates several ways in which information extraction can be used on corpora with the goal of creating political event ontologies. The link to the presentation will be [here](). The outline will be as follows:

- Introduction to NLP 
- Named Entity Recognition (NER)
- Event ontologies
- Applicability of deep neural networks on text
- Sample datasets


## Natural Language Processing
* NLP is an interdisciplinary field that analyzes language-based data (e.g., medical records, social media, legal documents, news articles, etc.). A suite of techniques can be used to generate findings.
* Supervised and unsupervised learning are widely used. Examples include:
    * Sentiment analysis
    * Machine translation
    * Part-of-speech tagging
    * Chunking
    * Information Extraction


## Information Extraction

A common NLP technique to extract semantic content from text is *information extraction (IE)*, the process that turns unstructured information embedded in text into structure data. As a first step, we may want to find proper names - that is, *named entities* in a text, such as people, places, and organizations (Cohen and Demner-Fushman, 2014). A first step to IE is Named Entity Recognition (NER).

*	NER finds named entities (e.g., person, location, organization, temporal expressions, etc.). 
    * Supervised relation extraction - Choosing a fixed set of entities and relations, taking hand-annotated corpus and training classifiers to annotate unseen test set).
    * Semi-supervised - Taking a few high-precision patterns and using a bootstrap classifier.
    * Unsupervised relation extraction - Extracting relations from the web when we have no labeled training data.

* Possible uses of NER:
    * Identifying mentions of tax fraud events and their times
    * Finding relations among entities, such as businesses/people, and temporal expressions



## Event Ontologies

* Encompasses a representation, formal naming, and definition of categories, properties and relations between entities. 
* Example --> How can NLP automatically tag political relevant event data? How do these insights inform stakeholders and create a hierarchy of labels used to understand events?
    * Training texts follow Conflict and Meditation Event Observations (CAMEO) coding ontology using 200 event classifications (e.g., Gerner et al., 2001); Schrodt (2006) divided ontology into lower-resolution categories called QuadClasss
    * Consists of verb phrases(VPs) and noun phrases (NPs)  to code actions and actors.


![alt text](https://github.com/bjk127/Tax-Fraud-and-NLP-Demo/blob/master/img/QuadClass%20Events.png)
(source: QuadClasses, Schrodt, 2006)

### CAMEO Example, Beieler (2016)
* Demonstrated modern approaches to NLP and deep neural networks that extract politically relevant events.
* Methods are able to be used across ontologies and languages (e.g., Spanish, Chinese, etc.).
* Example of how NLP and deep learning can automatically classify events according to ontology

#### About the study
* Current state-of-the-art for CAMEO event extraction is presented by the [PETRARCH2 coder](https://github.com/openeventdata/petrarch2)
    * These approaches use parser-based methods, relying on human-created dictionaries.
* Beieler (2016) replaced parser-based methods to instead use convolutional neural nets to identify events according to QuadClass variables (i.e., Conflict, Material Cooperation, Verbal Conflict, Verbal Cooperation)
* Two neural architectures were used to classify a political event: 
    * (1) Pre-trained word embeddings (Kim, 2014); and (2) characters (Zhang et al., 2015) to automatically detect events and relationships.

* Data:
    * Soft-labelled English - English corpus consisted of data scraped from online news media sites.
    * Soft-labelled ARabic - Arabic corpus was derived from a sentence-aligned [English/Arabic corpus](https://www.ldc.upenn.edu/collaborations/past-projects/gale/data/gale-pubs).
    * Machine-translated Arabic - Same set of labelled Arabic sentences that were run through machine-translation software (Weese et al., 2011). 

* Results: 
    * Character model was shown to be over 






## Areas of opportunity: Deep neural networks




## Sample databases 
For purposes of this demo, I've mined three data sets using a corpus of:
* (1) relevant policy and research documents from the World Bank Group and OECD; 
* (2) Wikipedia articles pertaining to tax fraud; and 
* (3) the ICIJ Offshore database. 

### 1) Policy and Research Papers on tax fraud

First, a corpus of relevant policy and research papers on tax fraud could be used to generate a tax fraud ontology. A collection of [12 policy and research papers](https://github.com/bjk127/Tax-Fraud-and-NLP-Demo/tree/master/pdfs) were downloaded and merged together. 

```
directory <- "~/Documents/GitHub/Tax-Fraud-and-NLP-Demo/pdfs"


all_pdfs <- list.files(pattern = ".pdf$")

Corpus <- map_df(all_pdfs, ~ data_frame(txt = pdf_text(.x)) %>%
         mutate(filename = .x) %>%
         unnest_tokens(word, txt))

```

For further details, the link to the code can be found [here](https://github.com/bjk127/Tax-Fraud-and-NLP-Demo/blob/master/policy_research.R)

### 2) Wikipedia Articles

Furthermore, consider a corpus formed using web articles, such as the news, Wikipedia pages with key words (e.g., tax fraud, anti-corruption). While web-scraping techniques and news APIs are able to rapidly search and mine numerous numbers of articles, I create a small corpus of 13 pertinent Wikipedia pages on tax fraud, saved as `html_urls`. These links and code can be found [here](https://github.com/bjk127/Tax-Fraud-and-NLP-Demo/blob/master/wiki.R)

```
 wiki_urls <- lapply(html_urls, function(x) read_html(x) %>% html_text())
 
 
evasion <- do.call(rbind, Map(data.frame, text= wiki_urls))
evasion$text <- as.character(evasion$text)

evasion_words <- evasion %>%
  unnest_tokens(word, text) %>%
  filter(str_detect(word, "[a-z']$"),
         !word %in% stop_words$word)
```

### 3) The Panama Papers Database

The third sample data set comes from the  ”ICIJ  Offshore”  database,  which presents  the  network  of  relationships  between  companies  and  individual  people  with  offshore  companies based in tax havens. These documents pertain to the Panama Papers, which are a set of 11.5 million document leaks from Panamanian law company ”Mossack Fonseca”. The documents provide information on approximately 360,000 businesses and individuals in more than 200 countries linked to offshore structures and covering a time period of nearly 40 years, from 1977 to 2016.

More can be found at the following link: https://www.occrp.org/en/panamapapers/database


## Analyzing the corpora


## Research papers



## Wiki corpus

## ICIJ Panama Papers 

 These documents are comprised of a directed and unweighted network based on the commercial  registration  of  all  types  of  companies  involved  in  the  scandal  and the existing relations type, which are:

| **Text** | ** Meaning In Document**       |
| ------------- |:-------------:|
|"director of”| Refers to the person appointed to the company’s management.|
|”address” | Refers to the address through which was possible to establish the country origin of the company.|
|”shareholder of” | If it holds a stake in an offshore company.|
|”intermediary of” | If it mediates companies in access to offshores.|
| ”similar of” | If the company is related to another company, among other attributes.|

## How the  Is Structured:
Below is a break down between the different roles of Entity, Officer, and Intermediary.

![](img/shapeofthedata.png)
(source:https://guides.neo4j.com/sandbox/icij-paradise-papers/datashape.html)

When interpreting the graph, it will be important to understand the obligation that each person or person(s) has within the network.  

* **Entity** (offshore)
<br /> Company, trust or fund created in a low-tax, offshore jurisdiction by an agent.

* **Officer**
<br /> Person or company who plays a role in an offshore entity.

* **Intermediary**
<br /> A go-between for someone seeking an offshore corporation
  and an offshore service provider - usually a law-firm or a middleman that asks an offshore service provider to create an offshore firm for a client.

* **Address**
<br /> A contact postal address as it appears in the original databases
  obtained by ICIJ.

# Global Breakdown Of The Entire Panama Paper Corpus

The following table breaks down the file structure of the entire corpus of documents provided by the ICIJ. 


| Name          | Type          | Purpose | # of rows | Columns of interest |
| ------------- |:-------------:| -------:|----------:|------------:|
|  panama_papers_edges.csv    |    Edge       |   Each edge has a type of the represented relationship | 1,269,796    |   START_ID, TYPE, END_ID      |
| panama_papers_addresses.csv |    Nodes      |   Legal addresses of officers and entities  |   151,127  |      n/a   |
| panama_papers_entity.csv  |    Nodes      |   Legal entities (corporations, firms, and so on) |   319,421   |     name, jurisdiction    |
| panama_papers_intermediary.csv|    Nodes      |  Persons and organizations that act as links between other organizations| 23,642 |  name, country_code  |
| panama_papers_officer.csv  |    Nodes      | Persons (directors, shareholders, and so on)| 345,645 | name, country_code |


## References

Cohen and Demner-Fushman, 2014