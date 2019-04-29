# Tax Fraud and NLP Demo

(Pertinent NLP techniques with the goal of creating a tax fraud ontology.)

## Introduction 



## Sample data bases
For purposes of this demo, I'll create a sample of three data sets using a corpus of (1) relevant policy and research documents from the World Bank Group and OECD; (2) Wikipedia articles pertaining to tax fraud; and (3) the ICIJ Offshore database. 

## Policy and Research Papers on tax fraud

First, a corpus of relevant policy and research papers on tax fraud could be used to generate a tax fraud ontology. 

```
directory <- "/Users/benjaminkinsella/Documents/GitHub/Tax-Fraud-and-NLP-Demo/pdfs"


all_pdfs <- list.files(pattern = ".pdf$")

Corpus <- map_df(all_pdfs, ~ data_frame(txt = pdf_text(.x)) %>%
         mutate(filename = .x) %>%
         unnest_tokens(word, txt))

```

## Wikipedia Articles

In addition to relevant policy and research papers, a corpus could be formed using web articles, such as the news, Wikipedia pages with key words (e.g., tax fraud, anti-corruption). While web-scraping techniques and news APIs are able to rapidly search and mine articles  

1) Tax Avoidance - https://en.wikipedia.org/wiki/Tax_avoidance
2) Tax Shelters - https://en.wikipedia.org/wiki/Tax_shelter
3) Tax Havens - https://en.wikipedia.org/wiki/Tax_haven
4) Offshore Financial Centers - https://en.wikipedia.org/wiki/Offshore_financial_centre
5) Tax Residence - https://en.wikipedia.org/wiki/Tax_residence
6) Panama Papers https://en.wikipedia.org/wiki/Panama_Papers
7) Money Laundering https://en.wikipedia.org/wiki/Money_laundering
8)Suspicious Activity Reports - https://en.wikipedia.org/wiki/Suspicious_activity_report
9) Financial Action task Force - https://en.wikipedia.org/wiki/Financial_Action_Task_Force_on_Money_Laundering
10)Bank of Credit and Commercial International - https://en.wikipedia.org/wiki/Bank_of_Credit_and_Commerce_International
11)Paradise Papers - https://en.wikipedia.org/wiki/Paradise_Papers
12)Bahamas Leak - https://en.wikipedia.org/wiki/Bahamas_Leaks
13)Operation Car Wash https://en.wikipedia.org/wiki/Operation_Car_Wash'



## The Panama Papers Database

The third sample data set comes from the  ”ICIJ  Offshore”  database,  which presents  the  network  of  relationships  between  companies  and  individual  people  with  offshore  companies based in tax havens. These documents pertain to the Panama Papers, which are a set of 11.5 million document leaks from Panamanian law company ”Mossack Fonseca”. The documents provide information on approximately 360,000 businesses and individuals in more than 200 countries linked to offshore structures and covering a time period of nearly 40 years, from 1977 to 2016.

More can be found at the following link: https://www.occrp.org/en/panamapapers/database

 These documents consists in a directed and unweighted network based on commercial  registration  of  all  types  of  companies  involved  in  the  scandal  and the existing relations type, which are:

| **Text** | ** Meaning In Document**       |
| ------------- |:-------------:|
|"director of”| Refers to the person appointed to the company’s management.|
|”address” | Refers to the address through which was possible to establish the country origin of the company.|
|”shareholder of” | If it holds a stake in an offshore company.|
|”intermediary of” | If it mediates companies in access to offshores.|
| ”similar of” | If the company is related to another company, among other attributes.|

# How The Data Is Structured:
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


