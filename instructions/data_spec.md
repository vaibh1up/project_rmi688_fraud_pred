## 1. Dataset Overview (sample 5 rows in csv format)
Claim_ID,Age,Gender,Policy_Inception_To_Claim,Years_With_Company,Claim_Amount,Vehicle_Value,Claim_Amount_Relative,Number_of_Claimants,Time_of_Incident,Incident_Day,Claim_Delay_Days,Prior_Claims,Region,Vehicle_Age,Policy_Coverage_Type,Annual_Mileage,Repair_Cost,Claim_Reason,Fraudulent
404,47.08284049,Female,1.915664729,17,11079.53193,42463.95183,0.260916176,1,Night,Weekend,6.712258665,4,Rural,8.86640609,Basic,11764.0251,10821.61535,Vandalism,0
9255,60.01989202,Female,5.664151073,16,5741.375988,20144.7033,0.285006729,2,Day,Weekday,23.68543048,4,Urban,9.675691492,Basic,17551.80216,5897.73432,Hail,0
9626,66.83114223,Female,11.26471987,14,13361.61753,37449.69292,0.35678844,2,Night,Weekend,62.18752813,4,Urban,8.607244799,Comprehensive,6486.125378,14594.8213,Collision,0
9469,24.82669829,Female,5.391874986,7,12036.31409,78744.45509,0.152852846,2,Day,Weekend,13.34800708,0,Suburban,16.53001041,Comprehensive,13889.75626,13648.48135,Pothole,0
6577,56.60099724,Female,5.216155347,10,3223.105771,28846.25611,0.111733937,3,Day,Weekday,7.515157852,1,Urban,12.2728725,Premium,15022.78976,3195.638264,Weather,1


## 2. Variable Description (in latex format)
Policy\_Inception\_To\_Claim & Time (in years) between policy inception and the filing of the claim. \\
Claim\_Amount & The total claim amount in US dollars. \\
Vehicle\_Value & The estimated market value of the insured vehicle. \\
Claim\_Amount\_Relative & Ratio of claim amount to vehicle value. \\
\hline
\multicolumn{2}{|l|}{\textit{Incident Information}} \\
\hline
Number\_of\_Claimants & Number of individuals making a claim under the same policy. \\
Time\_of\_Incident & Time of day when the incident occurred (Day/Night). \\
Incident\_Day & Whether the incident occurred on a weekday or weekend. \\
Claim\_Delay\_Days & Number of days between the incident and when the claim was filed. \\
\hline
\multicolumn{2}{|l|}{\textit{Additional Factors}} \\
\hline
Prior\_Claims & Number of prior claims made by the policyholder. \\
Region & Geographic region where the claim was filed (Urban, Suburban, Rural). \\
Vehicle\_Age & Age of the insured vehicle in years. \\
Policy\_Coverage\_Type & Type of policy coverage (Basic, Comprehensive, Premium). \\
Annual\_Mileage & Annual mileage driven by the vehicle in miles. \\
Repair\_Cost & Estimated cost of vehicle repairs. \\
Claim\_Reason & Reason for filing the claim (Collision, Deer, Animal, Pothole, Skid, Fire, Weather, Vandalism, etc.). \\

##3. Economic cost-benefit matrix
Result,Type,Value (Weight),Logic
True Positive (TP),Benefit,VTP= +10,Fraud stopped; saved loss and investigator time.
True Negative (TN),Benefit,VTN= +100,Smooth customer experience; no manual intervention.
False Positive (FP),Cost,VFP= -50,False Alarm; Cost of customer support and friction.
False Negative (FN),Cost,VFN= -500,Missed Fraud; Full loss of funds plus regulatory risk.

##4. optimization logic
$$U = (TP \times VTP) + (TN \times VTN) - (FP \times VFP) - (FN \times VFN)$$


