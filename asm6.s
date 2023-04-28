# Author: Param Patel
# Course: CSc 252; Fall 22; Section #0
# Instructor: Russ Lewis
# File Name: asm6.s
# Purpose:

.data
DEBUG: .asciiz "DEBUG CURRENT COUNT: "
buffer: .space 20
WELCOME0: .asciiz "%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%"
WELCOME1: .asciiz  "%-%-%-%-%-%-%-%-%-%-%-%- WELCOME -%-%-%-%-%-%-%-%-%-%-%-%"
WELCOME2: .asciiz  "%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%\n"
NAME_ASK:  .asciiz "Enter your name: "
NAME_PRINT:  .asciiz "Hello, "
ASK_USER: .asciiz "Guess a number from 0 to 100: "
NOT_RIGHT: .asciiz  "Please guess again from 0 to 100: "
BORDER:.asciiz      "______________________________________"
HIGH: .asciiz " is too HIGH!"
LOW:.asciiz " is too LOW!"
INVALID_INT: .asciiz "Error: Integer Out of Range"
INVALID_INPUT: .asciiz "Error: Please type <\"yes\"> to play new game> OR <\"no\"> to exit."
CORRECT_GUESS:.asciiz "Your last guess was correct, You Win!"
GUESSED_1: .asciiz "It took you                                 # "
GUESSED_2: .asciiz " guesses.\n"
ASK_NEW_GAME:.asciiz "Would you like to play again? (<\"yes\"> or <\"no\">): "
YES: .asciiz "yes"
NO: .asciiz "no"
THANKS: .asciiz "Thank You For Playing My Game!"
BYE: .asciiz "Goodbye..."
fibspace:       .byte   ' '

.text
                                                                # Guessing Game

# This fucntion implements a number guessing game. It first asks the user for
# the his/her name. After promts the user to start guessing from 0 to 100. After each
# guess the the user gets to know if the guess is too low or too high. Also if the
# input's a integer that's negative or greater than 100. Counts as invalid and if it's
# not an integer tells them it's not correct. If the user gets the correct guess it tells
# them the number of guesses it took them to guess. After that user gets an option if
# they want to play again. If they say "yes" new game starts and if they say "no" ends
# the game.

# Extra MARS system calls used:
# 8 - Read String
# 10 - exit
# 42 - random int range

# Registers:
# t0 - guess counter to keep track of guesses user has made
# t1 - random number generated to comapre later
# t2 - number user as guessed
# t3 - 100
# t4 - buffer
# t5 - yes
# t6 - no
# t9 - name string

.globl guessGame
guessGame:
                                                                # Standard Prologue
    addiu   $sp,                $sp,            -24             # allocate stack space -- default of 24 here
    sw      $fp,                0($sp)                          # save caller frame pointer
    sw      $ra,                4($sp)                          # save return address
    addiu   $fp,                $sp,            20              # setup main frame pointer

START:
    jal     random                                              # jump to random and save position to $ra

    addi    $t1,                $a0,            0               # $t1 = $a0 + 0
    addi    $t0,                $zero,          0               # $t0 = $zero + 0


MAIN:
                                                                # printf("%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%")
    addi    $v0,                $zero,          4
    la      $a0,                WELCOME0
    syscall 
                                                                # printf("\n")
    addi    $v0,                $zero,          11              # print_char
    addi    $a0,                $zero,          0xa             # ASCII '\n'
    syscall 
                                                                # printf("%-%-%-%-%-%-%-%-%-%-%-%- WELCOME -%-%-%-%-%-%-%-%-%-%-%-%")
    addi    $v0,                $zero,          4
    la      $a0,                WELCOME1
    syscall 
                                                                # printf("\n")
    addi    $v0,                $zero,          11              # print_char
    addi    $a0,                $zero,          0xa             # ASCII '\n'
    syscall 
                                                                # printf("%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%")
    addi    $v0,                $zero,          4
    la      $a0,                WELCOME2
    syscall 
                                                                # printf("\n")
    addi    $v0,                $zero,          11              # print_char
    addi    $a0,                $zero,          0xa             # ASCII '\n'
    syscall 


# ask user for name prompt
    la      $a0,                NAME_ASK
    li      $v0,                4
    syscall 

# taking in string input
    li      $v0,                8                               # take in name input

# space
    la      $a0,                buffer                          # load byte space into address
    li      $a1,                20                              # allocate space for string

# save string to t9
    addi    $t9,                $a0,            0               # $t9 = $a0 + 0
    syscall 

# load and print name string
    la      $a0,                NAME_PRINT
    li      $v0,                4
    syscall 

# reload space to primary address
    la      $a0,                buffer

# primary address = t9 address (load pointer)
    addi    $a0,                $t9,            0               # $a0 = $t9 + 0

# print string
    li      $v0,                4
    syscall 

