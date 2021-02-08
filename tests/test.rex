/* These are unit tests for FreeDOS SORT in Rexx (Regina). */
/* Usage: */
/*    C:\..> rexx text.rex [path_to\sort] */
/* The exit code from this Rexx script is the number of failed tests, unless if something goes badly wrong. */

/*    C:\..\sort\tests> rexx text.rex ..\src\sort */

/* It is suggested to put rexx.exe is in you PATH. */

tests_failed = 0
tests_passed = 0

SORT = ARG(1)

if SORT = '' then
    do
    say "The argument was empty. Do you want to use the default: '..\src\sort'?"
    pull yn
    if yn = 'Y' then
        do
            SORT = '..\src\sort'
        end
    end


/* TODO: How do you check for the existance of the SORT command. */
/*       Some of the test fail anyway. */

/* Test 1: Invalid parameter */
/* 'SORT /Z' */
call assertFailureCmd SORT '/Z'

/* Test 2: When you ask for help it it returns 1, indicating failure(?), slightly perplexing  */
/* 'SORT /?' */
call assertFailureCmd SORT '/?'


/* Test 3: Sort REINDEER.TXT, test if the first line is "Blitzen" and the last line is "Vixen" */
call charout ,'test (2 tests): SORT reindeer.lst'
filename = random_filename()
SORT reindeer.lst '>' filename
line_str = linein(filename)
call assertSuccessEqual line_str, 'Blitzen'

/* skip to last line */
do while lines(filename) > 0 
   line_str = linein(filename) 
end 

call assertSuccessEqual line_str, 'Vixen'
'DEL' filename
say

/* Test 4: Test for EOF case, the first line should be "EOF (end of file)" */
call charout ,'test: SORT eoftest.txt'
filename = random_filename()
SORT eoftest.txt '>' filename
line_str = linein(filename)
call assertSuccessEqual line_str, 'EOF (end of file)'
'DEL' filename
say

/* Test 5: Test column sorting */
call charout ,'test: SORT money.tbl'
filename = random_filename()
SORT '/+11' money.tbl '>' filename
line_str = linein(filename)
/* Tests that the first line of the sorted text starts with BOB */
call assertSuccessEqual left(line_str,3), 'BOB'
'DEL' filename
say

say '==========[' 'Tests Passed:' tests_passed   'Failed:' tests_failed ']=========='
exit tests_failed

/* =========================   Below this line are helper functions  ====================================== */
assertSuccessEqual:
PARSE ARG parm1, parm2
if parm1 == parm2 then
  do  
    tests_passed = tests_passed + 1 
  end
else
  do
    tests_failed = tests_failed + 1
    call charout ,'...FAILED'
  end
return

assertSuccessCmd: 
PARSE ARG cmd
call charout ,'test: "'cmd'"'
cmd
if RC \= 0 then
  do  
    tests_failed = tests_failed + 1
    call charout ,'...FAILED'
  end
else
  do
    tests_passed = tests_passed + 1 
  end
say
return 0

assertFailureCmd: 
PARSE ARG cmd
call charout ,'test: "' cmd '"'
if RC = 0 then
  do  
    tests_failed = tests_failed + 1
    call charout ,'...FAILED'
    return 1
  end
else
  do
    tests_passed = tests_passed + 1 
  end
say
return 0

/* Gerate a random filename */
random_filename:
return random()'.TMP'
