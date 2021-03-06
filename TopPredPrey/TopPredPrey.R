# Predator-prey spirals model, with euler integration
# Following Sherrat et al 2002 Proc. R. Soc. B 269, 327-334.

# First setup of the model
remove(list=ls()) # Remove all variables from memory

require("fields") # An R package to load

# ----- Non-dimensional parameter values ---------------------------------
A = 3.5                # A non-dimensional parameter linked to predator growth
B = 1.2                # A non-dimensional parameter linked to predator growth
C = 4.9                # A non-dimensional parameter linked to consumption of prey 
frac=0.01              # 0.01 - Fraction of area with predators 

# Simulation parameters
Length=500             # 512  - The length of the simulated landscape, in meters
m=100                  # 128  - # gridcellen
dT=0.2                 # 0.2  - timestep
EndTime=2000           #      - Time at which the simulation ends
Numframes=500          #      - Number of frames displayed during the entire simulation

WinWidth=12            #      - Width of the simulation window 
WinHeight=5            #      - Height of the simulation window

# Initialisation: declaring variable and setting up initial values
Prey = Pred = drPrey = drPred = NetPrey = NetPred =  matrix(nrow=m,ncol=m);

FXPrey = FXPred = matrix(nrow=m,ncol=m+1,data=0)  	 # flow in/out to X-direction
FYPrey = FYPred = matrix(nrow=m+1,ncol=m,data=0)    # flow in/out to Y-direction	

TimeRec = PreyRec = PredRec = vector(length = Numframes)

# ------ Initial setup and calculation ----------------------------------
DeltaX=Length/m;
DeltaY=Length/m;
mp = m+1

# initial states
Prey[,]=1; Pred=matrix(nrow=m,ncol=m, data=(runif(m*m)<=frac)*0.05)

Time  =  0        ; # Begin time 
ii    =  1e6      ; # Starting the plot counter with a high value
jj    =  0        ; # The counter needed for recording data during the run

#------- Setting up the figure ------------------------------------------

## Open a graphics window (Darwin stands for a Mac computer)
if (Sys.info()["sysname"]=="Darwin"){
  quartz(width=WinWidth, height=WinHeight, 
         title="Predator-prey model")
} else
  windows(width = WinWidth, height = WinHeight,
            title="Predator-prey model")

par(mfrow=c(1,2), mar=c(3, 4, 2, 6) + 0.1)

# ------------ The simulation loop ---------------------------------------
print(system.time(      # Prints the simulation time when finished
while (Time<=EndTime){  # Here the time loop starts 

  # Calculating local growth, consumption, assimilation and mortality
  drPrey = Prey*(1-Prey)-C/(1+C*Prey)*Prey*Pred ;
  drPred = Pred/(A*B)*(A*C*Prey/(1+C*Prey)-1);     
  drTopPred = TopPred/(A*B)*(A*C*Ped/(1+C*Pred)-1);     
    
  # calculate the dispersal of the prey
  FXPrey[,-c(1,m+1)] = -  (Prey[,-1]-Prey[,-m]) / DeltaX;   
  FYPrey[-c(1,m+1),] = -  (Prey[-1,]-Prey[-m,]) / DeltaY;

  # calculate the dispersal of the predator
  FXPred[,-c(1,m+1)] = -  (Pred[,-1]-Pred[,-m]) / DeltaX;   
  FYPred[-c(1,m+1),] = -  (Pred[-1,]-Pred[-m,]) / DeltaY;

	  # calculate the dispersal of the predator
  FXTopPred[,-c(1,m+1)] = -  (TopPred[,-1]-TopPred[,-m]) / DeltaX;   
  FYTopPred[-c(1,m+1),] = -  (TopPred[-1,]-TopPred[-m,]) / DeltaY;

  # calculate the net change at each location due to dispersal in and out
  NetPrey = (FXPrey[,-mp] - FXPrey[,-1])/DeltaX + (FYPrey[-mp,] - FYPrey[-1,])/DeltaY;
  NetPred = (FXPred[,-mp] - FXPred[,-1])/DeltaX + (FYPred[-mp,] - FYPred[-1,])/DeltaY;
  NetTopPred = (FXTopPred[,-mp] - FXTopPred[,-1])/DeltaX + (FYTopPred[-mp,] - FYTopPred[-1,])/DeltaY;

  # Summing up local processes and lateral flow to calculate new A and M
  Prey=Prey+(NetPrey+drPrey)*dT;
  Pred=Pred+(NetPred+drPred)*dT;
  
  # Graphic representation of the model every now and then
  if (ii>=EndTime/Numframes/dT)

      {image.plot(Prey, zlim=c(0,1), xaxt="n", yaxt="n",
             col = topo.colors(255),asp=1, bty="n",
             legend.shrink = 0.99, legend.width = 2)  
       title("Prey density")  
 
       image.plot(Pred, zlim=c(0,1), xaxt="n", yaxt="n",
             col = topo.colors(255),asp=1, bty="n",
             legend.shrink = 0.99, legend.width = 2)
       title("Predator density")  
       
       mtext(text=paste("Time : ",sprintf("%1.0f",Time),
                        "of" ,sprintf("%1.0f",EndTime), "days"), 
                        side=1, adj=-0.6, line=1.5, cex=1)

       # The following two lines prevent flickering of the screen
       dev.flush() # Force the model to update the graphs
       dev.hold()  # Put all updating on hold
       
       ii=0    # Resetting the plot counter 
       jj=jj+1 # Increasing the Recorder counter
       
       TimeRec[jj]=Time        # The time in days
       PreyRec[jj]=mean(Prey)  # Mean Prey biomass 
       PredRec[jj]=mean(Pred)  # Mean Pred biomass

      } 
      
  Time=Time+dT;  # Incrementing time by dT
  ii=ii+1

} ))

## Open a graphics window (Darwin stands for a Mac computer)
if (Sys.info()["sysname"]=="Darwin"){
  quartz(width=WinWidth, height=WinHeight, 
         title="Predator-prey model")
} else
  windows(width = WinWidth, height = WinHeight,
          title="Predator-prey model")

plot(TimeRec,PreyRec, col='blue', type="l", 
     xlab="Time", ylab="");
lines(TimeRec,PredRec, col="red")
 