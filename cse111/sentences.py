# Written by Harrison Merrill 1/23/25 CSE111

# Problem Statement:
# The Turing test, named after Alan Turing, is a test of a computer’s ability to make conversation that is
# indistinguishable from human conversation. A computer that could pass the Turing test would need to understand
# sentences typed by a human and respond with sentences that make sense.
# >
# In English and many other languages, grammatical quantity (also known as grammatical number) is an
# attribute of nouns, pronouns, adjectives, and verbs that expresses count distinctions, such as
# “one”, “two”, “some”, or “many”. The grammatical quantity of the words in a sentence must match.
# In English, there are two categories of grammatical quantity: single and plural. For example,
# here are three English sentences that contain single nouns, pronouns, and verbs:
# >  The boy laughs.
# >  One dog eats.
# >  She drinks water.
# Here are three English sentences that contain plural nouns, pronouns, and verbs:
# >  Two birds fly.
# >  Some animals eat.
# >  Many cars drive.
# Grammatical tense is an attribute of verbs that expresses when an action happened.
# Many languages include past, present, and future tenses. For example, here are three English sentences,
# the first with past tense, the second with present tense, and the third with future tense:
# >  The cat walked.
# >  The cat walks.
# >  The cat will walk.

# Assignment:
# Write a Python program named sentences.py that generates simple English sentences. During this prove milestone,
# you will write functions that generate sentences with three parts:
# >  a determiner (sometimes known as an article)
# >  a noun
# >  a verb
# For example:
# >  A cat laughed.
# >  One man eats.
# >  The woman will think.
# >  Some girls thought.
# >  Many dogs run.
# >  Many men will write.
# For this milestone, your program must include at least these five functions:
# >  main
# >  make_sentence
# >  get_determiner
# >  get_noun
# >  get_verb
# You may add other functions if you want. The functions get_determiner, get_noun, and get_verb, must
# randomly choose a word from a list of words and return the randomly chosen word. All the functions that
# you must write for this milestone assignment are described in the Steps section below.

# This is an existing random module, tainted by the frenzied flame of chaos
import random


# This function actually builds the sentence, using other defined functions
def main():
    while True:
        # First, it asks the user if they want to see an example, or input their own values
        print(
            "Welcome to CSE111 sentence_builder. Would you like to build your own sentence or see some examples?"
        )
        user_choice()
        # Then, it asks the user if it would like to run the program again, or quit out
        again = run_again()
        # If they want to run the program again, this will continue the loop.
        if again.lower() in ("yes", "y", "yup", "yeah", "sure"):
            continue
        # If they do not want to run the program again, this will break the loop.
        else:
            # This is the exit message for the loop.
            print("Thank you. Goodbye!")
            break


def run_again():
    # This will ask the user if they want to run the program again, and validates if they put in a weird answer.
    while True:
        again = input("Would you like to run this program again? (yes/no): ")
        if again.lower() in ("yes", "no", "y", "n", "yup", "yeah", "sure", "nope"):
            return again.lower()
        else:
            print("I don't understand. Please enter 'yes' or 'no'.")
            # This saves the error word the user wrote, so we can detect patterns for future versions.
            with open("input_error.txt", "at") as input_error_file:
                input_error_file.write(f"Error input word used: '{again}'\n")


def user_choice():
    user_response = input(
        "Enter 'Yes' or 'Y' to build your own, or type anything else to see a sample: "
    )
    if user_response.lower in ("yes", "y"):
        user_sentence_builder()
    else:
        test_sentence_builder()


# If the user wants an example, this spits out a few phrases automatically.
def test_sentence_builder():
    make_sentence(quantity=1, tense="past")
    make_sentence(quantity=1, tense="present")
    make_sentence(quantity=1, tense="future")
    make_sentence(quantity=2, tense="past")
    make_sentence(quantity=2, tense="present")
    make_sentence(quantity=2, tense="future")


# This function has the user select their own values for the quantity and tense of the sentence
def user_sentence_builder():
    # This has the user select a quantity, and validates their response against a default.
    quantity = int(input("Please enter a number: "))
    if quantity <= 0:
        print("Value not positive, defaulting selection to 1")
        quantity = 1

    # This has the user select a verb tense, and validates their response against a default.
    tense = input("Please enter a tense (past/present/future): ")
    if tense.lower() not in (
        "present",
        "past",
        "future",
    ):
        print("I dont understand. I will default this answer to present tense.")
        tense = "present"

    make_sentence(quantity, tense)


# This function chooses the determiner based on the quantity.
def get_determiner(quantity):
    # This array stores options for the function to return
    if quantity == 1:
        determiner_words = [
            "a",
            "one",
            "the",
            "a single",
            "the only",
            "a solo",
            "alone, the",
            "my",
            "your",
            "this",
            "that",
            "no",
        ]
    else:
        determiner_words = [
            "some",
            "many",
            "the",
            "lots of",
            "several",
            "a few",
            "a great many",
            "together, the",
            "my",
            "our",
            "these",
            "those",
            "no",
        ]

    # Randomly choose and returns a determiner.
    determiner_choice = random.choice(determiner_words)
    return determiner_choice


