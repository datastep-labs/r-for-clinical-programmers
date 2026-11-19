# EXPECT: ERROR Column
# Chapter 19: a wrong call stops at step 010, with a message that says what to fix
pkgload::load_all("studylib", quiet = TRUE)

adae <- pharmaverseadam::adae
count_subj(adae, TRT01A, id = "SUBJECT")
