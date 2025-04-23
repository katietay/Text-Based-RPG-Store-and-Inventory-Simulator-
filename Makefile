# Configuration for Log4j

# Set this variable to the name of the Main class (there should be no Java package use at this time, we have other plans for using Java packages)
# Default: Main
MAIN_CLASS_NAME := Main 

# JUnit test class names including package (if declared)
JUNIT4_TEST_CLASS_NAME := TestSetJunit4
JUNIT5_TEST_CLASS_NAME := TestSetJunit5

# Where to look for the .jar files 
COMMON_JAR_DIR := /s/bach/b/class/cs214/public/lib

# Set variables for the .jar file paths
JUNIT_JAR_PATH := $(COMMON_JAR_DIR)/junit-platform-console-standalone-1.9.3.jar
LOG4J_CORE_JAR_PATH := $(COMMON_JAR_DIR)/log4j-core-2.12.4.jar
LOG4J_API_JAR_PATH := $(COMMON_JAR_DIR)/log4j-api-2.12.4.jar

# All .java files that aren't JUnit tests
PROGRAM_FILES := $(shell find . ! -name "TestSet*.java" ! -name "*Test.java" -name "*.java")
# instead of the find command, the variable can also be a constant
# PROGRAM_FILES := Main.java Item.java Store.java Player.java Escrow.java

JUNIT4_TEST_FILE := $(JUNIT4_TEST_CLASS_NAME).java
JUNIT5_TEST_FILE := $(JUNIT5_TEST_CLASS_NAME).java

CORRECT_JAVA_VERSION := 17

.DEFAULT_GOAL := help

all: clean compile-junit4 run-junit4 compile-junit5 run-junit5 compile run ## run clean, junit4 tests, junit5 tests, and if they pass launch the program

compile: correct-java-version ## Compile the program with log4j
	javac -d . --class-path $(LOG4J_CORE_JAR_PATH):$(LOG4J_API_JAR_PATH) $(PROGRAM_FILES)

run: recompile-warning ## Run main program
	java --class-path $(LOG4J_CORE_JAR_PATH):$(LOG4J_API_JAR_PATH):. $(MAIN_CLASS_NAME)

compile-junit4: correct-java-version ## Compile the JUnit4 test set with log4j and JUnit
	javac -d . --class-path $(LOG4J_CORE_JAR_PATH):$(LOG4J_API_JAR_PATH):$(JUNIT_JAR_PATH) $(PROGRAM_FILES) $(JUNIT4_TEST_FILE)

compile-junit5: correct-java-version ## Compile the JUnit5 test set with log4j and JUnit
	javac -d . --class-path $(LOG4J_CORE_JAR_PATH):$(LOG4J_API_JAR_PATH):$(JUNIT_JAR_PATH) $(PROGRAM_FILES) $(JUNIT5_TEST_FILE)

run-junit4: recompile-warning-junit4 ## Run junit4 tests
	java -jar $(JUNIT_JAR_PATH) --class-path $(LOG4J_CORE_JAR_PATH):$(LOG4J_API_JAR_PATH):$(JUNIT_JAR_PATH):. --select-class $(JUNIT4_TEST_CLASS_NAME)

run-junit5: recompile-warning-junit5 ## Run junit5 tests
	java -jar $(JUNIT_JAR_PATH) --class-path $(LOG4J_CORE_JAR_PATH):$(LOG4J_API_JAR_PATH):$(JUNIT_JAR_PATH):. --select-class $(JUNIT5_TEST_CLASS_NAME)

clean: ## Remove all .class files in the current folder and all its subdirectories
	find . -name "*.class" -type f -delete

help: ## Display the help strings for each target
	@printf "Usage: make [Target]\\n\\n"
	@printf "%-30s%s\\n" "Target" "Action"
	@eval $$(sed -r -n 's/^([a-zA-Z0-9_-]+):.*?## (.*)$$/printf "%-30s%s\\n" "\1" "\2" ;/; ta; b; :a p' $(MAKEFILE_LIST) | sort)


###############################################################################################
# Everything below is only used for setup-vscode, coverage generation, and environment checks #
#                            You are NOT expected to read it!                                 #
###############################################################################################

# For non-CSU machines:
#
# To generate coverage reports, in addition to the log4j and junit 
# libraries, the following .zip file has to be downloaded:
# https://github.com/jacoco/jacoco/releases/download/v0.8.11/jacoco-0.8.11.zip
# And the jacococli.jar and jacocoagent.jar files need to be extracted

