#!/bin/bash
#
# Tests grade.sh using 7 example student submissions (links stored in links.txt)
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

# makes an array of the titles of the cases, in the order they will be tested
TITLES="Original (Lab 3):Correct:Compile Error:Incorrect Method Signature:Incorrect Filename:Nested File:Subtle Error"
IFS=":" read -a CASES <<< $TITLES

# detemines which set of links to use (ssh(git@git) or local(https))
echo $SHH_CLIENT > gradeReports/javac-errs.txt
if grep -q "." gradeReports/javac-errs.txt;
    then 
        LIST=$(grep "git@git" links.txt)
else
    LIST=$(grep "https" links.txt)
fi

# makes an array of the links of the cases, in the order they will be tested
IFS="&" read -a LINKS <<< $LIST

# runs grade.sh for each case, labeling each for their respective case in terminal output
for i in ${!LINKS[@]}; do
    echo "============= ${CASES[$i]} ============="

    # clear previous submission
    rm -rf student-submission
    truncate -s 0 gradeReports/*.txt
    if [[ -e ListExamples.java ]]
        then 
            rm ListExamples.java
    fi

    # retrieve student submission
    git clone ${LINKS[$i]} student-submission

    # check if ListExamples.java is in student submission
    if [[ -e student-submission/ListExamples.java ]]
        # if exists, print found, copy student submission out
        then
            echo "ListExamples.java found"
            cp student-submission/ListExamples.java ./
    else
        # if not, print error, continue to next case
        echo "Error: File ListExamples.java not found"
        continue
    fi

    # compile and check if compilation is successful
    javac -cp $CPATH *.java 2> gradeReports/javac-errs.txt
    if [[ $? -ne 0 ]] 
        # if unsuccessful, print standard error, continue to next case
        then 
            echo "Error: failure during compilation"
            echo "Compilation feedback:"
            cat gradeReports/javac-errs.txt 
            continue
    fi

    # run and record outputs to corresponding files
    java -cp $CPATH org.junit.runner.JUnitCore TestListExamples 2> gradeReports/run-err.txt 1> gradeReports/jUnit-out.txt
    OUT=$(cat gradeReports/run-err.txt)

    # check for successful runtime
    if [[ $? -ne 0 ]]
        # if unsuccessful, print standard error, continue to next case
        then
            echo "Error: failure during runtinme"
            echo $OUT
            continue
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
    done

exit

