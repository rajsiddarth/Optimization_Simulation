rm(list=ls(all=TRUE))

#Creating a data frame for the given problem
data = data.frame(item = c("pocketknife", "beans", "potatoes", 
                              "onions", "phone", "lemons",
                              "sleeping bag", "rope", "compass",
                              "umbrella", "sweater", "medicines", "others"), 
                     survivalpoints = c(15, 16, 13, 14, 20, 12, 17, 
                                        18, 17, 19, 10, 12, 11), 
                     weight = c( 5, 6, 3, 4, 11, 2, 7, 
                                 8, 10, 9, 1, 12, 11))
#Given weight limit
weightlimit = 80

#..........................Step-1.......................................#
# Initial population generation
#1 represents the object s selected and 0 represents the object is not selected
#Each row in the initial population will be a combination of items.We call them 
# as chromosome

fnGenerateInitPop = function(dataset){
  
  InitPopSize = 1000
  
  initPop = as.data.frame(setNames(replicate(nrow(dataset),
                                             numeric(0), 
                                             simplify = F), 
                                   dataset$item))
  
  set.seed(123)
  
#Generating chromosomes for population
  for (i in 1:InitPopSize){
    chromosome = sample(0:1, nrow(dataset), replace=TRUE)
    initPop[i,]= chromosome
  }
  
  return(initPop)
}

initPop=fnGenerateInitPop(data)
#......................................................................#
#..........................Step-2.......................................#
#Defining Fitness function
#We input each chromosome and evaluate the fitness function for each chromosome
#Input x will be one chromosome

fnEvaluate = function(x){
  #Survival points for chromosome
  current_solution_survivalpoints =  x%*% data$survivalpoints
  
  #Total weight or the particular selection
  current_solution_weight = x %*% data$weight
  
  #Checking for weight limit of our selection
  if (current_solution_weight > weightlimit) 
    return(0) 
  else 
    return(current_solution_survivalpoints)
}
#.......................................................................#
#..........................Step-3.......................................#
#Reproduciton using Mutation
# mutation : We pick one position and change the value to 0 or 1 as the case may be

fnMutate = function(individual){
  #change one value to the other value 1 to 0 or 0 to 1 
  a = sample(1:length(individual),1)
  individual[a]=1-individual[a]
  
  return(individual)
}

#Reproduction using Crossover
# Crossover : randomly select a point and swap the tails
fnCrossOver = function(p1, p2){
  a = sample(2:(length(p1)-2), 1)
  p11 = c(p1[1:a], p2[(a+1):length(p2)])
  p12 = c(p2[1:a], p1[(a+1):length(p1)])
  
  return(list(p11,p12))
}
#...................................................................#
#Combining all the helper functions and building the final Genetic algorithm model
#Initial Population ---->Fitness Function(Survival of the fittest)--->
#Reproduction using Mutation or Crossover(Generate same population size
#as initial)------->Repeat

# Executing the genetic algorithm
fnRunGeneticAlgo= function(initPop, mutstartProb,
                           elitepercent, maxiterations,
                           MaxPossiblesurvivalpoints){
  
  counter=0   # is used for stopping criteria
  
  cat("max iterations =", maxiterations, "\n")
  # How many winners from each generation?
  
  origPopSize = nrow(initPop)
  topElite = round(elitepercent*origPopSize, 0)
  fitN = apply(initPop, 1, fnEvaluate)

  initPop = data.frame(initPop, fitN)
  initPop = initPop[order(-initPop$fitN),]

  # Main loop
  NewPop = initPop

  for (i in 1:maxiterations) {
    cat("i value is :", i, "\n")
    NewPop = NewPop[order(-NewPop$fitN),]
    ElitePop = NewPop[1:topElite,]
    
    NewPop = NewPop[, -c(length(colnames(NewPop)))]
    NewPop = NewPop[-(1:nrow(NewPop)), 1:nrow(data)]
    mut = mutstartProb/i
    
    # Add mutated and bred forms of the winners
    while (nrow(NewPop) < origPopSize) {

      # Mutation
      if (runif(1,0,1) < mut) {
        c = sample(1:topElite, 1)
        NewPop[nrow(NewPop)+1,] = fnMutate(ElitePop[c, 1:nrow(data)])
        if (nrow(NewPop)==origPopSize){break()}
      }
      
      # Crossover
      else {
        c1 = sample(1:topElite,1)
        c2 = sample(1:topElite,1)
        ls = (fnCrossOver(ElitePop[c1,1:nrow(data)], 
                          ElitePop[c2,1:nrow(data)]))
        NewPop[nrow(NewPop)+1,]=ls[[1]]
        NewPop[nrow(NewPop)+1,]=ls[[2]]
        if (nrow(NewPop)==origPopSize){break()}
      }
      
    }
    NewPop$fitN = apply(NewPop, 1, fnEvaluate)
    NewPop = NewPop[order(-NewPop$fitN),]
    
    # stopping criteria 
    if(NewPop[1, (nrow(data)+1)] == ElitePop[1, (nrow(data)+1)]){
      counter = counter+1
      if(counter==5){break()}
    }else{
      counter=0
    }
    #if (NewPop[1,(nrow(data)+1)] == MaxPossiblesurvivalpoints) {break()}
    cat("Total survival points in iteration", i, 
        " = ", NewPop[1,(nrow(data)+1)], "\n")
    
  }
  # Print current best score
  
  cat("Total survival points in iteration", i, " = ", 
      NewPop[1,(nrow(data)+1)], "\n")
  
  return(NewPop[1,])
}


fnExecuteMain = function(data, mutstartProb,
                         elitepercent, maxiterations, 
                         MaxPossiblesurvivalpoints){
  
  initPop = fnGenerateInitPop(data)
  
  solution = fnRunGeneticAlgo(initPop, mutstartProb, 
                              elitepercent, maxiterations,
                              MaxPossiblesurvivalpoints)
  
  Finalsolution = as.numeric(solution[1, 1:nrow(data)])
  selecteditems = data[Finalsolution == 1, ]
  
  # solution vs available
  cat(paste(Finalsolution %*% data$survivalpoints, "/", 
            sum(data$survivalpoints),"\n"))
  
  cat("Total Survivalpoints = ",
      sum(selecteditems$survivalpoints), "\n", 
      "Total weight = ",sum(selecteditems$weight))
  
  return(selecteditems)
}

mutstartProb=0.5
elitepercent=0.2
maxiterations=20

Result = fnExecuteMain(data, mutstartProb=0.5, 
                       elitepercent=0.2, maxiterations=20,
                       MaxPossiblesurvivalpoints)

