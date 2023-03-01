if [[ $OSTYPE == "linux-gnu" ]] 
    then 
        CPATH=".:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar"
elif [[ $OSTYPE == "msys" ]] 
    then
        CPATH=".;lib/junit-4.13.2.jar;lib/hamcrest-core-1.3.jar"
fi

rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'

cd student-submission

if [[ -e ListExamples.java ]]
    then
        echo "ListExamples.java found"
else
    echo "Error: File ListExamples.java not found"
    (exit 1)
fi

cd ..

javac -cp $CPATH *.java 2> gradeReports/javac-errs.txt
if [[ $? -gt 0 ]] 
    then 
        echo "Error: failure during compilation"
        cat gradeReports/javac-errs.txt | echo
        (exit 1)
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples 2> gradeReports/run-err.txt 1> gradeReports/jUnit-out.txt
out= cat gradeReports/run-err.txt 
echo $out
if [[ $? -gt 0 ]]
    then
        echo "Error: failure during runtinme"
        (exit 1)
else
    nErr= grep "FAILURES" gradeReports/jUnit-out.txt
    if [[ -n nErr ]]
        then 
            cat gradeReports/jUnit-out.txt | echo
    else
        echo "PASS: 100%"
    fi
fi

exit