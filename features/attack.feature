Feature: Verify the attack behaviour is correct

  In order to ensure attack behaviour is correct,
  As a software developer or security expert,
  I want to run automated attacks that will pass or fail.

  Scenario: List available attack steps
    Given an attack "nmap" exists
    When I run `gauntlt --list`
    Then it should pass with:
      """
      nmap
      """

  @slow
  Scenario: Run attack
    Given an attack "nmap" exists
    And a file named "nmap.attack" with:
    """
    Feature: my nmap attacks
      Scenario: nmap attack works
        Given "nmap" is installed
        And the target hostname is "google.com"
        When I launch an "nmap" attack with:
          \"\"\"
          nmap -p 80,443 <hostname>
          \"\"\"
        Then the output should contain:
          \"\"\"
          80/tcp  open  http
          443/tcp open  https
          \"\"\"
    """
    When I run `gauntlt`
    Then it should pass with:
    """
    4 steps (4 passed)
    """

  Scenario: Run attack with custom filename
    Given an attack "nmap" exists
    And a file named "my.awesome.attack.file" with:
    """
    Feature: my nmap attacks
      Scenario: nmap attack works
        Given "nmap" is installed
    """
    When I run `gauntlt my.awesome.attack.file`
    Then it should pass with:
    """
    1 step (1 passed)
    """

  Scenario: Run attack with undefined steps
    Given an attack "nmap" exists
    And a file named "nmap.attack" with:
    """
    Feature: my non-existent attack
      Scenario: Fail on undefined step definition
        Given "thisattackwouldneverexist" is installed
    """
    When I run `gauntlt`
    Then it should fail with:
    """
    Bad or undefined attack!
    """


  Scenario: No attack files in default path
    When I run `gauntlt`
    Then it should fail with:
    """
    No files found in path
    """

  Scenario: No attack files in specified path
    When I run `gauntlt apaththatdoesnotexist`
    Then it should fail with:
    """
    No files found in path: apaththatdoesnotexist
    """