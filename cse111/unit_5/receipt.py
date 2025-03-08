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
    products_dict = {}

    with open(filename, mode="r") as file:
        reader = csv.reader(file)
        next(reader)  # Skip header row

        for row in reader:
            key = row[key_column_index]
            value = [row[0], row[1], float(row[2])]
            products_dict[key] = value  # Write values into dictionary

    return products_dict


def read_request(request, products_dict, sales_tax_percentage=0):
    subtotal = 0

    with open(request, mode="r") as file:
        reader = csv.reader(file)
        next(reader)  # Skip header row

        print("\nRequested Products: ")
        for row in reader:
            product_number = row[0]
            quantity = int(row[1])

            # cross-reference request with products_dict
            if product_number in products_dict:
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
            else:
                print(f"Product number {product_number} not found. Please see cashier.")

    sales_tax = subtotal * (Decimal(sales_tax_percentage) / 100)
    total = subtotal + sales_tax

    # Print a blank line for readability.
    print()

    print(f"Subtotal: ${subtotal:.2f}")
    print(f"Sales tax: ${sales_tax:.2f}")
    print(f"Total: ${total:.2f}")


def main():
    filename = "products.csv"
    key_column_index = 0
    products_dict = read_dictionary(filename, key_column_index)

    # Print dictionary for debugging
    print("Products Dictionary: ", products_dict)

    # Open request.csv
    request = "request.csv"
    read_request(request, products_dict)

    # Print a blank line for readability.
    print()

    print("Thank you for shopping with us! Have a great day!")


# Standard convention for running program, while leaving place for validation tests.
if __name__ == "__main__":
    main()
