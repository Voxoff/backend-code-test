First I passed through the discount classes and applied obvious refactors - those
that would still be helpful for the new features. Then I introduced the new mango discount.

The hardest part was interpreting what 'applying discounts from the database' meant.
Considering the line above mandated the DB should store the 'type of discount and the item to which it applies',
I stored only this in the DB, read the type and used that to calculate the discount. (I hope that's what you meant!)
