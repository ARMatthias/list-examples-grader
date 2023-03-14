#!/bin/bash
#
# grades a student submission ListExamples.java using an input github link to the submission repositiory.
#
# Name: Rae Matthias
# Email: amatthias@ucsd.edu
# PID: A17495586

# classpath config depending on operating system
if [[ $OSTYPE == "linux-gnu" ]] 
    then
        CPATH=".:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar"
elif [[ $OSTYPE == "msys" ]] 
    then
        CPATH=".;lib/junit-4.13.2.jar;lib/hamcrest-core-1.3.jar"
fi

# clear previous submission
rm -rf student-submission
truncate -s 0 gradeReports/*.txt
if [[ -e ListExamples.java ]]
    # if exists, remove previous ListExamples.java
    then 
        rm ListExamples.java
fi

# retrieve student submission
git clone $1 student-submission

# check if ListExamples.java is in student submission
if [[ -e student-submission/ListExamples.java ]]
    # if exists, print found, copy student submission out
    then
        echo "ListExamples.java found"
        cp student-submission/ListExamples.java ./
else
    SUBPATH=$(find student-submission | grep "ListExamples.java")
    # if ListExamples.java is nested
    if [[ -e $SUBPATH ]]
        then
            GP=$(pwd)
            cp $SUBPATH $GP
    else
    # if not, print error, exit
    echo "Error: File ListExamples.java not found"
    exit 1
    fi
fi

# compile and check if compilation is successful
javac -cp $CPATH *.java 2> gradeReports/javac-errs.txt
if [[ $? -ne 0 ]] 
    # if unsuccessful, print standard error, exit
    then 
        echo "Error: failure during compilation"
        echo "Compilation feedback:"
        cat gradeReports/javac-errs.txt 
        exit 1
fi

# run and record outputs to corresponding files
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples 2> gradeReports/run-err.txt 1> gradeReports/jUnit-out.txt
OUT=$(cat gradeReports/run-err.txt)

# check for successful runtime
if [[ $? -ne 0 ]]
    # if unsuccessful, print standard error, exit
    then
        echo "Error: failure during runtinme"
        echo $OUT
        exit 1
else
    #if successful, grade based off of total passed tests of TestListExamples.java
    if grep -q "FAILURES" gradeReports/jUnit-out.txt;
        then 
            cat gradeReports/jUnit-out.txt

            ERROUT=$(grep 'Tests run' gradeReports/jUnit-out.txt)

            IFS=", " read -a SCORES <<< $ERROUT

            FAILED="${SCORES[4]}"
            PASSED=$((9 - $FAILED))

            GRADE=`perl -e "print $PASSED/9"`
            GRADE=`perl -e "print $GRADE*100"`

            SWITCH=`echo ${GRADE:0:1}`

            case $SWITCH in 
                9)
                    LETTER="A"
                    ;;
                8)
                    LETTER="B"
                    ;;
                7)
                    LETTER="C"
                    ;;
                6)
                    LETTER="D"
                    ;;
                *)
                    LETTER="F"
                    ;;
            esac

            echo ${GRADE:0:5}"% "$LETTER            
    else
        echo "100% A"
    fi
fi

exit