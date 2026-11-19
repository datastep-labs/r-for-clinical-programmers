# Start here: the lab

Welcome. This codespace is a computer in the cloud with R, the book's packages, **DataStep Studio for R** and every
program of the book [R for Clinical Programmers](https://r-for-clinical-programmers.pages.dev/). You work in VS Code,
in your browser. Nothing is installed on your own computer.

Each stop takes a few minutes. Do them in order.

## Stop 0: wait until the setup is done

The first time, the codespace installs the R packages. A terminal at the bottom shows the progress. Wait until it
shows **Ready. Open START-HERE.md.** This takes a few minutes. Later starts of the same codespace are fast.

## Stop 1: check the setup

Open the command palette: `Ctrl+Shift+P` (on a Mac `Cmd+Shift+P`). Type **DataStep R: Check Setup** and press Enter.
Each line says **PASS**, **FIX** or **NOTE**. If a line says FIX, it shows the command that repairs it.

## Stop 2: your first run

1. In the Explorer on the left, open `programs/01_1_first.R`.
2. Press **F4**. F4 runs the selected lines. With nothing selected, it runs the whole file.
3. The **R Console** panel shows the output, and the verdict `RESULT: CLEAN`: no error, no warning.

The table counts the subjects of the CDISC pilot study per arm: 86 on placebo, 84 on each dose of xanomeline, and
52 screen failures.

## Stop 3: look at the data

Press **F12**. The data viewer opens the last data frame that the program made, `adsl`. Click a column header to sort.
Read [chapter 21](https://r-for-clinical-programmers.pages.dev/studio/look-at-data/) for the filters.

## Stop 4: subjects, not records

Open `programs/01_5_subjects.R` and press **F4**. On placebo, 65 subjects had 281 adverse events after the first
dose. A safety table reports the 65. This is the most important rule of clinical tables:
[chapter 1, section 1.5](https://r-for-clinical-programmers.pages.dev/start/tour/#15-count-subjects-not-records).

## Stop 5: change a value, run again

Open `programs/01_6_value_once.R`. Change `"Placebo"` to `"Xanomeline Low Dose"` and press **F4**. The program uses
the value twice, but you changed it in one place.

## Stop 6: a run that is not clean

Open `programs/23_2_copies.R` and press **F4**. The program runs, but the verdict is `RESULT: CHECK`, with
`rows went from 254 to 798 in a join`. A join copied the subjects: the table would say 263 subjects on placebo,
not 86. CHECK means "it ran, but read this first".

## Stop 7: which step lost the records?

Open a terminal (*Terminal*, *New Terminal*) and type:

```sh
dsr pipe programs/23_1_lost.R:9
```

`dsr pipe` shows each step of the pipeline with its rows. One step drops 26 adverse events, because their start
date is partial and `filter()` drops a row whose condition is `NA`, without a word.
[Chapter 23](https://r-for-clinical-programmers.pages.dev/studio/debug-pipeline/) finds and fixes it.

The pipeline tools, the debugger and `pry` are Professional features of DataStep Studio for R. They are free during
Early Access, until 17 February 2027.

## Stop 8: build ADSL

Run the programs of chapter 9 in order: `09_1_domains.R`, then `09_2_suppdm.R`, and on. Each one adds a step of
ADSL, the subject-level data set, from the SDTM data of the study. `09_6_adsl_compare.R` shows that the version by
hand and the version made with the package `admiral` agree.
[Chapter 9](https://r-for-clinical-programmers.pages.dev/adam/adsl/) explains each step.

## Next

Read the book from [chapter 1](https://r-for-clinical-programmers.pages.dev/start/tour/) and run each program here
when you meet it. The programs are named by chapter: `09_1_...` is chapter 9. Run the programs of a chapter in
order: some read the data that an earlier program saved in `programs/data/`.

When you stop working, stop the codespace (the menu at the bottom left, or github.com/codespaces). It keeps your
files for the next time.
