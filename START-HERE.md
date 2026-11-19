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

## Next

Read the book from [chapter 1](https://r-for-clinical-programmers.pages.dev/start/tour/) and run each program here
when you meet it. The programs are named by chapter: `09_1_...` is chapter 9.

When you stop working, stop the codespace (the menu at the bottom left, or github.com/codespaces). It keeps your
files for the next time.
