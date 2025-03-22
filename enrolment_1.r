# library
library(luzlogr)
library(haven)
library(psych)
library(dplyr)
library(knitr)
#---------------------------------------------------------------------------------
#                               Globals
#---------------------------------------------------------------------------------
#--->Directories
#Project Directory
Dir<-"//Filedepot.eclient.wa.lcl/OFMFC/SECURE/ERDC/data/_Projects/R5082-OFM-K12Enrol-Absence-UserGuide/Data Guide/02_In_Data/"
#Read File Dir
enroll<-"cedars_enroll_2010_2018.sas7dbat"
#Log Directory
LDir<-"Logs/"

#--->File Names
#Log time
LTime<-format(Sys.time(), "%Y-%m-%d_%H.%M.%S")
#enrol Record Name
enroll_File<-file.path(paste(Dir, enroll, sep="" ))

#Log file name
Log<-file.path(paste(Dir, LDir, paste("enroll_", LTime, ".txt", sep=""), sep=""))
   
#--->Control Vars
ControlVars<-c("Gender",
				"GradeLevel",   
				"WithdrawalCD",
				"DateEnrolledinDistrict",   				
				"ForeignExchInd_Title",
				"HomeSchoolInd_Title",
				"PrivateSchoollInd_Title",
				"MilitaryParentGuardian_Title" 
				      )
 				
#--->Grouping Vars
GroupVars<-c("SchoolYear",
  				"DistrictCD"
 				)
 
#--->Identifiers
IDVars<-c("ResearchID",           
		"SchoolCD",           
		"ZipCode", 
		"DistrictCD",
		"Birth_Year_Month"               
                 )
#--->Binaries
BinVars<-c(
          "Gender",
		      "HomelessCD",
          "PrimarySchoolFlag", 
		      "F1VisaForeignExchgFlag",
		      "HomeBasedAttendPartTimeCD",  
		      "ApprvdPrivateSchoolAttendPartTim"
          )

#--->continious vars
ContVars<-c(
	"DisabilityCD",  
	"FederalEthRaceCD",	
	"PrimaryLanguageCD",
	"LanguageSpokenatHomeCD",	       
	"DateExitedDistrict",  
	"DateEnrolledinSchool", 
	"DateExitedSchool",               
	"ExpectedGradYear", 
	"GradReqYear",         
	"CumulativeCreditsAttempted",   
  "CumulativeCreditsEarned",         
	"NumDaysPresent",              
	"CumulativeGPA",        
	"MilitaryParentorGuardian"       
)

# #*********************************************************************************
# #                               Check Sums
# #*********************************************************************************
# # This function checks the valuse of summed columns
# #---------------------------------------------------------------------------------
# #   Dependancies:
# #                   Log (Global)
# #                   LDir (Global)
# #                   luzlogr (Library)
# #---------------------------------------------------------------------------------
# #   Inputs:
# #                   Sum	-	A vector of values to be checked
# #                   Components	-	An array of vectors that represent the sum 
# #										by row
# #---------------------------------------------------------------------------------
# #   Returns:  Number of failed matches (numeric)
# #---------------------------------------------------------------------------------
# #   Notes:  Basic logging
# #---------------------------------------------------------------------------------
# #   To Do:
# #                   -JSON logging
# #---------------------------------------------------------------------------------
# CheckDSums<-function(Sum, Components){
	# Sum[Sum==NA] <- 0
	# Components[Components==NA] <- 0
  # Total<-Components[,1]
	# for(i in 2:ncol(Components)){
		# Total<-Total + Components[,i]
	# }
	# match<-sum(ifelse(Sum==Total,1,0), na.rm=TRUE)
	# return(length(Sum)-match)
# }
# ##################################################################################
# ###############################-Main Program-#####################################
# ##################################################################################
# This is the execution program that handles error checking, logging, and most of 
# the typical tasks related to a program. Steps can be quickly added and removed
# by adding a function call or commenting out a function call without risking the
# stability of other sections.
#---------------------------------------------------------------------------------
#   Dependancies: N (Global)
#---------------------------------------------------------------------------------
#   Returns: Program_Success (Global)
#---------------------------------------------------------------------------------
#   Notes:
#---------------------------------------------------------------------------------
#   To Do:
#---------------------------------------------------------------------------------
#####----->Open Log<-----#####
openlog(Log, append = TRUE, sink = FALSE)

#####----->Data Loading<-----#####
#Read in SAS files
enrolldata <- read_sas(enroll_File)

