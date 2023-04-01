@qtype @qtype_stack
Feature: Create, preview, test, tidy and edit STACK questions
  In order evaluate students mathematical ability
  As an teacher
  I need to create, preview, test, tidy and edit STACK questions.

  Background:
    Given I set up STACK using the PHPUnit configuration
    And the following "courses" exist:
      | fullname | shortname | format |
      | Course 1 | C1        | topics |
    And the following "users" exist:
      | username | firstname |
      | teacher  | Teacher   |
    And the following "course enrolments" exist:
      | user    | course | role           |
      | teacher | C1     | editingteacher |

  @javascript
  Scenario: Create, preview, test, tidy and edit STACK questions
    When I am on the "Course 1" "core_question > course question bank" page logged in as "teacher"
    # Create a new question.
    And I add a "STACK" question filling the form with:
      | Question name      | Test STACK question                                                           |
      | Question variables | p : (x-1)^3;                                                                  |
      | Question text      | Differentiate {@p@} with respect to \(x\). [[input:ans1]] [[validation:ans1]] |
      | Model answer       | diff(p,x)                                                                     |
      | SAns               | ans1                                                                          |
      | TAns               | diff(p,x)                                                                     |
    Then I should see "Test STACK question"

    # Preview it.
    When I am on the "Test STACK question" "core_question > preview" page logged in as teacher
    And I set the following fields to these values:
      | How questions behave | Adaptive          |
      | Marks                | Show mark and max |
    And I press "Start again with these options"
    Then I should see "Differentiate"
    And the state of "Differentiate" question is shown as "Not complete"
    When I set the input "ans1" to "x-1" in the STACK question
    And I wait "2" seconds
    Then I should see "Your last answer was interpreted as follows"
    When I press "Check"
    Then I should see "Incorrect answer."
    And the state of "Differentiate" question is shown as "Not complete"
    When I set the input "ans1" to "3(x-1)^2" in the STACK question
    And I wait "2" seconds
    Then I should see "You seem to be missing * characters"
    When I set the input "ans1" to "3*(x-1)^2" in the STACK question
    And I wait "2" seconds
    And I press "Check"
    Then I should see "Correct answer, well done."
    And the state of "Differentiate" question is shown as "Answer saved"
    And I should see "Mark 0.90 out of 1.00"
    And I should see "Marks for this submission: 1.00/1.00. Accounting for previous tries, this gives 0.90/1.00."

    # Create a question test: two methods.
    When I follow "Question is missing tests or variants"
    Then I should see "This question does not use randomisation."
    When I press "Add test case assuming the teacher's input gets full marks."
    Then I should see "Automatically adding one test case assuming the teacher's input gets full marks."
    When I press "Delete this test case."
    Then I should see "Are you sure you want to delete test case 1 for question Test STACK question"
    When I press "Continue"
    Then I should see "Question is missing tests or variants. No test cases have been added yet."
    When I press "Add a test case..."
    And I set the following fields to these values:
      | ans1 | x - 1 |
    And I press "Fill in the rest of the form to make a passing test-case"
    Then the following fields match these values:
      | ans1        | x - 1    |
      | Score       | 0        |
      | Penalty     | 0.1      |
      | Answer note | prt1-1-F |
    When I press "Create test case"
    Then I should see "All tests passed!"
    And I should see "Test case 1"
    And following "Export as Moodle XML" should download between "3700" and "3800" bytes

    # Use the tidy question script.
    And I follow "Tidy inputs and PRTs"
    And I set the following fields to these values:
      | New name for 'ans1' | ans |
      | New name for 'prt1' | prt |
      | New name for '1'    | 2   |
    And I press "Rename parts of the question"
    And I follow "STACK question dashboard"
    Then I should see "All tests passed!"
    When I follow "Preview"

    # Edit the question, verify the form field contents, then change some.
    When I am on the "Test STACK question" "core_question > edit" page
    Then the following fields match these values:
      | Question name      | Test STACK question                                                         |
      | Question variables | p : (x-1)^3;                                                                |
      | Question text      | Differentiate {@p@} with respect to \(x\). [[input:ans]] [[validation:ans]] |
      | Specific feedback  | [[feedback:prt]]                                                            |
      | Model answer       | diff(p,x)                                                                   |
      | SAns               | ans                                                                         |
      | TAns               | diff(p,x)                                                                   |
    And I set the following fields to these values:
      | Question name | Edited question name |
    And I press "id_submitbutton"
    Then I should see "Edited question name"

  @javascript
  Scenario: Test duplicating a STACK question keeps the deployed variants and question tests
    Given the following "question categories" exist:
      | contextlevel | reference | name           |
      | Course       | C1        | Default for C1 |
    And the following "questions" exist:
      | questioncategory | qtype | name             | template |
      | Default for C1   | stack | Question to copy | test1    |
    And the following "qtype_stack > Deployed variants" exist:
      | question         | seed |
      | Question to copy | 42   |
    And the following "qtype_stack > Question tests" exist:
      | question         | ans1 | PotResTree_1 score | PotResTree_1 penalty | PotResTree_1 note |
      | Question to copy | ta+C | 1                  | 0                    | PotResTree_1-1-T  |
    When I am on the "Course 1" "core_question > course question bank" page logged in as "teacher"
    And I choose "Duplicate" action for "Question to copy" in the question bank
    And I press "id_submitbutton"
    And I choose "STACK question dashboard" action for "Question to copy (copy)" in the question bank
    Then I should see "Deployed variants (1)"
    And I should see "42"
    And I should see "Test case 1"
    And I should see "All tests passed!"

  @javascript
  Scenario: Editing a STACK question (to make a new version) keeps the deployed variants and question tests
    Given the following "question categories" exist:
      | contextlevel | reference | name           |
      | Course       | C1        | Default for C1 |
    And the following "questions" exist:
      | questioncategory | qtype | name             | template |
      | Default for C1   | stack | Question to edit | test1    |
    And the following "qtype_stack > Deployed variants" exist:
      | question         | seed |
      | Question to edit | 42   |
    And the following "qtype_stack > Question tests" exist:
      | question         | ans1 | PotResTree_1 score | PotResTree_1 penalty | PotResTree_1 note |
      | Question to edit | ta+C | 1                  | 0                    | PotResTree_1-1-T  |
    When I am on the "Question to edit" "core_question > edit" page logged in as "teacher"
    And I set the field "Question name" to "Edited question"
    And I press "id_submitbutton"
    And I choose "STACK question dashboard" action for "Edited question" in the question bank
    Then I should see "Deployed variants (1)"
    And I should see "42"
    And I should see "Test case 1"
    And I should see "All tests passed!"
