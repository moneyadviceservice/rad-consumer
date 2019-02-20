Feature: Landing page search
  As a customer
  I want to see the landing page with all search options available and working

  Background: Indexed firms and advisers
    Given I have a set of indexed firms and advisers

  Scenario: Search in person advisers
    When I visit landing page
    And I choose the "in person" search option with value "EC1N 2TD"
    Then I am redirected to the results page
    And I can see the "in person" option checked with value "EC1N 2TD"

  Scenario: Search remote firms
    When I visit landing page
    And I choose the "phone or online" search option
    Then I am redirected to the results page
    And I can see the "phone or online" option checked

  Scenario: Search firm by name
    When I visit landing page
    And I choose the "search for a firm by name" search option with value "Test Firm"
    Then I am redirected to the results page
    And I can see the "search for a firm by name" option checked with value "Test Firm"
