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
def main_sentence_builder():
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


# Imported partial code for make_sentence
def make_sentence(quantity, tense):
    # This calls the defined functions to build a semblance of a sentence.
    determiner = get_determiner(quantity)
    noun = get_noun(quantity)
    verb = get_verb(quantity, tense)

    # Now, it outputs a randomized string, with some grammar built in:
    print(f"{determiner.capitalize()} {noun} {verb}.")


# This call the defined main program.
main_sentence_builder()
