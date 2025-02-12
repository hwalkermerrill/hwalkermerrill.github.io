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
