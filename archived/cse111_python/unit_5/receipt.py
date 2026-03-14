# Written by Harrison Merrill 3/07/25 CSE111

# Problem Statement:
# A local grocery store subscribes to an online service that enables its customers
# to order groceries online. After a customer completes an order, the online service
# sends a CSV file that contains the customer’s requests to the grocery store.
# The store needs you to write a program that reads the CSV file and prints to the
# terminal window a receipt that lists the purchased items and shows the subtotal,
# the sales tax amount, and the total.

# Imports
import csv
from decimal import Decimal
from datetime import datetime

# import sys

# Constants
STORE_NAME = "Merrily Shopping"
SIGNATURE_LINE = "Thank you for shopping with us! Have a great day!"
SALES_TAX = 6
current_date_and_time = datetime.now()


def read_dictionary(filename, key_column_index):
    """Read the contents of a CSV file into a compound
    dictionary and return the dictionary.

    Parameters
            filename: the name of the CSV file to read.
            key_column_index: the index of the column
                    to use as the keys in the dictionary.
    Return: a compound dictionary that contains
            the contents of the CSV file.
    """
    output_dict = {}

    try:
        with open(filename, mode="r") as file:
            reader = csv.reader(file)
            next(reader)  # Skip header row

            for row in reader:
                try:
                    key = row[key_column_index]
                    value = [row[0], row[1], Decimal(row[2])]
                    output_dict[key] = value  # Write values into dictionary
                except (IndexError, ValueError) as error:
                    continue  # Skip badly formatted rows, intentionally printing nothing
                    # on the receipt to add error messages on receipts that do not contain
                    # that item. If their purchase does contain the item, this will be
                    # reported later anyway.
        return output_dict

    except FileNotFoundError:
        print(f"File {filename} not found. Please check the filename and try again.")
        return
        # sys.exit(1)


def read_request(
    request, products_dict, sales_tax_percentage=6, special_discounts=None
):
    subtotal = 0
    total_count = 0
    discount_total = 0

    try:
        with open(request, mode="r") as file:
            reader = csv.reader(file)
            next(reader)  # Skip header row

            print("\nRequested Products: ")
            for row in reader:
                try:
                    product_number = row[0]
                    quantity = int(row[1])
                except (IndexError, ValueError) as error:
                    print(f"Error processing row {row}: {error}")
                    continue  # Skip to next row

                total_count += quantity

                try:
                    # cross-reference request with products_dict
                    product_details = products_dict[product_number]
                    product_name = product_details[1]
                    product_price = Decimal(product_details[2])
                    product_line_cost = product_price * (quantity)
                    subtotal += product_line_cost

                    # Prints Receipt Line based on quantity
                    if quantity == 1:
                        print(f"{product_name}: ${product_price:.2f}")
                    else:
                        print(
                            f"{quantity} {product_name}: ${product_line_cost:.2f} (${product_price:.2f} each)"
                        )
                except KeyError:
                    print(
                        f"Product number {product_number} not found. Please see cashier."
                    )
                    continue  # Skip to next row
                except (IndexError, ValueError) as error:
                    print(
                        f"Error retrieving product data for {product_number}: {error}"
                    )
                    continue  # Skip to next row

                # Check for special discounts
                if special_discounts is not None:
                    if product_number in special_discounts:
                        try:
                            discount_details = special_discounts[product_number]
                            sale_price = Decimal(discount_details[2])
                            sale_line_cost = sale_price * quantity
                            savings_amount = sale_line_cost - product_line_cost
                            subtotal += savings_amount
                            discount_total += savings_amount

                            if quantity == 1:
                                print(
                                    f"Sale Price: ${sale_price:.2f}, Total ${savings_amount:.2f}!"
                                )
                            else:
                                print(
                                    f"Sale Price: ${sale_price:.2f} each, Total ${savings_amount:.2f}!"
                                )

                        except (IndexError, ValueError) as error:
                            continue  # Skip to next row

        sales_tax = subtotal * (Decimal(sales_tax_percentage) / 100)
        total = subtotal + sales_tax

        # Print a blank line for readability.
        print()

        # Print the receipt
        print(f"Number of Items: {total_count}")
        print(f"Subtotal: ${subtotal:.2f}")
        if discount_total < 0:
            print(f"YOU SAVED: ${abs(discount_total):.2f}!")
        print(f"Sales tax: ${sales_tax:.2f}")
        print(f"Total: ${total:.2f}")

    except FileNotFoundError:
        print(f"File {request} not found. Please check the filename and try again.")
        return


def main():
    # Print a blank line for readability.
    print()

    # Print store name at the top of the receipt
    print(f"{STORE_NAME}")

    filename = "products.csv"
    key_column_index = 0
    products_dict = read_dictionary(filename, key_column_index)
    if products_dict is None:
        print()
        print("We're sorry, but we are having technical difficulties at the moment.")
        print(
            "Please present this receipt to the manager who can manually check you out with a 20% discount on your entire purchase."
        )
        print()
        print(f"{SIGNATURE_LINE}")
        print(f"{current_date_and_time:%A %I:%M %p}")
        return  # Exit program if products can't be loaded

    # Print dictionary for debugging - COMMENT OUT WHEN DONE
    # print("Products Dictionary: ", products_dict)

    # Attempt to read the special_discounts.csv file. If it cannot be read,
    # the program will continue without it.
    discount_filename = "special_discounts.csv"
    special_discounts = read_dictionary(discount_filename, key_column_index)

    # Open request.csv
    request = "request.csv"
    read_request(
        request,
        products_dict,
        sales_tax_percentage=SALES_TAX,
        special_discounts=special_discounts,
    )

    # Print a blank line for readability.
    print()

    print(f"{SIGNATURE_LINE}")
    print(f"{current_date_and_time:%A %I:%M %p}")


# Standard convention for running program, while leaving place for validation tests.
if __name__ == "__main__":
    main()
