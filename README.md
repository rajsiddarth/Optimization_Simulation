# Optimization & Simulation

## Genetic Algorithm
We will implement Genetic algorithm using the following problem statement and Data. Genetic algorithm involves three main steps

- Building the initial population also called as set of chromosomes

- Formulating fitness function for evaluation.(Tournament Selection/Roulette wheel Selection/Survival of the fittest)

- Reproduction using mutation or crossover(single -point splicing or multi point splicing) 

The code clearly shows all the steps anf the final model built with the help of individual helper functions.

### Problem Statement: 

You are going to spend a month in the wilderness. You're taking a backpack with you, however, the maximum weight it can carry is 80 kilograms. You have a number of survivalitems available, each with its own number of "survival points".Your objective is to maximize the number of survivalpoints while selecting the items. Use genetic algorithm to solve this.
#### Data:
- Items: "pocketknife", "beans", "potatoes", "onions", "phone", "lemons", "sleeping bag",
 "rope", "compass", "umbrella", "sweater", "medicines", "others"

- Survival Points: 15, 16, 13, 14, 20, 12, 17, 18, 17, 19, 10, 12, 11 in the respective order

- Weights: 5, 6, 3, 4, 11, 2, 7, 8, 10, 9, 1, 12, 11 in the respective order

## Simulated Annealing
Simulated Annealing can be compared with the annealing process in Metallurgy as the following:

- Metal == Problems
- Energy State == Cost Function
- Temperature == Control Parameter

Simulated Annealing starts with a higher temperature where we are likely to make wild moves and the system cools down according to our Annealing Schedule.When the system cools down the probalbility of accepting a smaller change is higher.We define the cost functions for our current solution,C(x) and new solution,C(x').The probability of acceptance is given by

- <a href="https://www.codecogs.com/eqnedit.php?latex=P_{accept}=\exp&space;[(C(x)-C(x'))/T]" target="_blank"><img src="https://latex.codecogs.com/gif.latex?P_{accept}=\exp&space;[(C(x)-C(x'))/T]" title="P_{accept}=\exp [(C(x)-C(x'))/T]" /></a>

### Problem Statement
We have 6 stocks with the returns and an amount of $100,000 to invest. The minimum investment in each stock should be 0.03 and the entire amount should be invested in the stocks maximizing the returns. We will start with the initial solution taking equal investment in each stock and then use the Simulated annealing to solve the problem