# printf("_______________________________________________________________")
    addi    $v0,                $zero,          4
    la      $a0,                BORDER
    syscall 
                                                                # printf("\n")
    addi    $v0,                $zero,          11              # print_char
    addi    $a0,                $zero,          0xa             # ASCII '\n'
    syscall 

# ask user for first guess
    li      $v0,                4
    la      $a0,                ASK_USER
    syscall 

    j       GUESS_CHECKS                                        # jump to GUESS_CHECKS

GAME_PROMPT:
    beq     $t0,                $zero,          MAIN            # if $t0 == $zero then goto MAIN
    j       NOT_RIGHT_GUESS                                     # jump to NOT_RIGHT_GUESS

NOT_RIGHT_GUESS:
                                                                # printf("_______________________________________________________________")
    add     $v0,                $zero,          4
    la      $a0,                BORDER
    syscall 
                                                                # printf("\n")
    addi    $v0,                $zero,          11              # print_char
    addi    $a0,                $zero,          0xa             # ASCII '\n'
    syscall 
                                                                # printf("Please guess again from 0 to 100: ")
    li      $v0,                4
    la      $a0,                NOT_RIGHT
    syscall 

    j       GUESS_CHECKS                                        # jump to GUESS_CHECKS

GUESS_CHECKS:
                                                                # users guessed number
    li      $v0,                5
    syscall 
                                                                # sets v0 to t2
    addi    $t2,                $v0,            0               # $t2 = $v0 + 0
                                                                # checks for the guessed number by the player
    slti    $t3,                $t2,            0               # $t3 = ($t2 < $zero) ? 1 : 0
    bne     $t3,                $zero,          NOT_IN_RANGE    # if $t3 != $zero then goto NOT_IN_RANGE
    beq     $t1,                $t2,            CORRECT_PRINT   # if $t1 == $t2 then goto CORRECT_PRINT

    addi    $t3,                $zero,          100             # $t3 = $zero + 100

    slt     $t3,                $t3,            $t2             # $t3 = ($t3 < $t2) ? 1 : 0
    bne     $t3,                $zero,          NOT_IN_RANGE    # if $t3 != $zero then goto NOT_IN_RANGE


    slt     $t3,                $t2,            $t1             # $t3 = ($t2 < $t1) ? 1 : 0
    bne     $t3,                $zero,          LESS            # if $t3 != $zero then goto LESS

    slt     $t3,                $t1,            $t2             # $t3 = ($t3 < $t1) ? 1 : 0
    bne     $t3,                $zero,          GREATER         # if $t3 != $zero then goto GREATER

    j       GUESS_GAME_END                                      # jump to GUESS_GAME_END


CORRECT_PRINT:

    addi    $t0,                $t0,            1
                                                                # printf("\n")
    addi    $v0,                $zero,          11              # print_char
    addi    $a0,                $zero,          0xa             # ASCII '\n'
    syscall 
                                                                # printf("_______________________________________________________________")
    addi    $v0,                $zero,          4
    la      $a0,                BORDER
    syscall 
                                                                # printf("\n")
    addi    $v0,                $zero,          11              # print_char
    addi    $a0,                $zero,          0xa             # ASCII '\n'
    syscall 
                                                                # printf("Your last guess was correct, You Win!")
    addi    $v0,                $zero,          4               # $v0 = $zero + 4
    la      $a0,                CORRECT_GUESS                   # correct guess
    syscall 
                                                                # printf("\n")
    addi    $v0,                $zero,          11              # print_char
    addi    $a0,                $zero,          0xa             # ASCII '\n'
    syscall 
                                                                # printf("It took you ")
    addi    $v0,                $zero,          4               # $v0 = $zero + 4
    la      $a0,                GUESSED_1
    syscall 
                                                                # prints the current total guesses
    addi    $v0,                $zero,          1
    add     $a0,                $zero,          $t0
    syscall 
                                                                # printf(" guesses.\n")
    addi    $v0,                $zero,          4               # $v0 = $zero + 4
    la      $a0,                GUESSED_2
    syscall 
                                                                # printf("_______________________________________________________________")
    addi    $v0,                $zero,          4
    la      $a0,                BORDER
    syscall 

    j       GUESS_GAME_END                                      # jump to GUESS_GAME_END

GREATER:
                                                                # prints the the number user has guessed
    addi    $v0,                $zero,          1               # int
    add     $a0,                $zero,          $t2             # prints out the users guess
    syscall 

# printf(" is too HIGH!")
    addi    $v0,                $zero,          4
    la      $a0,                HIGH
    syscall 

# printf("\n")
    addi    $v0,                $zero,          11              # print_char
    addi    $a0,                $zero,          0xa             # ASCII '\n'
    syscall 

