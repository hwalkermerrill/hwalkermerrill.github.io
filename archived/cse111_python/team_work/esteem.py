# Written By: Case, Harrison, and Joshua; CSE111

# Problem Statement:
# The Rosenberg self-esteem scale is a self-esteem measure developed by the sociologist
# Morris Rosenberg in 1965. It is still used in social-science research today. To complete
# the measure, a person completes a survey that contains the following ten statements:
# >
# 1. I feel that I am a person of worth, at least on an equal plane with others.
# 2. I feel that I have a number of good qualities.
# 3. All in all, I am inclined to feel that I am a failure.
# 4. I am able to do things as well as most other people.
# 5. I feel I do not have much to be proud of.
# 6. I take a positive attitude toward myself.
# 7. On the whole, I am satisfied with myself.
# 8. I wish I could have more respect for myself.
# 9. I certainly feel useless at times.
# 10. At times I think I am no good at all.
# >
# The person responds to each statement by choosing one of these four options:
# > strongly disagree, disagree, agree, or strongly agree.
# The person’s response to each statement is worth 0–3 points, meaning the highest
# possible score is 10 * 3 = 30 points. If a person scores lower than 15 points,
# the person may have a problematic low self-esteem.

# Notice that five of the statements (numbers 1, 2, 4, 6, 7) are positive and are scored
# like this:

# Choice	Points
# Strongly Disagree	0
# Disagree	1
# Agree	2
# Strongly Agree	3

# The other five statements (numbers 3, 5, 8, 9, 10) are negative and are scored
# like this:

# Choice	Points
# Strongly Disagree	3
# Disagree	2
# Agree	1
# Strongly Agree	0

# Assignment:
# As a team, write a Python program named esteem.py that implements the Rosenberg
# self-esteem scale. Your program must ask the user to respond to each of the ten
# statements with D, d, a, or A which mean strongly disagree, disagree, agree, and
# strongly agree. Your program must compute the score for each answer and sum and
# display the person’s total score. You should think about how you will separate this
# program into functions before you begin writing the program.

# Core Requirements:
# 1. Your program prints the introductory text as shown in the Testing Procedure section below.
# 2. Your program prints each of the ten statements and gets a response from the user.
# 3. Your program computes the score for each response and sums all the scores and
# displays the total score.


def main():
    # Introduction
    print("Welcome to the Rosenberg Self-Esteem Scale")
    print(
        "This scale is a self-esteem measure developed by the sociologist Morris Rosenberg in 1965."
    )
    print("It is still used in social-science research today.")
    print(
        "To complete the measure, you will respond to each of the following ten statements."
    )
    print(
        "Please respond to each statement with D, d, A, or a which mean strongly disagree, disagree, agree, and strongly agree."
    )
    print()
    # List of statements
    statements = [
        "I feel that I am a person of worth, at least on an equal plane with others.",
        "I feel that I have a number of good qualities.",
        "All in all, I am inclined to feel that I am a failure.",
        "I am able to do things as well as most other people.",
        "I feel I do not have much to be proud of.",
        "I take a positive attitude toward myself.",
        "On the whole, I am satisfied with myself.",
        "I wish I could have more respect for myself.",
        "I certainly feel useless at times.",
        "At times I think I am no good at all.",
    ]
    # List of scores
    scores = [3, 2, 1, 0]
    # Initialize total score
    total_score = 0
    # Loop through statements
    for i in range(10):
        # Print statement
        print(f"Statement {i+1}: {statements[i]}")
        # Get user response
        response = input("Response (D/d/A/a): ")
        # Check response and add score to total score
        if response in ("D", "d"):
            total_score += scores[0]
        elif response in ("A", "a"):
            total_score += scores[3]
        elif response == "a":
            total_score += scores[2]
        elif response == "D":
            total_score += scores[1]
    # Print total score
    print(f"Your total score is: {total_score}")

    # Evaluation of scores below 15
    if total_score < 15:
        print("You may have a problematic low self-esteem.")
    else:
        print("You have a healthy self-esteem.")


if __name__ == "__main__":
    main()
