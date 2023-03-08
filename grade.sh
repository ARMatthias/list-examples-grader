if [[ $OSTYPE == "linux-gnu" ]] 
    then 
        CPATH=".:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar"
elif [[ $OSTYPE == "msys" ]] 
    then
        CPATH=".;lib/junit-4.13.2.jar;lib/hamcrest-core-1.3.jar"
fi

rm -rf student-submission
truncate -s 0 gradeReports/*.txt

if [[ -e ListExamples.java ]]
    then 
        rm ListExamples.java
fi

git clone $1 student-submission

if [[ -e student-submission/ListExamples.java ]]
    then
        echo "ListExamples.java found"
        cp student-submission/ListExamples.java ./
else
    echo "Error: File ListExamples.java not found"
    exit 1
fi

javac -cp $CPATH *.java 2> gradeReports/javac-errs.txt
if [[ $? -ne 0 ]] 
    then 
        echo "Error: failure during compilation"
        echo "Compilation feedback:"
        cat gradeReports/javac-errs.txt 
        exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples 2> gradeReports/run-err.txt 1> gradeReports/jUnit-out.txt
out= cat gradeReports/run-err.txt 
echo $out

if [[ $? -ne 0 ]]
    then
        echo "Error: failure during runtinme"
        exit 1
else
    if grep "FAILURES" gradeReports/jUnit-out.txt;
        then 
            cat gradeReports/jUnit-out.txt | echo
    else
        echo "PASS: 100%"
        echo "Grade: A"
    fi
fi

exit