# counter++ since it's guessed and greater than
    addi    $t0,                $t0,            1               # $t0 = $t0 + 1

    j       GAME_PROMPT                                         # jump to GAME_PROMPT

LESS:
                                                                # prints the the number user has guessed
    addi    $v0,                $zero,          1
    add     $a0,                $zero,          $t2
    syscall 

# printf(" is too LOW!")
    addi    $v0,                $zero,          4
    la      $a0,                LOW
    syscall 

# printf("\n")
    addi    $v0,                $zero,          11              # print_char
    addi    $a0,                $zero,          0xa             # ASCII '\n'
    syscall 

# counter++ since it's guessed and less than
    addi    $t0,                $t0,            1               # $t0 = $t0 + 1

    j       GAME_PROMPT                                         # jump to GAME_PROMPT

NOT_IN_RANGE:
                                                                # printf("Error: Integer Out of Range")
    addi    $v0,                $zero,          4
    la      $a0,                INVALID_INT
    syscall 
                                                                # printf("\n")
    addi    $v0,                $zero,          11              # print_char
    addi    $a0,                $zero,          0xa             # ASCII '\n'
    syscall 

    j       GAME_PROMPT                                         # jump to GAME_PROMPT

GUESS_GAME_END:
                                                                # printf("\n")
    addi    $v0,                $zero,          11              # print_char
    addi    $a0,                $zero,          0xa             # ASCII '\n'
    syscall 
                                                                # printf("Would you like to play a New Game? (yes or no): ")
    addi    $v0,                $zero,          4
    la      $a0,                ASK_NEW_GAME
    syscall 
                                                                # inputs for yes or no
    la      $a0,                buffer
    li      $a1,                4
                                                                # read string
    li      $v0,                8
    syscall 
                                                                # printf("\n")
    addi    $v0,                $zero,          11              # print_char
    addi    $a0,                $zero,          0xa             # ASCII '\n'
    syscall 

# input for yes or no
    la      $t4,                buffer                          # t4 = &buffer
    lb      $t4,                0($t4)                          # t4 = buffer

    la      $t5,                YES                             # t5 = &YES
    lb      $t5,                0($t5)                          # t5 = YES

    la      $t6,                NO                              # t6 = &NO
    lb      $t6,                0($t6)                          # t6 = NO

    beq     $t4,                $t5,            RESTART         # if $t4 == $t5 then goto START_NEW_GAME
    beq     $t4,                $t6,            SYS_EXIT        # if $t4 == $t6 then goto END

    j       NON_INT                                             # jump to NON_INT

NON_INT:
                                                                # printf("Invalid Input, please type (yes play new game ) or (no to exit)")
    add     $v0,                $zero,          4
    la      $a0,                INVALID_INPUT
    syscall 

    j       GUESS_GAME_END                                      # jump to GUESS_GAME_END

RESTART:
                                                                # printf("\n")
    addi    $v0,                $zero,          11              # print_char
    addi    $a0,                $zero,          0xa             # ASCII '\n'
    syscall 

    j       START                                               # jump to START

SYS_EXIT:
                                                                # printf("Thank You For Playing My Game!")
    li      $v0,                4
    la      $a0,                THANKS
    syscall 
                                                                # printf("\n")
    addi    $v0,                $zero,          11              # print_char
    addi    $a0,                $zero,          0xa             # ASCII '\n'
    syscall 
                                                                # printf("Goodbye...")
    li      $v0,                4
    la      $a0,                BYE
    syscall 
                                                                # printf("\n")
    addi    $v0,                $zero,          11              # print_char
    addi    $a0,                $zero,          0xa             # ASCII '\n'
    syscall 
                                                                # terminate the code
    li      $v0,                10
    syscall 

# Standard Epilogue
    lw      $ra,                4($sp)                          # get return address from stack
    lw      $fp,                0($sp)                          # restore the callers frame pointer
    addiu   $sp,                $sp,            24              # restore the callers stack pointer
    jr      $ra                                                 # return to callers code


# Seed a Random Number

.globl random
random:
                                                                # Standard Prologue
    addiu   $sp,                $sp,            -24             # allocate stack space -- default of 24 here
    sw      $fp,                0($sp)                          # save caller frame pointer
    sw      $ra,                4($sp)                          # save return address
    addiu   $fp,                $sp,            20              # setup main frame pointer

# upper bound for the random number
    addi    $a1,                $zero,          101             # a1 = 101
    addi    $v0,                $zero,          42              # $v0 = $zero + 42
    syscall 
    addi    $a0,                $a0,            0               # $a0 = $a0 + 0

# Standard Epilogue
    lw      $ra,                4($sp)                          # get return address from stack
    lw      $fp,                0($sp)                          # restore the callers frame pointer
    addiu   $sp,                $sp,            24              # restore the callers stack pointer
    jr      $ra                                                 # return to callers code