#####----->Cleaning<-----#####
#--->Fix known deficencies
#Drop empty columns
enrolldata <- enrolldata[, unlist(lapply(enrolldata, function(x) !all(is.na(x))))]
printlog("Empty columns dropped\n")

# #--->Unique Constraints
# if(any(duplicated(enrolldata$WSACRecordNumber))){
#   #log(paste("Duplicated record warning in ", enrolldata, "file!"))
#   enrolldata <- enrolldata[!duplicated(enrolldata$WSACRecordNumber), ] 
# }
# printlog("Duplicated students removed\n")

#Ensure ID columns are dropped
enrolldata <- enrolldata[, !colnames(enrolldata) %in% c(IDVars)]
printlog("ID columns dropped\n")

#--->Range Constraints
#negative values do not make sense in this context
enrolldata[enrolldata<0] <- NA
printlog("Negative values removed\n")

#--->Manditory Constraints
#Fill blanks with NA
enrolldata[enrolldata==""] <- NA

# #--->Set Membership
# #Convert yes/no to binary
# enrolldata[enrolldata=="Y"] <- 1
# enrolldata[enrolldata=="N"] <- 0
# enrolldata[enrolldata=="Yes"] <- 1
# enrolldata[enrolldata=="No"] <- 0
# enrolldata[enrolldata=="F"] <- 1
# enrolldata[enrolldata=="M"] <- 0

# #rename "gender" to "female"
# enrolldata$Female<-as.numeric(enrolldata$Gender)
# enrolldata$Gender<-NULL
# printlog("Data formatted for mach. readability\n")

# #format continious variables
# for (z in seq(length(ContVars))){
  # enrolldata[,ContVars[z]]<-as.numeric(unlist(enrolldata[,ContVars[z]]))
# }

#####----->Column Totals<-----#####
#----->Describe data by year
  #Create list of possible years
  years<-unique(enrolldata$SchoolYear)
  #loop over years to generate single year reports
  for(k in seq(length(years))){
    #subset data by year
    dta<-subset(enrolldata, SchoolYear==years[k])
    #note in log
    printlog(paste("\n\n-----Summary Statistics for", years[k], "Unit Record----\n"))
    #note summary stats in the log
    #printlog(psych::describe(dta))
    
    #count NAs by school
    dta %>%
      group_by(DistrictCD) %>%
   #  select_if(function(x) any(is.na(x))) %>%
      summarise_all(funs(sum(is.na(.)))) -> NA_mydf
    
    #count number of rows by Inst code
    Obs<-as.data.frame(table(dta$DistrictCD))
    #rename columns from count to make them easier to work with
    colnames(Obs)<-c("DistrictCD", "NumbObs")
    #make sure the merged count is numeric
    Obs$NumObs<-as.numeric(Obs$NumbObs)
    #merge count into NA counts
    NA_mydf<-merge(NA_mydf, Obs, by="DistrictCD")
    #Designate how to create perctages
    funct<- function(x) x/NA_mydf$NumbObs
    #Convert NA counts to percent missing
    NA_mydf[ContVars]<-lapply(NA_mydf[ContVars],funct)
    #rebuild the data frame with insitution code, number of observations, and percentages
    NA_mydf<-data.frame(NA_mydf[,c("DistrictCD", "NumbObs")], NA_mydf[,2:length(NA_mydf)]/NA_mydf[,"NumbObs"])
    #Write percentage data frame out to a .csv file (log)
    write.csv(NA_mydf, file=file.path(paste(Dir, LDir, paste("enroll_YrXSch_", years[k], LTime, ".csv", sep=""), sep="")))
    
    #--->Determine how many rows and columns have issues with missing data
    #Drop empty columns
    dta <- dta[, unlist(lapply(dta, function(x) !all(is.na(x))))]
    
    #Note how many Missing rows
    printlog(paste("There were", NROW(na.omit(dta)), "rows with missing values of", NROW(dta), "total rows in the", years[k], "dataset."))
    #Note how many missing columns
    printlog(paste("There were", ncol(dta), "of non-emplty columns in the", years[k], "dataset."))
  }

#Ensure ID columns are dropped
enrolldata <- enrolldata[, !colnames(enrolldata) %in% c(IDVars)]
#printlog("ID columns dropped\n")

#####----->Summary Stats<-----#####
#printlog("\n\n-----Summary Statistics for enroll----\n")
#printlog(psych::describe(enrolldata))

