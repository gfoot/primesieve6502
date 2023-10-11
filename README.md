# Prime sieve implementation for 6502

On my 6502 system running at 32.768MHz this finds all the primes up to about 950,000 in about 1.3 seconds.

It uses mod-30 repetition to pack the bitfield and accelerate its operation somewhat.

For any prime p greater than 5, the remainder on division by 30 will be within the set {1,7,11,13,17,19,23,29} 
because the other numbers are all multiples of divisors of 30.  So we only need to store bits for these 
remainders.  One byte is enough to cover 30 prime candidates, eight of which have appropriate remainders, 
each getting one bit within the byte.  This direct correspondence to bytes allows some other tricks within
the code to make it run faster, especially when updating the sieve.

The sieve ends up looking like this:


  address    base      bit 7  bit 6  bit 5  bit 4  bit 3  bit 2  bit 1  bit 0
     0         0         1      7     11     13     17     19     23     29
     1        30        31     37     41     43     47     49     53     59
     2        60        61     67     71     73     77     79     83     89
    ...
     7       210       211    217    221    223    227    229    233    239
     8       240        .      .      .      .      .     289     .      .
    ...
    11       330        .      .     341     .      .      .      .      .


Note that each memory address represents values 30 higher than the previous
one.  For any prime p, it occurs on row (p div 30) of the table.  e.g. 7 is in
row 0, 341 is in row 341 div 30 = 11.  For any entry x in the table, the entry
p rows later represents x+30p which is clearly a multiple of p iff x is a
multiple of p.  e.g. p=7,address=1,bit=2 - x=49, a multiple of 7; and 7 rows
later, at address 8, bit 2 represents 289 which is also a multiple of p.

As p and 30 are coprime, every possible remainder mod p will appear within p rows on any column.

So after finding a prime p in row n, to update the sieve we need to scan the next p rows of the table,
and expect to find one entry in each column which is a multiple of p.  When we find it, we can loop 
over the whole of the rest of the sieve, in steps of p, setting the corresponding bits to mark those
numbers as non-prime, and this will find all multiples of p in the sieve.

There are more notes on this in the source code.

As shared, the code doesn't print out all the primes, only how many it found and what number it counted up to, and 
how long it took.  You can define VERBOSE to make it instead print all the primes as it finds them, but of course 
this is much slower.

The code is written for the xa assembler.

