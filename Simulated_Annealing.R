rm(list=ls(all=TRUE))

dataSet = data.frame(stock = c("Tesla", "Google", "Microsoft",
                               "Facebook", "Apple", "GM"),
                     returns = c(0.0119, 0.0393, 0.0178, 0.0791, 0.0189, 0.0213))
minInvestment = 0.03

#we have an amount of 100k dollars to invest
amount=100000

#The minimum retuen we want is 10% i.e., 10k dollars
stoppingCriteria = 10000
weightLimit = 1


#We  have to determine the amount to invest in each stock
#We will first initiate a solution with almost equal weights to make it total 1
fnInitialSolu <- function(){
  
  
  initialSolu = c(0.16, 0.17, 0.16, 0.17, 0.17, 0.17)
  
  return(initialSolu)
}

# Evaluation function.
fnEvaluate = function(dataSet, weightLimit, solution, amount) {
  
  individualInvestments = (solution * rep(amount, length(solution)))
  
  totalReturns = dataSet$returns %*% individualInvestments               
  
  if (round(sum(solution), 1) != weightLimit) 
    return(0) 
  else 
    return(totalReturns)
}


# Purterbation function: randomly select a point and do operation
fnPurterb = function(solution){
  
  idx = sample(1:length(solution), 2)
  
  purtSolution = solution
  
  x = solution[idx[1]]
  y = solution[idx[2]]
 
  # Taking the diff of 1st stock weight and 0.03 and take half of it 
  # Subtract that value and the same value to the secnd stock weight 
  # (As total should be 1)
  
  diff = ((solution[idx[1]] - 0.03)/2)
  purtSolution[idx[1]] = solution[idx[1]] - diff
  purtSolution[idx[2]] = solution[idx[2]] + diff

  return(purtSolution)
}



fnRunSimulatedAnnealingAlgo = function(maxIterations, amount){

  cat("Max iterations =", maxIterations, "\n")
  
  # Generate a random solution
  initialSolu = fnInitialSolu()

  initialVal = fnEvaluate(dataSet, weightLimit, initialSolu, amount)
  
  baseSolu = initialSolu
  baseVal = initialVal
  counter = 0
  
  # solution vs available
  cat(paste("Baseval initially is : ", baseVal, "\n"))
  
  for (i in 1:maxIterations) {
    
    # Purterbation
    nextSolu = fnPurterb(baseSolu)
    nextVal = fnEvaluate(dataSet, weightLimit, nextSolu, amount)
    
    if(any(nextSolu > 0.03) == FALSE){
      return(0)
    }
    else{
      counter = counter + 1
      
      if(nextVal > baseVal){
        baseSolu = nextSolu
        baseVal = nextVal
      }
      else{
        # Accept with acceptence probability
        acceptanceProb = runif(1, 0, 1)
        if(acceptanceProb > 0.5){
          baseSolu = nextSolu
          baseVal = nextVal
        }
      }
    }
    if (baseVal >= stoppingCriteria){break()}     
    i = counter
    
    # solution 
    cat("Returns in ", i, "iteration is : ", baseVal,"\n")
  }
  return(list(baseSolu, baseVal)) 
}



fnExecuteMain = function(dataSet, maxIterations, amount){
  
  set.seed(1234)
  
  solutionList = fnRunSimulatedAnnealingAlgo(maxIterations, amount)
  
  finalSolution = as.numeric(solutionList[[1]])
  finalSolutionValue = solutionList[[2]]
  
  dataSet$finalSolution = finalSolution
  
  cat("Total returns = ", finalSolutionValue,"\n")
  return(dataSet)
}

result = fnExecuteMain(dataSet, maxIterations = 1000, amount = 100000)

result

