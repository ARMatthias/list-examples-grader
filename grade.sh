echo $? beginning
if [[ $OSTYPE == "linux-gnu" ]] 
    then 
        CPATH=".:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar"
elif [[ $OSTYPE == "msys" ]] 
    then
        CPATH=".;lib/junit-4.13.2.jar;lib/hamcrest-core-1.3.jar"
fi

echo $? after compile

rm -rf student-submission
truncate -s 0 gradeReports/*.txt
git clone $1 student-submission
echo $? finished cloning

cd student-submission

echo $? after change directory

if [[ -e ListExamples.java ]]
    then
        echo "ListExamples.java found"
else
    echo "Error: File ListExamples.java not found"
    (exit 1)
fi

echo $? after found ListExamples.java

cd ..

echo $? after change directory second time

javac -cp $CPATH *.java 2> gradeReports/javac-errs.txt
echo $? after compilation
if [[ $? -ne 0 ]] 
    then 
        echo "Error: failure during compilation"
        cat gradeReports/javac-errs.txt | echo
        (exit 1)
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples 2> gradeReports/run-err.txt 1> gradeReports/jUnit-out.txt
out= cat gradeReports/run-err.txt 
echo $out

if [[ $? -ne 0 ]]
    then
        echo "Error: failure during runtinme"
        (exit 1)
else
    if grep "FAILURES" gradeReports/jUnit-out.txt;
        then 
            cat gradeReports/jUnit-out.txt | echo
    else
        echo "PASS: 100%"
    fi
fi

exit