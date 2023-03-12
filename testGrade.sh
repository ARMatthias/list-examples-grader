TITLES="Original (Lab 3):Correct:Compile Error:Incorrect Method Signature:Incorrect Filename:Nested File:Subtle Error"
IFS=":" read -a CASES <<< $TITLES

if [ -n "$SSH_CLIENT"];
    then 
        LIST="git@github.com:ucsd-cse15l-f22/list-methods-lab3.git
        git@github.com:ucsd-cse15l-f22/list-methods-corrected.git
        git@github.com:ucsd-cse15l-f22/list-methods-compile-error.git
        git@github.com:ucsd-cse15l-f22/list-methods-signature.git
        git@github.com:ucsd-cse15l-f22/list-methods-filename.git
        git@github.com:ucsd-cse15l-f22/list-methods-nested.git
        git@github.com:ucsd-cse15l-f22/list-examples-subtle.git"
else
    LIST="https://github.com/ucsd-cse15l-f22/list-methods-lab3.git
    https://github.com/ucsd-cse15l-f22/list-methods-corrected.git
    https://github.com/ucsd-cse15l-f22/list-methods-compile-error.git
    https://github.com/ucsd-cse15l-f22/list-methods-signature.git
    https://github.com/ucsd-cse15l-f22/list-methods-filename.git
    https://github.com/ucsd-cse15l-f22/list-methods-nested.git
    https://github.com/ucsd-cse15l-f22/list-examples-subtle.git"
fi

IFS="\n" read -a LINKS <<< $LIST

for i in ${!LINKS[@]}; do
    echo "============= ${CASES[$i]} ============="
    sh grade.sh ${LINKS[$i]}
done

