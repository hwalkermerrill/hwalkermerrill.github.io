package GroupFinal;

import java.util.Scanner;

public class Main {

    public static double cheese(){
        // This space under construction
        double price = 7.95;
        return price;
    }

    public static double bbqChicken(){
        // This space under construction
        double price = 8.95;
        return price;
    }

    public static double margarita(){
        // This space under construction
        double price = 8.95;
        return price;
    }

    public static double pepperoni(){
        // This space under construction
        double price = 8.95;
        return price;
    }

    public static double meatLovers(){
        // This space under construction
        double price = 9.95;
        return price;
    }

    public static double supreme(){
        // This space under construction
        double price = 9.95;
        return price;
    }

    public static double subtotal(double total){
        double taxPercentage = 6;
        double salesTax = Math.round(total * taxPercentage)/100;
        double subtotal = total + salesTax;
        return subtotal;
    }

    public static void main(String[] args) {
        // Defines variables for future use.
        double total = 0; int orderCount = 0; int finish = 0; double price = 0; double donation = 0; double donationOffer = 0;

        // Welcome Message to Customer
        System.out.println("Welcome to Costello's Pizza Parlor,");
        System.out.println("The Cleanest* Student-Run Pizza Parlor on Campus");
        System.out.println("Remember, You Can't Spell Non-Costly without a Slice of Costello's!");
        System.out.println(" ");

        // Allows the customer to enter a name.
        Scanner input = new Scanner(System.in);
        System.out.print("Please enter a name for you order: ");
        String cName = input.next();
        System.out.println(" ");

        // Shows the customer the available menu
        System.out.println("Welcome, " + cName);
        System.out.println("Our available Pizza's and their Prices today are: ");
        System.out.println("1) Cheese        $7.95");
        System.out.println("2) BBQ Chicken   $8.95");
        System.out.println("3) Margarita     $8.95");
        System.out.println("4) Pepperoni     $8.95");
        System.out.println("5) Meat Lovers   $9.95");
        System.out.println("6) Supreme       $9.95");
        System.out.println(" ");

        // Begins ordering process loop
        while (finish < 1) {
            System.out.print("Please enter a number (1-6) to select the pizza of your choice: ");
            int pizza = input.nextInt();
            String pizzaName;

            // Uses switch case to translate user input into a pizza type
            switch (pizza) {
                case 1:
                    pizzaName = "Cheese";
                    break;
                case 2:
                    pizzaName = "BBQ Chicken";
                    break;
                case 3:
                    pizzaName = "Margarita";
                    break;
                case 4:
                    pizzaName = "Pepperoni";
                    break;
                case 5:
                    pizzaName = "Meat Lovers";
                    break;
                case 6:
                    pizzaName = "Supreme";
                    break;
                default:
                    pizzaName = "Invalid Entry";
                    break;
            }
            System.out.println(" ");

            // Uses data validation to continue ordering process in the event an invalid number is entered.
            if (pizzaName == "Invalid Entry") {
                System.out.println("That is not a valid pizza order. ");
            } // Allows the customer to confirm their selection.
            else {
                System.out.println("You have selected a " + pizzaName + " pizza. Would you like to add one to your order?");
                System.out.print("Please type 1 for yes or any other number for no. ");
                int confirmOrder = input.nextInt();
                if (confirmOrder == 1) {
                    orderCount += 1;
                    // Adds the pizza and its price to the order current order total.
                    switch (pizza) {
                        case 1:
                            price = cheese();
                            break;
                        case 2:
                            price = bbqChicken();
                            break;
                        case 3:
                            price = margarita();
                            break;
                        case 4:
                            price = pepperoni();
                            break;
                        case 5:
                            price = meatLovers();
                            break;
                        case 6:
                            price = supreme();
                            break;
                    } // RECEIPT UNDER CONSTRUCTION
                    total += price;
                    // Allows the customer to make their selection a large.
                    System.out.println(" ");
                    System.out.println("Would you like to make that a large " + pizzaName + " for an extra $2.00?");
                    System.out.print("Please type 1 for yes or any other number for no. ");
                    int largeOrder = input.nextInt();
                    if (largeOrder == 1) {
                        total += 2;
                        //RECEIPT UNDER CONSTRUCTION
                    }
                }
            } // Allows the customer to add to their order or close the ordering loop.
            System.out.println(" ");
            System.out.println("You have ordered " + orderCount + "pizza's, and your current total is $" + subtotal(total) + ".");
            System.out.println("Would you like to order any other pizza's?");
            System.out.print("Please type 1 for yes or any other number for no. ");
            int continueShopping = input.nextInt();
            if (continueShopping != 1) {
                finish += 1;
            }
        }// Offers for the user to make their order a combo.
        System.out.println(" ");
        System.out.println("Would you like to add a 2-liter of Mountain Dew (tm) and 6 breadsticks with marinara sauce to your order for an extra $3.00?");
        System.out.print("Please type 1 for yes or any other number for no. ");
        int comboOrder = input.nextInt();
        if (comboOrder == 1) {
            total += 3;
            //RECEIPT STILL UNDER CONSTRUCTION
        } // Presents the customer with their current total and offers the chance to donate their change to the Church of Jesus Christ of Latter-day Saints Perpetual Education Fund
        System.out.println(" ");
        System.out.println("You have ordered " + orderCount + " pizza's, and your current total is $" + subtotal(total) + ". ");
        if (subtotal(total) % 1 == 0) {
            donationOffer += 1;
        } else {
            donationOffer += subtotal(total) % 1;
        }

        System.out.println("Would you like to donate $" + donationOffer + " to the Church of Jesus Christ of Latter-Day Saints Perpetual Education Fund?");
        System.out.print("Please type 1 for yes or any other number for no. ");
        int donateOrder = input.nextInt();
        if (donateOrder == 1) {
            donation += donationOffer;
            System.out.println(" ");
            System.out.println("Thank you for your donation! Donation's from people like you help thousands of people receive a higher education!");
        }
        //RECEIPT STILL UNDER CONSTRUCTION
        //Prints closing signature lines.
        System.out.println(" ");
        System.out.println("Thank you for Buying from Costello's Pizza Parlor!");
        System.out.println("You will be redirected momentarily to our Secured Payment Processor and your order will be sent to the Costello's Pizza Parlor for processing!");
        System.out.println("Your pizza(s) will be ready for pickup in 10-140 minutes.");
        System.out.println("Remember, You Can't Spell Non-Costly without a Slice of Costello's!");
    }
}