# #####----->Validation<-----#####
# printlog("-----Logic Checks for UR Additive Calculations----\n")
# #ExpectedFamilyContribution check
# failedcheck<-as.numeric(CheckDSums(enrolldata[,"ExpectedFamilyContribution"], enrolldata[,c("ParentContribution", "StudentContribution")]))
# if (failedcheck==0){
  # printlog("ExpectedFamilyContribution check passed\n")
# } else{
  # printlog(paste("ExpectedFamilyContribution check FAILED in ", failedcheck, " cases.\n"))
# }
# #AllAidTotal check (source of aid)
# failedcheck<-as.numeric(CheckDSums(enrolldata[,"AllAidTotal"], enrolldata[,c("FedAidTotal", "StateAidTotal", "InstAidTotal" , "OtherAidTotal")]))
# if (failedcheck==0){
  # printlog("AllAidTotal/source of aid check passed\n")
# } else{
  # printlog(paste("AllAidTotal source of aid check FAILED in ", failedcheck, " cases.\n"))
# }
# #AllAidTotal check (aid type)
# failedcheck<-as.numeric(CheckDSums(enrolldata[,"AllAidTotal"], enrolldata[,c("GrantAidTotal" , "WorkAidTotal" , "LoanAidTotal")]))
# if (failedcheck==0){
  # printlog("AllAidTotal/aid type check passed\n")
# } else{
  # printlog(paste("AllAidTotal aid type check FAILED in ", failedcheck, " cases.\n"))
# }
# #FedAidTotal check
# failedcheck<-as.numeric(CheckDSums(enrolldata[,"FedAidTotal"], enrolldata[,c("FedPellGrant", "FedSEOG", 
		# "FedAcadCompetitivenessGrantYear1", "FedAcadCompetitivenessGrantYear2", "FedSMARTGrantYear3",
		# "FedSMARTGrantYear4", "FedWorkStudy", "FedPerkinsLoan", "FedDirectSubsidizedLoan",
		# "FedDirectUnsubsidizedLoan", "FedUnsubsidizedLoans", "FedParentPLUSLoan", "FedGradPLUSLoan",
		# "FedNursingScholarships", "FedNursingHealthLoans", "FedTEACHGrant")]))
# if (failedcheck==0){
  # printlog("FedAidTotal check passed\n")
# } else{
  # printlog(paste("FedAidTotal check FAILED in ", failedcheck, " cases."))
# }
# #StateAidTotal check
# failedcheck<-as.numeric(CheckDSums(enrolldata[,"StateAidTotal"], enrolldata[,c("StateNeedGrant", "StateCollegeBoundScholarship",
		# "StateWorkforceTraining", "StateSBCTCOpportunityGrant", "StatePassportScholarship",
		# "StateOpportunityScholarship", "StateEdOpportunityGrant", "StateOtherGiftAid", "StateWorkStudyTotal",
		# "StateWorkStudyOnCampus", "StateWorkStudyOffCampus", "StateGETReadyForMathAndScience")]))
# if (failedcheck==0){
  # printlog("StateAidTotal check passed\n")
# } else{
  # printlog(paste("StateAidTotal check FAILED in ", failedcheck, " cases."))
# }
# #InstAidTotal check
# failedcheck<-as.numeric(CheckDSums(enrolldata[,"InstAidTotal"], enrolldata[,c("InstGrantsWaivers", "InstGrants",
		# "InstNeedBasedWaiversPublic", "InstNeedBasedWaivers", "InstNonNeedBasedWaivers", "InstAidFundGrants",
		# "InstNeedBasedGiftAid", "InstNonNeedBasedGiftAid", "InstSubstitutionStateNeedGrant", "InstEmployment",
		# "InstLoans" )]))
# if (failedcheck==0){
  # printlog("InstAidTotal check passed\n")
# } else{
  # printlog(paste("InstAidTotal check FAILED in ", failedcheck, " cases."))
# } 
# #OtherAidTotal check
# failedcheck<-as.numeric(CheckDSums(enrolldata[,"OtherAidTotal"], enrolldata[,c("OtherGrantsWAAgencies", "OtherGrantsAgencies",
		# "OtherGrantsNonWAAgencies", "OtherGrantsPrivate", "OtherLoansConditional", "OtherLoansPrivate",
		# "OtherAndInstLoansAllTypes", "OtherLoansAgencies" )]))
# if (failedcheck==0){
  # printlog("OtherAidTotal check passed\n")
# } else{
  # printlog(paste("OtherAidTotal check FAILED in ", failedcheck, " cases."))
# }                

#####----->Close Log<-----#####
closelog(sessionInfo = TRUE)

#always return
#return(FALSE)
