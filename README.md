# Assembly-RandomInt-and-Sort #
This program takes user input for an array length and generates an array of random numbers from 100 to 999 that are displayed both as generated, after sorting, and the list's median.

## Design ##
Introduction of Reusable Procedures:
* Both the list writing and message printing functions are designed for reusability throughout the program.

Input Validation:
* User input is accepted for number ranges and validated before use.

Variable Addressing:
* Parameters are passed to procedures by reference which are both handled on the stack and cleaned up upon termination.
* Array elements are accessed with register indirect addressing.
