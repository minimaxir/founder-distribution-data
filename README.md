founder-distribution-data
=========================

Code and methodology for reproducing Gender Founder data. Saves a CSV of all founders possible which received funding from the specified venture capital firm. (Also saves a bonus CSV of the male and female counts by year.)

Code works as follows:

1. Uses the data of all investments in startups from the [November Export of CrunchBase data](http://info.crunchbase.com/about/crunchbase-data-exports/).

2. Filter on investments made by user-specified firm (e.g. Y Combinator)
 
3. For each startup, query CrunchBase for employees from that  startup. For each employee, if they hold the title of "Founder," add that employee to the list.

4. For each Founder, guess the Gender of the founder by comparing the First Name of the founder against Carnegie Mellon university's list of common [male](http://www.cs.cmu.edu/afs/cs/project/ai-repository/ai/areas/nlp/corpora/names/male.txt) and [female](http://www.cs.cmu.edu/afs/cs/project/ai-repository/ai/areas/nlp/corpora/names/female.txt) names used for NLP. If no guess, manually find the gender of the founder later.

5. Remove duplicate founder entries if more than one investment for that founder in a year (extremely rare).

Final processed data available at [this Google Spreadsheet](https://docs.google.com/spreadsheet/ccc?key=0AjPFdCURhZvddHF0ZTNxbG9GNjVWNTZjWm91c2xJekE&usp=sharing) (manual changes are bolded.)