ccyellow=\033[0;33m
ccbold=\033[1m
ccitalic=\033[3m
ccunderline=\033[4m
ccstrikethrough=\033[9m
ccgrey=\033[2m
ccred=\033[0;31m
ccblue=\033[0;34m
ccbgred=\033[0;41m
ccgreen=\033[0;32m
ccpurple=\033[0;35m
ccbgyellow=\033[0;43m
ccbggrey=\033[0;100m
ccbgblack=\033[0;40m
ccbggreen=\033[0;42m
ccbgblue=\033[0;44m
ccend=\033[0m
cccode=$(ccgrey)$(ccbold)
ccclear=\033[K

## Helpers to ensure your code runs as expected

define GENERIC_ERROR_MESSAGE
Make sure your Makefile is configured correctly and $(ccblue)make all$(ccend) successfully runs your JUnit tests and launches $(cccode)Main$(ccend)
If the issue persists you can consult the Helpdesk or simply wait a day and see if an updated version of the Makefile is available
$(ccbold)$(ccitalic)While you are welcome to try, you are not expected to be able to debug the Makefile past the $(ccblue)help$(ccend)$(ccbold)$(ccitalic) target!$(ccend)

endef

correct-java-version: $(eval SHELL:=/bin/bash) ## Check if you have the correct Java version set up (no output = correct)
	@version="$$(javac -version 2>&1 | sed -r 's/^javac\s([01]\.[0-9]+|[0-9]+).*$$/\1/')" ;\
	if [ "$$version" != "$(CORRECT_JAVA_VERSION)" ]; \
	then \
		echo -e "\n$(ccbgred) Incorrect Java version detected: $$version, expected Java $(CORRECT_JAVA_VERSION) $(ccend)\nTo avoid issues with feedback generation, please use $(cccode)module unload java; module load java/$(CORRECT_JAVA_VERSION)$(ccend) to load Java $(CORRECT_JAVA_VERSION)\n" ; \
		sleep 1 ;\
	fi

recompile-warning recompile-warning-junit4 recompile-warning-junit5: recompile-warning%: $(eval SHELL:=/bin/bash)
	@if [ -z $$(find . -mmin -0.1 -name "*.class" -type f -print | head -n 1) ] ;\
	then \
		echo -e "\n$(ccbgyellow)It looks like you haven't compiled your code recently!$(ccend)\nConsider using $(cccode)make compile$* && make run$*$(ccend) instead to ensure your changes are always included when running the program\n" ;\
	fi

check-push: $(eval SHELL:=/bin/bash) ## Perform a simple check to see if all of your code was pushed to GitHub
	@echo -e "$(ccyellow)This check only takes into account files that are known to be necessary to compile your program and provide feedback on your code$(ccend)" ;\
	echo -e "$(ccred)Depending on your implementation additional files may need to be pushed to GitHub: Not seeing any issues when running this check does not necessarily mean everything was uploaded correctly!$(ccend)\n" ;\
	echo -e "$(ccbold)Found assignment files:$(ccend)" ;\
	for file in $(PROGRAM_FILES) $(JUNIT4_TEST_FILE) $(JUNIT5_TEST_FILE) Makefile .vscode/* ; do \
		if [[ -f "$$file" ]]; then \
			echo -e "$(ccgreen)    $$file$(ccend)" ;\
		fi ;\
	done ;\
	echo "" ;\
	MISSING=() ;\
	OLD=() ;\
	status=$$(git status --porcelain -uall) ;\
	for file in $(JUNIT4_TEST_FILE) $(JUNIT5_TEST_FILE) Makefile ; do \
		if [[ ! -f "$$file" ]]; then \
			MISSING+=("$$file") ;\
		fi ;\
		if [[ ! "$$status" =~ "^.. $$file\$$" ]]; then \
			OLD+=("$$file") ;\
		fi ;\
	done ;\
	if [[ $${#OLD[@]} -gt 0 ]]; then \
		echo -e "$(ccbold)Found uncommitted local changes:$(ccend)" ;\
		printf "$(ccred)    %s$(ccend)\n" "$${OLD[@]}" | echo -e "$$(cat -)" ;\
		echo "" ;\
	fi ;\
	missingstr="" ;\
	if [[ -z "$(PROGRAM_FILES)" ]] ; then \
		missingstr="$$missingstr    $(ccred)$(ccitalic)Did not find any .java files!$(ccend)\n" ;\
	fi ;\
	if [[ $${#MISSING[@]} -gt 0 ]]; then \
		missingstr="$$missingstr$$(printf "$(ccred)    %s$(ccend)\n" "$${MISSING[@]}")" ;\
		missingstr="$$missingstr\n" ;\
	fi ;\
	if [[ ! -f ".vscode/settings.json" ]]; then \
		missingstr="$$missingstr    $(ccblue)$(ccitalic)Did not detect any VSCode workspace configuration in the $(ccend)$(cccode)$(ccitalic).vscode/$(ccend)$(ccblue)$(ccitalic) folder$(ccend)\n" ;\
	fi ;\
	if [[ $${#missingstr} -gt 0 ]]; then \
		echo -e "$(ccbold)Potentially missing files:$(ccend)" ;\
		echo -e "$$missingstr" ;\
	fi ;\
	unpushed=$$(git log origin/main..HEAD "--format=format:    $(ccred)%s$(ccend) $(ccgrey)$(ccitalic)- Created %ah$(ccend)") ;\
	if [ ! -z "$$unpushed" ]; then \
		echo -e "$(ccbgred)Found commits that were not pushed to GitHub!$(ccend)" ;\
		echo -e "$$unpushed"; \
		echo -e "\nDon't forget to run $(ccred)$(ccbold)git push$(ccend) after committing your changes!\n" ;\
	fi ;\

define COMMIT_HELP_MESSAGE

$(ccbgblue)$(ccbold)   Committing your code   $(ccend)

By running $(cccode)git status$(ccend) you can see which files will currently be included when you run $(cccode)git commit -m "MESSAGE"$(ccend) to create a new commit
Use the $(cccode)git add$(ccend) and $(cccode)git restore$(ccend) commands as described when running $(cccode)git status$(ccend) to add ($(ccbold)stage$(ccend)) and remove files from the next commit

$(ccyellow)It is recommended that you commit any files necessary for compilation except the $(ccend)$(cccode).jar$(ccend)$(ccyellow) libraries$(ccend)
You should also include the $(cccode)Makefile$(ccend) and the $(cccode).vscode$(ccend) folder

Once you are done staging your files, run $(cccode)git commit -m "YOUR COMMIT MESSAGE HERE"$(ccend) 
to create the commit and $(cccode)$(ccred)git push$(ccend) to upload it to GitHub

$(ccbgblue)$(ccbold)   .gitignore   $(ccend)

To stop files you don't want in the GitHub repository from showing up in $(cccode)git status$(ccend) 
and prevent them from being committed you can add a $(cccode).gitignore$(ccend)

git will act as if the files listed in a $(cccode).gitignore$(ccend) file don't exist at all

$(cccode).gitignore$(ccend) example:
*.jar
*.class
coverage_report/*

If there is a $(ccblue)/$(ccend) in the beginning or middle of the pattern, $(ccgrey)git$(ccend) assumes 
the path is relative to the directory the $(cccode).gitignore$(ccend) file is in.
Otherwise file and directory name patterns match anywhere in, or in a subdirectory of, the directory the $(cccode).gitignore$(ccend) file is in.

You can also include a file explicitly by prefixing it with $(ccblue)!$(ccend)
For example to make git ignore any $(cccode).java$(ccend) files that contain the word $(ccblue)Test$(ccend), 
but still include $(cccode)TestSetJUnit4.java$(ccend), $(cccode)TestSetJUnit5.java$(ccend), and $(cccode)SomeOtherCoolTestFile.java$(ccend) you could use
$(cccode).gitignore$(ccend):
*Test*.java
!TestSetJUnit?.java
!SomeOtherCoolTestFile.java

$(ccbgblue)$(ccbold)   File Path Pattern Matching   $(ccend)

The previous example used two different types of pattern matching operators: $(ccblue)*$(ccend) and $(ccblue)?$(ccend)

$(ccblue)*$(ccend) matches any string (including the empty string). This means $(ccblue)*Test*.java$(ccend) matches 
any file name that ends in $(ccblue).java$(ccend) and has the word $(ccblue)Test$(ccend) somewhere before that

$(ccblue)?$(ccend) matches any single character. That means $(ccblue)TestSetJUnit?.java$(ccend) 
matches $(ccgrey)TestSetJUnit4.java$(ccend), $(ccgrey)TestSetJUnit5.java$(ccend), $(ccgrey)TestSetJUnit..java$(ccend), etc.
but not $(ccgrey)TestSetJUnit.java$(ccend) or $(ccgrey)TestSetJUnit42.java$(ccend)

$(ccyellow)These patterns only work for individual file path components$(ccend): 
To match any file containing the word $(ccblue)Test$(ccend) in any subfolder of the current directory 
you would have to use $(ccblue)*/*Test*$(ccend) instead of just $(ccblue)*Test*$(ccend)

You can experiment around with them by using $(cccode)echo PATTERN$(ccend) 
Note this will just output your pattern if no matching file is found

$(ccbold)git$(ccend) also supports matching any file in any subdirectory using $(ccblue)**$(ccend)
While $(ccblue)*$(ccend) and $(ccblue)?$(ccend) also work in the terminal, for example when compiling using $(cccode)javac$(ccend),
$(ccblue)**$(ccend) is not supported in most cases outside of newer versions of $(ccbold)git$(ccend)

$(ccblue)**$(ccend) matches any files anywhere in the directory or subdirectory of the $(cccode).gitignore$(ccend)
$(ccblue)**/coverage_report/**/*.gif$(ccend) matches any $(cccode).gif$(ccend) files anywhere within any folder named $(ccblue)coverage_report$(ccend)

endef

export COMMIT_HELP_MESSAGE
help-commit: $(eval SHELL:=/bin/bash) ## Instructions on how to commit and simplify the commit process
	@echo -e "$$COMMIT_HELP_MESSAGE" | less -F -K -R -P "COMMIT HELP -- Press RETURN for more, or q when done"

## VSCode Setup

# Ask for confirmation before overriding any of the student's settings
allow-settings-override: $(eval SHELL:=/bin/bash)
	@if [ -f .vscode/settings.json ]; \
	then \
		echo -e -n "Override existing workspace settings in $(cccode).vscode/settings.json$(ccend)? [y/N] " && read ans && [ $${ans:-N} = y ]; \
	fi
 
# Create settings.json with log4j jar files added to the java libraries list
# Also create launch.json if it doesn't exist, with a configuration for Main and the current file
setup-vscode: $(eval SHELL:=/bin/bash) allow-settings-override ## Setup log4j and JUnit to work with VSCode's built-in debugger and test panel	
	@mkdir -p ".vscode"
	@echo -e "{\n  \"java.project.referencedLibraries\": [\n    \"$(LOG4J_CORE_JAR_PATH)\",\n    \"$(LOG4J_API_JAR_PATH)\",\n    \"$(JUNIT_JAR_PATH)\"\n  ]\n}" > .vscode/settings.json
	@echo -e "Created $(cccode).vscode/settings.json$(ccend) (Workspace Settings)" 

	@if [ ! -f .vscode/launch.json ]; \
	then \
		echo -e "{\n  // Use IntelliSense to learn about possible attributes.\n  // Hover to view descriptions of existing attributes.\n  // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387\n  \"version\": \"0.2.0\",\n  \"configurations\": [\n    {\n      \"type\": \"java\",\n      \"name\": \"Main\",\n      \"request\": \"launch\",\n      \"mainClass\": \"Main\"\n		},\n    {\n      \"type\": \"java\",\n      \"name\": \"Current File\",\n      \"request\": \"launch\",\n      \"mainClass\": \"\$${file}\"\n    }\n	]\n}" > .vscode/launch.json ; \
		echo -e "Created $(cccode).vscode/launch.json$(ccend) (Run and Debug Settings)" ; \
	fi

	@echo -e "\n$(ccbold)To run JUnit tests using VSCode, click on the Erlenmeyer flask icon on the left where you should see all the JUnit tests you have implemented so far$(ccend)"
	@echo -e "$(ccyellow)If the icon doesn't show up, make sure you have the $(ccend)$(ccbold)Extension Pack for Java$(ccend)$(ccyellow) installed or try reopening VSCode from the assignment folder$(ccend)"
	@echo -e "$(ccyellow)If the icon still doesn't show up, try pressing $(ccblue)Ctrl/⌘  + Shift + P$(ccyellow) and search for $(ccend)$(ccbold)Java: Run Tests$(ccend)"

	@echo -e "\n$(ccbold)Your VSCode workspace should now be configured to run and debug your program using the built-in debugger ($(ccblue)Ctrl/⌘  + Shift + D$(ccend)$(ccbold))$(ccend)"

	@if [ ! -f .vscode/extensions.json ]; \
	then \
		echo -e "{\n  \"recommendations\": [\n    \"vscjava.vscode-java-pack\"\n  ]\n}" > .vscode/extensions.json ; \
	fi

## Coverage Report

coverage-html: correct-java-version $(eval SHELL:=/bin/bash) ## Generate an HTML coverage report for your JUnit tests
	@set -e ;\
	tmpdir=$$(mktemp -d);\
	$(MAKE) --no-print-directory $(MFLAGS) TMP=$$tmpdir SOURCE_FOLDER=$$(pwd) coverage-assuming-tmpdir ;\
	rm -rf $$tmpdir

coverage-zip: $(eval SHELL:=/bin/bash) coverage-html ## Generate the same HTML coverage report but also provide a .zip version of the folder
	@zip -q -r coverage_report.zip coverage_report
	@echo -e "Generated $(cccode)coverage_report.zip$(ccend)"

export GENERIC_ERROR_MESSAGE
coverage-assuming-tmpdir: $(eval SHELL:=/bin/bash)
	@if [[ ! -f $(abspath $(COMMON_JAR_DIR))/jacocoagent.jar ]]; then \
		errmsg="\r$(ccclear)\n$(ccbgred) JaCoCo .jar files not found! $(ccend)\nPlease make sure $(cccode)jacocoagent.jar$(ccend) and $(cccode)jacococlijar$(ccend) are located in the $(cccode).jar$(ccend) you configured in the Makefile ($(cccode)$(COMMON_JAR_DIR)$(ccend))\nFor more information run $(ccblue)make coverage-help$(ccend)\n" ;\
		echo -e "$$errmsg" 1>&2 ;\
		exit 1 ;\
	else \
		([[ -z "$(PRINT_COVERAGE_PROGRESS)" ]] || echo -n -e "\r$(ccblue)$(ccbold)Generating test coverage report: Compiling Tests ...$(ccend)" 1>&2) ;\
		javac -d $(TMP) --class-path $(LOG4J_CORE_JAR_PATH):$(LOG4J_API_JAR_PATH):$(JUNIT_JAR_PATH) $(PROGRAM_FILES) $(JUNIT4_TEST_FILE) $(JUNIT5_TEST_FILE) ; \
		if [[ $$? == 0 ]]; then \
			cd $(TMP) &&\
			([[ -z "$(PRINT_COVERAGE_PROGRESS)" ]] || echo -n -e "\r$(ccblue)$(ccbold)Generating test coverage report: Recording JUnit4 test coverage data ...$(ccend)" 1>&2) &&\
			java -javaagent:$(abspath $(COMMON_JAR_DIR))/jacocoagent.jar=destfile=junit4.exec,excludes=$(JUNIT4_TEST_CLASS_NAME):$(JUNIT5_TEST_CLASS_NAME) -jar $(abspath $(JUNIT_JAR_PATH)) --class-path $(abspath $(LOG4J_API_JAR_PATH)):$(abspath $(LOG4J_CORE_JAR_PATH)):. --select-class $(JUNIT4_TEST_CLASS_NAME) || true &&\
			([[ -z "$(PRINT_COVERAGE_PROGRESS)" ]] || echo -n -e "\r$(ccblue)$(ccbold)Generating test coverage report: Recording JUnit5 test coverage data ...$(ccend)" 1>&2) &&\
			java -javaagent:$(abspath $(COMMON_JAR_DIR))/jacocoagent.jar=destfile=junit5.exec,excludes=$(JUNIT4_TEST_CLASS_NAME):$(JUNIT5_TEST_CLASS_NAME) -jar $(abspath $(JUNIT_JAR_PATH)) --class-path $(abspath $(LOG4J_API_JAR_PATH)):$(abspath $(LOG4J_CORE_JAR_PATH)):. --select-class $(JUNIT5_TEST_CLASS_NAME) || true &&\
			find . -name "$(JUNIT4_TEST_CLASS_NAME).class" -type f -delete &&\
			find . -name "$(JUNIT5_TEST_CLASS_NAME).class" -type f -delete &&\
			([[ -z "$(PRINT_COVERAGE_PROGRESS)" ]] || echo -n -e "\r$(ccclear)$(ccblue)$(ccbold)Generating test coverage report: Compiling report ...$(ccend)" 1>&2) &&\
			java -jar $(abspath $(COMMON_JAR_DIR))/jacococli.jar report junit4.exec junit5.exec --classfiles . --sourcefiles $(SOURCE_FOLDER) --name "JUnit Coverage" --html $(SOURCE_FOLDER)/coverage_report $(REPORT_GENERATION_ARGS) ;\
			if [[ $$? != 0 ]]; then \
				echo -e "\n$(ccbgred) Error generatic coverage report! $(ccend)\n$$GENERIC_ERROR_MESSAGE" 1>&2 ;\
				exit 1;\
			fi ;\
			([[ -z "$(PRINT_COVERAGE_PROGRESS)" ]] || echo -n -e "\r$(ccclear)$(ccblue)$(ccbold)Generating test coverage report: Done!$(ccend)" 1>&2) ;\
			echo -e "\nGenerated coverage report: $(cccode)coverage_report/index.html$(ccend)" ;\
		else \
			echo -e "\n$(ccbgred) Error compiling your JUnit tests! $(ccend)\n$$GENERIC_ERROR_MESSAGE" 1>&2 ;\
			exit 1 ;\
		fi ;\
	fi

coverage: ## Generate a coverage report and display the results directly in the terminal 
	@err=$$($(MAKE) --no-print-directory $(MFLAGS) correct-java-version) ;\
	set -e ;\
	tmpdir=$$(mktemp -d);\
	echo -e -n "$(ccblue)$(ccbold)Generating test coverage report .$(ccend)" ;\
	$(MAKE) --no-print-directory $(MFLAGS) TMP=$$tmpdir SOURCE_FOLDER=$$tmpdir REPORT_GENERATION_ARGS="--xml $$tmpdir/coverage.xml" PRINT_COVERAGE_PROGRESS="$(ccblue)$(ccbold).$(ccend)" coverage-assuming-tmpdir 1> /dev/null;\
	(echo -e "$$err\n" && $(MAKE) --no-print-directory $(MFLAGS) XML_PATH="$$tmpdir/coverage.xml" pretty-print-coverage-text | tee $$tmpdir/logs.log) | less -K -R -S -P "TEST COVERAGE -- Press RETURN for more, arrow keys to scroll, or q when done" ;\
	#echo -e "\r$$(cat $$tmpdir/logs.log)" ;\
	rm -rf $$tmpdir

pretty-print-coverage-text: $(eval SHELL:=/bin/bash)
	@SEQ=("INSTRUCTION" "BRANCH" "LINE" "COMPLEXITY" "METHOD" "CLASS") ;\
	CODELEN="68" ;\
	function printtag () {\
		if [[ "$${jni:0:1}" == "V" ]]; then \
			val="void" ;\
		elif [[ "$${jni:0:1}" == "Z" ]]; then \
			val="boolean" ;\
		elif [[ "$${jni:0:1}" == "B" ]]; then \
			val="byte" ;\
		elif [[ "$${jni:0:1}" == "C" ]]; then \
			val="char" ;\
		elif [[ "$${jni:0:1}" == "S" ]]; then \
			val="short" ;\
		elif [[ "$${jni:0:1}" == "I" ]]; then \
			val="int" ;\
		elif [[ "$${jni:0:1}" == "J" ]]; then \
			val="long" ;\
		elif [[ "$${jni:0:1}" == "F" ]]; then \
			val="float" ;\
		elif [[ "$${jni:0:1}" == "D" ]]; then \
			val="double" ;\
		elif [[ "$${jni:0:1}" == "L" ]]; then \
			IFS=";" read -r signature jni <<< $${jni:1} ;\
			jni=";$$jni" ;\
			val=$$(echo $$signature | sed -r 's/\//./g') ;\
		elif [[ "$${jni:0:1}" == "[" ]]; then \
			brackets="" ;\
			while [[ "$${jni:0:1}" == "[" ]]; do \
				brackets="[]$$brackets" ;\
				jni=$${jni:1} ;\
			done ;\
			printtag ;\
			line="$$line[]" ;\
			val="" ;\
		fi ;\
		if [[ ! -z "$$val" ]]; then \
			line="$$line$(ccpurple)$$val$(ccend)" ;\
		fi ;\
		jni=$${jni:1} ;\
	} ;\
	function printcoverage() {\
		linelen="$$(echo "$$line " | sed -r "s/\\\\033\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g" | wc -m)" ;\
		line="$$line " ;\
		[[ $$CODELEN -gt $$linelen ]] && line="$$line$$(printf "%$$((CODELEN - linelen))s" | tr " " ".")" ;\
		if [[ "$${line: -1}" == '.' ]]; then \
			line="$$line " ;\
		fi ;\
		i=0;\
		while [[ ! -z "$$counters"  ]]; do \
			IFS=":" read -r -a COUNTER <<< $$(echo $$counters | sed -r -n 's/<counter type="([^"]*)" missed="([^"]*)" covered="([^"]*)"\/>(.*)/\1:\2:\3:\4/p') ;\
			if [[ $${SEQ[i]} == $${COUNTER[0]} ]]; then \
				counters=$${COUNTER[3]} ;\
				count=$$(printf '%11s ' "$${COUNTER[2]}/$$(($${COUNTER[1]} + $${COUNTER[2]}))") ;\
				greencnt=$$((12 * $${COUNTER[2]} / $$(($${COUNTER[1]} + $${COUNTER[2]})))) ;\
				if [[ $$greencnt -eq 0 ]]; then \
					greencnt="1" ;\
				fi ;\
				color="$(ccbgyellow)" ;\
				if [[ $${COUNTER[1]} -eq "0" ]]; then \
					color="$(ccbggreen)" ;\
				elif [[ $${COUNTER[2]} -eq "0" ]]; then \
					color="$(ccbgred)" ;\
				fi ;\
				line="$$line$$color$${count:0:greencnt}$(ccend)$(ccbgred)$${count:greencnt}$(ccend) " ;\
			else \
				line="$$line             " ;\
			fi ;\
			i=$$((i + 1)) ;\
		done ;\
	} ;\
	function printcoveragetitles() {\
		line=$$(printf "%$${CODELEN}s") ;\
		for title in "$${SEQ[@]}" ; do \
			line="$$line$(ccbold)$$(printf '%-12s' "$$title")$(ccend) " ;\
		done ;\
		echo -e "$$line" ;\
	} ;\
	function generatereport() {\
		echo -e "$(ccbold)Summarized$(ccend) test coverage for your JUnit4 and JUnit5 tests\n\nA full test report can be generated using $(cccode)make coverage-html$(ccend) or $(cccode)make coverage-zip$(ccend)\n" ;\
		report=$$(cat $(XML_PATH)) ;\
		counters=$$(echo "$$report" | sed -r -n 's/.*<\/package>(.*)<\/report>/\1/p') ;\
		printcoveragetitles ;\
		line="$(ccbold)Overall Test Coverage$(ccend)" ;\
		printcoverage ;\
		echo -e "$$line\n\n" ;\
		while [[ "$${report}" =~ "</class>" ]]; do \
			printcoveragetitles ;\
			IFS=":" read -r -a CLASS <<< $$(echo $$report | sed -r -n 's/<class name="([^"]*)"[^>]*">(.*)/:\1:\2/p') ;\
			IFS=":" read -r classreport report <<< $$(echo $${CLASS[2]} | sed -r 's/<\/class>/:/') ;\
			classreport="$$classreport" ;\
			classname=$$(echo $${CLASS[1]} | sed -r 's/\//./g') ;\
			line="$(ccred)$$classname$(ccend) {" ;\
			counters=$$(echo $$classreport | sed -r -n 's/.*<\/method>(.*)/\1/p') ;\
			printcoverage ;\
			echo -e "$$line" ;\
			while [[ "$${classreport:0:7}" == "<method" ]]; do \
				line="  " ;\
				IFS=":" read -r -a METHOD <<< $$(echo $$classreport | sed -r -n 's/<method name="([^"]*)" desc="([^"]*)"[^>]*>(.*)/\1:\2:\3/p' | sed -r -n 's/<\/method>(.*)/:\1/p') ;\
				methodname=`echo $${METHOD[0]} | sed -r 's/&lt;init&gt;/'"$$classname"'/' | sed -r 's/&lt;clinit&gt;/static/'` ;\
				classreport=$${METHOD[3]} ;\
				if [[ "$${METHOD[0]}" != "&lt;clinit&gt;" ]]; then \
					IFS=")" read -r argjni jni <<< $${METHOD[1]:1} ;\
					if [[ "$${METHOD[0]}" != "&lt;init&gt;" ]]; then \
						printtag ;\
						line="$$line " ;\
					fi ;\
					line="$$line$(ccblue)$$methodname$(ccend)(" ;\
					jni=$$argjni ;\
					while [[ ! -z "$$jni" ]]; do \
						printtag ;\
						[[ -z "$$jni" ]] || line="$$line, " ;\
					done ;\
					line="$$line)" ;\
				else \
					line="$$line$(ccblue)static$(ccend) {}" ;\
				fi	;\
				counters=$${METHOD[2]} ;\
				printcoverage ;\
				echo -e "$$line" ;\
			done ;\
			echo -e "}\n" ;\
		done ;\
	} ;\
	generatereport

define COVERAGE_HELP_MESSAGE

$(ccbgblue)$(ccbold)   Test Coverage   $(ccend)

The $(cccode)Makefile$(ccend) uses $(ccblue)JaCoCo$(ccend) to generate the coverage reports.
The documentation can be found here: $(ccitalic)$(ccgrey)https://www.jacoco.org/jacoco/trunk/doc/counters.html$(ccend)

Test coverage is a tool to $(ccbold)estimate$(ccend) how well your tests exercise your code. 
This is done by watching the JUnit tests as they are executed and capturing which instructions were reached during testing.
$(ccyellow)100% Test coverage does not mean your tests are perfect! It just means all instructions in your code were executed at some point during testing$(ccend)

$(ccbgblue)$(ccbold)   Coverage Types   $(ccend)

$(ccpurple)$(ccunderline)$(ccbold)Instruction$(ccend)
An instruction is a single Java bytecode instruction
A single line of source code can often compile into multiple bytecode instructions

$(ccpurple)$(ccunderline)$(ccbold)Branch$(ccend)
Branches are conditional code paths
For example the $(ccblue)if$(ccend) statement:
$(ccblue)if$(ccend) $(ccpurple)($(ccend)$(ccred)condition$(ccend)$(ccpurple)) {$(ccend)
    System.out.$(ccblue)println($(ccend)$(ccgreen)"true"$(ccend)$(ccblue))$(ccend);
    System.out.$(ccblue)println($(ccend)$(ccgreen)"Good Job 👍"$(ccend)$(ccblue))$(ccend);
$(ccpurple)} $(ccblue)else $(ccpurple){$(ccend)
    System.out.$(ccblue)println($(ccend)$(ccgreen)"false"$(ccend)$(ccblue))$(ccend);
$(ccpurple)}$(ccend)
has two branches since which block of code gets executed depends on the value of $(ccred)condition$(ccend)

$(ccpurple)$(ccunderline)$(ccbold)Line$(ccend)
Lines refer to lines of code in your $(cccode).java$(ccend) files

$(ccpurple)$(ccunderline)$(ccbold)Complexity$(ccend)
Cyclomatic complexity measures the number of linearly independent execution paths through the section of code
This means to the complexity can serve as an indicator for how many different ways a section of code needs to be executed to achieve full test coverage
For more information on Cyclomatic Complexity see $(ccgrey)$(ccitalic)https://en.wikipedia.org/wiki/Cyclomatic_complexity$(ccend)
or $(ccblue)JaCoCo$(ccend)'s documentation: $(ccgrey)$(ccitalic)https://www.jacoco.org/jacoco/trunk/doc/counters.html$(ccend)

$(ccpurple)$(ccunderline)$(ccbold)Method$(ccend)
Java methods in the class or program

$(ccpurple)$(ccunderline)$(ccbold)Class$(ccend)
Java classes

$(ccbgblue)$(ccbold)   JaCoCo $(ccgrey).jar$(ccend)$(ccbgblue)$(ccbold) files   $(ccend)

When running the $(cccode)Makefile$(ccend) from the CSU linux machines the $(cccode).jar$(ccend) files 
for $(ccblue)JaCoCo$(ccend) can be found at $(cccode)/s/bach/b/class/cs214/public/lib$(ccend)

Otherwise the $(ccblue)JaCoCo$(ccend) files have to be downloaded from $(ccitalic)$(ccgrey)https://github.com/jacoco/jacoco/releases/download/v0.8.11/jacoco-0.8.11.zip$(ccend).
The $(cccode)jacococli.jar$(ccend) and $(cccode)jacocoagent.jar$(ccend) files need to be extracted and placed into 
the $(cccode).jar$(ccend) folder you configured at the top of the Makefile ($(cccode)$(COMMON_JAR_DIR)$(ccend))

$(ccbgblue)$(ccbold)   Issues generatic coverage report?   $(ccend)

$(GENERIC_ERROR_MESSAGE)
endef

export COVERAGE_HELP_MESSAGE
coverage-help: $(eval SHELL:=/bin/bash) ## Short introduction to test coverage
	@echo -e "$$COVERAGE_HELP_MESSAGE" | less -F -K -R -P "COVERAGE HELP -- Press RETURN for more, or q when done"