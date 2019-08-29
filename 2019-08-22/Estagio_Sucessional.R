rm(list=ls())

library(FuzzyR)

# Object "fis" instantiation
estagio <- newfis("Estagio Sucessional")

#Input Variables
estagio <- addvar(estagio, "input", "porte", c(0,60))
estagio <- addvar(estagio, "input", "DAP", c(0,120))
estagio <- addvar(estagio, "output", "estagio", c(0,10))

# *****------  USE BLOCK BELOW FOR TRAPEZOID MFs ------*****
# If Trapezoid Membership Functions must be used, Uncomment code below
# Variable "porte" - Trapezoid (trapmf)
estagio <- addmf(estagio,"input", 1, "peq", "trapmf", c(0,0,5,20) )
estagio <- addmf(estagio,"input", 1, "med", "trapmf", c(5,20,30,40))
estagio <- addmf(estagio,"input", 1, "gde", "trapmf", c(30,40,60,60) )


# Variable "DAP" - Trapezoid (trapmf)
estagio <- addmf(estagio,"input", 2, "fino", "trapmf", c(1,1,10,30) )
estagio <- addmf(estagio,"input", 2, "med", "trapmf", c(10,30,45,60))
estagio <- addmf(estagio,"input", 2, "grosso", "trapmf", c(45,60,120,120) )


# Output variable (Result)  - Trapezoid (trapmf)
estagio <- addmf(estagio,"output", 1, "pioneiro", "trapmf", c(0,0,2,3) )
estagio <- addmf(estagio,"output", 1, "inicial", "trapmf", c(2,3,4.5,5.5))
estagio <- addmf(estagio,"output", 1, "medio", "trapmf", c(4.5,5.5,7,8) )
estagio <- addmf(estagio,"output", 1, "avancado", "trapmf", c(7,8,10,10) )
# *****------  END OF TRAPEZTRAPEZOIDIDAL MFs BLOCK ------*****





# *****------  USE BLOCK BELOW FOR TRIANGULAR MFs ------*****
# # If triangular Membership Functions must be used, Uncomment code below
# # Variable "porte" - triangular  (trimf)
# estagio <- addmf(estagio,"input", 1, "peq", "trimf", c(0,0,20) )
# estagio <- addmf(estagio,"input", 1, "med", "trimf", c(0,20,40))
# estagio <- addmf(estagio,"input", 1, "gde", "trimf", c(20,60,60) )

#
# # Variable "DAP" - triangular (trimf)
# estagio <- addmf(estagio,"input", 2, "fino", "trimf", c(1,15,30) )
# estagio <- addmf(estagio,"input", 2, "med", "trimf", c(15,30,60))
# estagio <- addmf(estagio,"input", 2, "grosso", "trimf", c(30,120,120) )
#
# # Output variable (Result) - triangular (trimf)
# estagio <- addmf(estagio,"output", 1, "pioneiro", "trimf", c(0,0,2.5) )
# estagio <- addmf(estagio,"output", 1, "inicial", "trimf", c(0,2.5,5))
# estagio <- addmf(estagio,"output", 1, "medio", "trimf", c(2.5,5,7.5) )
# estagio <- addmf(estagio,"output", 1, "avancado", "trimf", c(5,10,10) )
# *****------  END OF TRIANGULAR MFs BLOCK ------*****



plotmf(estagio,"input",1) # "porte" Membership Function Visualization
plotmf(estagio,"input",2) # "DAP" Membership Function Visualization
plotmf(estagio,"output",1) # Output (result - Estagio Sucessional) Membership Function Visualization

# Rules, arranged as a matrix (Package Syntax)
rulelist <- rbind( c(1,1,1,1,1),
                  c(1,2,2,1,1),
                  c(1,3,3,1,1),

                  c(2,1,2,1,1),
                  c(2,2,3,1,1),
                  c(2,3,4,1,1),

                  c(3,1,3,1,1),
                  c(3,2,4,1,1),
                  c(3,3,4,1,1)
        )

estagio <- addrule(estagio, rulelist) # Add rules to the Fuzzy object/system

# gensurf(estagio) // System Plot
# showGUI(estagio) // Shiny Interactive GUI for the system

matrixInput <- matrix(c(20,30, # Actual Inputs
                        12,45, # First Var in the line is porte, second is DAP
                        34,62,
                        7,16,
                          10,10),ncol=2, byrow=TRUE) # Input vector has only one dimension, the ncol parameter converts it into a two-column matrix
evalfis(matrixInput,estagio) # System evaluation (results output to console)
