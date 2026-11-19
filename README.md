# R for Clinical Programmers: the lab

Learn clinical R programming in your browser, with the programs of the free book
[R for Clinical Programmers](https://r-for-clinical-programmers.pages.dev/) and **DataStep Studio for R**: run a
program and read its verdict, look at the CDISC pilot study in the data viewer, and see which step of a pipeline
loses a subject.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/datastep-labs/r-for-clinical-programmers?quickstart=1)

1. Click the button and sign in to GitHub (a free account is enough).
2. Wait a few minutes the first time: the codespace installs R's packages. VS Code opens in your browser with
   DataStep Studio for R, the book's programs and the lab [START-HERE.md](START-HERE.md).
3. Follow the lab.

You install nothing on your computer, and you need no other account: R and every package are free. Each free GitHub
account includes a monthly amount of codespace time, and without a payment method you are never charged.

## What is in here

| Folder or file | What |
|---|---|
| [START-HERE.md](START-HERE.md) | The lab: short stops, about 30 minutes |
| [programs/](programs/) | Every program of the book, named by chapter (`09_1_domains.R` is chapter 9) |
| `renv.lock` | The book's R packages, each with its exact version |
| `.devcontainer/` | The setup of the codespace: R 4.4, Node.js, the packages and DataStep Studio for R |

The study data comes inside the R packages `pharmaversesdtm` and `pharmaverseadam` (Apache License 2.0): the
CDISC pilot study, with no file to download.

## On your own computer

Install R, [VS Code](https://code.visualstudio.com/) and the extension **DataStep Studio for R**, download this
repository (**Code**, **Download ZIP**), open the folder and run `Rscript -e 'renv::restore(prompt = FALSE)'`. The
book's [setup chapter](https://r-for-clinical-programmers.pages.dev/start/setup/) explains each step.

---

© 2026 DataStep Labs. All rights reserved. R is a project of the R Foundation. SAS is a registered trademark of SAS
Institute Inc. CDISC, SDTM and ADaM are trademarks of the Clinical Data Interchange Standards Consortium. This lab
is not affiliated with or endorsed by SAS Institute Inc. or the R Foundation.