# This function chooses the noun based on the quantity.
def get_noun(quantity):
    # This array stores options for the function to return
    if quantity == 1:
        noun_words = [
            "bird",
            "boy",
            "car",
            "cat",
            "child",
            "dog",
            "girl",
            "man",
            "rabbit",
            "woman",
            "snake",
            "goose",
            "cup of tea",
            "native",
            "tourist",
            "sibling",
            "book",
            "megabit",
            "airman",
            "song",
        ]
    else:
        noun_words = [
            "birds",
            "boys",
            "cars",
            "cats",
            "children",
            "dogs",
            "girls",
            "men",
            "rabbits",
            "women",
            "snakes",
            "geese",
            "tea sets",
            "native people",
            "tourists",
            "siblings",
            "libraries",
            "terabytes",
            "e4 mafia",
            "muses",
        ]

    # Randomly choose and returns a determiner.
    noun_choice = random.choice(noun_words)
    return noun_choice


# Imported partial code for get_verb
def get_verb(quantity, tense):
    # This returns a past verb if the tense is past, a future verb if the tense is yet to come,
    # or a singular/plural present verb if the tense is present
    if tense.lower() == "past":
        verb_words = [
            "drank",
            "ate",
            "grew",
            "laughed",
            "thought",
            "ran",
            "slept",
            "talked",
            "walked",
            "wrote",
            "flew",
            "pondered",
            "leapt",
            "cleaned",
            "organized",
            "became intelligent",
            "was strong",
            "broke it",
            "broke down",
        ]
    elif tense.lower() == "future":
        verb_words = [
            "will drink",
            "will eat",
            "will grow",
            "will laugh",
            "will think",
            "will run",
            "will sleep",
            "will talk",
            "will walk",
            "will write",
            "will fly",
            "will shortly ponder",
            "will leap",
            "will clean",
            "will organize",
            "will gain intelligence",
            "is getting stronger",
            "will break it",
            "will break down",
        ]
    elif quantity == 1:  # This array is present tense
        verb_words = [
            "drinks",
            "eats",
            "grows",
            "laughs",
            "thinks",
            "runs",
            "sleeps",
            "talks",
            "walks",
            "writes",
            "flies",
            "ponders",
            "leaps",
            "cleans",
            "organizes",
            "is intelligent",
            "is strong",
            "is breaking it",
            "is breaking down",
        ]
    else:
        verb_words = [  # This array is also present tense
            "drink",
            "eat",
            "grow",
            "laugh",
            "think",
            "run",
            "sleep",
            "talk",
            "walk",
            "write",
            "fly",
            "ponder",
            "leap",
            "organize",
            "are intelligent",
            "are strong",
            "are breaking it",
            "are breaking down",
        ]

    # Randomly choose and returns a determiner.
    verb_choice = random.choice(verb_words)
    return verb_choice


# Add get_preposition array:
def get_preposition():
    preposition_words = [
        "at",
        "on",
        "in",
        "before",
        "around",
        "after",
        "to",
        "from",
        "out of",
        "across",
        "by",
        "like",
        "with",
        "through",
        "outside",
        "underneath",
        "about",  # Realize at this point that some words were given in the assignment
        "above",
        "across",
        "along",
        "behind",
        "beyond",
        "despite",
        "except",
        "for",
        "near",
        "past",
        "without",
    ]
    # Randomly chooses and returns a preposition.
    preposition_choice = random.choice(preposition_words)
    return preposition_choice


# Bank of adjectives to choose from.
def get_adjective():
    adjective_words = [
        "adorable",
        "deplorable",
        "big",
        "sunburnt",
        "crazy",
        "dirty",
        "exotic",
        "famous",
        "gentle",
        "happy",
        "irrelevant",
        "junior",
        "well-known",
        "loud",
        "mischievous",
        "neat",
        "offensive",
        "priceless",
        "quirky",
        "quiet",
        "royal",
        "silent",
        "tiny",
        "unusual",
        "vicious",
        "wholesome",
        "yummy",
        "zealous",
    ]
    # randomly chooses and returns an adjective.
    adjective_choice = random.choice(adjective_words)
    return adjective_choice


# Randomly decides if something extra should be added
def random_inclusion():
    answer = [True, False]
    random_answer = random.choice(answer)
    return random_answer


# Build a prepositional phrase from a preposition, determiner, and noun.
def get_prepositional_phrase(quantity):
    preposition = get_preposition()
    determiner = get_determiner(quantity)
    noun = get_noun(quantity)
    adjective_answer = random_inclusion()

    # Now, it outputs a randomized prepositional phrase to add to the sentence.
    if adjective_answer == False:
        prepositional_phrase = f"{preposition} {determiner} {noun}"
        return prepositional_phrase
    else:
        adjective = get_adjective()
        prepositional_phrase = f"{preposition} {determiner} {adjective} {noun}"
        return prepositional_phrase


# Imported partial code for make_sentence
def make_sentence(quantity, tense):
    # This calls the defined functions to build a semblance of a sentence.
    determiner = get_determiner(quantity)
    noun = get_noun(quantity)
    verb = get_verb(quantity, tense)
    prepositional_phrase = get_prepositional_phrase(quantity)
    adjective_answer = random_inclusion()

    # Now, it outputs a randomized string, with some grammar built in:
    if adjective_answer == False:
        result_sentence = (
            f"{determiner.capitalize()} {noun} {verb} {prepositional_phrase}."
        )
        print(result_sentence)
    else:
        adjective = get_adjective()
        result_sentence = f"{determiner.capitalize()} {adjective} {noun} {verb} {prepositional_phrase}."
        print(result_sentence)


# This call the defined main program.
main()
